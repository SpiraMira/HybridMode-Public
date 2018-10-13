#!/bin/bash
#
# webdriver.sh - bash script for managing Nvidia's web drivers
# Copyright © 2017-2018 vulgo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

NEVER_PATCH_PLISTS=0
LAST_SUPPORTED_MACOS_VERSION=18 # Mojave

SCRIPT_VERSION="1.5.6"
test -t 0 && R='\e[0m' B='\e[1m' U='\e[4m'
grep="/usr/bin/grep"
shopt -s nullglob extglob
if ! LOCAL_BUILD=$(/usr/sbin/sysctl -n kern.osversion); then
	printf 'sysctl error'
	exit $?
fi
LOCAL_MAJOR="${LOCAL_BUILD:0:2}"
if ((LOCAL_MAJOR < 17 || LOCAL_MAJOR > LAST_SUPPORTED_MACOS_VERSION)); then
	printf 'Unsupported macOS version'
	exit 1
fi
DRIVERS_DIR_HINT="NVWebDrivers.pkg"
STARTUP_KEXT="/Library/Extensions/NVDAStartupWeb.kext"
EGPU_KEXT="/Library/Extensions/NVDAEGPUSupport.kext"
ERR_PLIST_READ="Couldn't read a required value from a property list"
ERR_PLIST_WRITE="Couldn't set a required value in a property list"
SET_NVRAM="/usr/sbin/nvram nvda_drv=1%00" UNSET_NVRAM="/usr/sbin/nvram -d nvda_drv"
CHANGES_MADE=false RESTART_REQUIRED=false REINSTALL_MESSAGE=false KEEP_KEXTCACHE_OUTPUT=false

# SIP
KEXT_ALLOWED=false
FS_ALLOWED=false
/usr/bin/csrutil status | $grep -qiE -e "status: disabled|signing: disabled" && KEXT_ALLOWED=true
/usr/bin/touch /System 2> /dev/null && FS_ALLOWED=true
$FS_ALLOWED && [[ -d /Library/GPUBundles/GeForceGLDriverWeb.bundle ]] && STAGED_BUNDLES_EXIST=1

# # FakeSMC present? -> Clover boot log?
# FAKE_SMC=false
# if kextstat | $grep -qi -e "fakesmc"; then
# 	FAKE_SMC=true
# 	BOOT_LOG="$(/usr/sbin/ioreg -p IODeviceTree -c IOService -k boot-log -rd 1 \
# 		| $grep 'boot-log' | /usr/bin/awk -v FS="(<|>)" '{print $2}' | /usr/bin/xxd -r -p)"
# fi

function usage() {
	local -i status=$1
	if [[ $(/usr/bin/dirname "$0") == "." ]]; then
		BASENAME="./$(/usr/bin/basename "$0")"
	else
		BASENAME="$(/usr/bin/basename "$0")"
	fi
	printf 'Usage: %s [-i] [-f] [-l|-u|-r|-m|FILE]\n' "$BASENAME"	
	printf '   --install or   -i          install patches\n'
	printf '   --list    or   -l          choose which patches to install from a list\n'
	printf '   --url     or   -u URL      download package from URL and install drivers\n'
	printf '   --remove  or   -r          uninstall patches\n'
	printf '                  -f          continue when same version already installed\n'
	exit $((status))
}

# ************* PARSE ARGUMENTS **************

RAW_ARGS=("$@")
set --
TASK_COUNT=0
OPT_REINSTALL_SAME=false
OPT_LIST_MORE=false
OPT_YES=false

for arg in "${RAW_ARGS[@]}"
do
	case "$arg" in
	@(|-|--)help)
		set -- "$@" "-h"
		;;
	@(|-|--)list)
		set -- "$@" "-l"
		;;
	@(|-|--)url)
		set -- "$@" "-u"
		;;
	@(|-|--)remove)
		set -- "$@" "-r"
		;;
	@(|-|--)uninstall)
		set -- "$@" "-r"
		;;
	@(|-|--)stage)
		set -- "$@" "-s"
		;;
	@(|-|--)version)
		set -- "$@" "-v"
		;;
	*)
		set -- "$@" "$arg"
		;;
	esac
done

while getopts ":hvlu:rm:fa#:sY" OPTION; do
	case $OPTION in
	"h")
		usage
		;;
	"v")
		printf 'patch.sh %s Copyright © 2017-2018 pkouame\n' "$SCRIPT_VERSION"
		printf 'This is free software: you are free to change and redistribute it.\n'
		printf 'There is NO WARRANTY, to the extent permitted by law.\n'
		printf 'See the GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>\n'
		exit 0
		;;
	"l")
		TASK="CHOOSE FROM LIST"
		OPT_REINSTALL_SAME=true
		TASK_COUNT+=1
		;;
	"u")
		TASK="USER URL"
		REMOTE_URL="$OPTARG"
		TASK_COUNT+=1
		;;
	"r")
		TASK="UNINSTALL"
		TASK_COUNT+=1
		;;
	"f")
		OPT_REINSTALL_SAME=true
		;;
	"a")
		OPT_LIST_MORE=true
		;;
	"#")
		REMOTE_CHECKSUM="$OPTARG"
		;;
	"s")
		if $FS_ALLOWED; then
			OPT_ALWAYS_STAGE_BUNDLES=true
		elif [[ $(/usr/bin/id -u) == "0" ]]; then
			printf 'Always stage bundles was specified, but filesystem protections are already enabled\n'
		fi
		;;
	"Y")
		OPT_YES=true
		;;
	"?")
		printf 'Invalid option: -%s\n' "$OPTARG"
		usage 1
		;;
	":")
		if [[ $OPTARG == "m" ]]; then
			OPT_REQUIRED_OS="$LOCAL_BUILD"
			TASK="PATCH STARTUP PERSONALITIES"
			TASK_COUNT+=1
		else
			printf 'Missing parameter for -%s\n' "$OPTARG"
			usage 1
		fi
		;;
	esac
	if ((TASK_COUNT > 1)); then
		printf 'Too many options\n'
		usage 1
	fi
done

if ((TASK_COUNT == 0)); then
	shift $((OPTIND - 1))
	while (($# > 0)); do
		if [[ -f "$1" ]]; then
			TASK="FILE"
			OPT_FILEPATH="$1"
			break
		fi
		shift
	done
fi

# **** OPTIONS ARE VALID SO RE-RUN AS ROOT IF WE ARE NOT ****

[[ $(/usr/bin/id -u) != "0" ]] && exec /usr/bin/sudo -u root "$0" "${RAW_ARGS[@]}"

# **** TEMPORARY FILES ****

# shellcheck disable=SC2064
uuidgen="/usr/bin/uuidgen"
TMP_DIR=$(/usr/bin/mktemp -dt webdriver)
trap 'rm -rf $TMP_DIR; stty echo echok; exit' SIGINT SIGTERM SIGHUP
UPDATES_PLIST="${TMP_DIR}/$($uuidgen)"
INSTALLER_PKG="${TMP_DIR}/$($uuidgen)"
EXPAND_FULL="${TMP_DIR}/$($uuidgen)"
DRIVERS_PKG="${TMP_DIR}/com.nvidia.web-driver.pkg"

# **** FUNCTIONS ****

function s() {
	# $@: args... 
	"$@" > /dev/null 2>&1
	return $?
}

function e() {
	# $1: message, $2: exit_code
	s rm -rf "$TMP_DIR"
	if [[ -z $2 ]]; then
		printf '%bError%b: %s\n' "$U" "$R" "$1"
	else
		printf '%bError%b: %s (%s)\n' "$U" "$R" "$1" "$2"
	fi
	$CHANGES_MADE && $UNSET_NVRAM
	! $CHANGES_MADE && printf 'No changes were made\n'
	exit 1
}

function exit_quietly() {
	s rm -rf "$TMP_DIR"
	exit 0
}

function exit_after_changes() {
	MSG="$1"
	[[ -z $1 ]] && MSG="Complete."
	s rm -rf "$TMP_DIR"
	printf '%s' "$MSG"
	$RESTART_REQUIRED && printf ' You should reboot now.'
	printf '\n'
	if [[ $KEXTCACHE_ERR ]] && ask "Show kextcache output?"; then
		echo "$KEXTCACHE_ERR"
	fi
	exit 0
}

function warning() {
	# $1: message
	printf '%bWarning%b: %s\n' "$U" "$R" "$1" 
}

function uninstall_drivers() {
	local REMOVE_LIST=(/Library/Extensions/+(GeForce|NVDA)*Web* 
		/System/Library/Extensions/+(GeForce|NVDA)*Web* \
		/Library/GPUBundles/GeForce*Web*)
	REMOVE_LIST=("${REMOVE_LIST[@]/$EGPU_KEXT}")
	# shellcheck disable=SC2086
	s /bin/rm -rf "${REMOVE_LIST[@]}"
	/usr/sbin/kextcache -clear-staging
	s pkgutil --forget com.nvidia.web-driver
}

function update_caches() {
	printf '%bUpdating caches...%b\n' "$B" "$R"
	load_all
	if $KEEP_KEXTCACHE_OUTPUT; then
		KEXTCACHE_ERR=$( (/usr/sbin/kextcache -i / 2>&1) )
	else
		s /usr/sbin/kextcache -i /
	fi
}

function ask() {
	# $1: prompt message
	local ASK
	printf '%b%s%b' "$B" "$1" "$R"
	read -n 1 -srp " [y/N]" ASK
	printf '\n'
	if [[ $ASK == "y" || $ASK == "Y" ]]; then
		return 0
	else
		return 1
	fi
}

function plistb() {
	# $1: plistbuddy command, $2: property list
	local RESULT
	[[ ! -f "$2" ]] && return 1
	! RESULT=$(/usr/libexec/PlistBuddy -c "$1" "$2" 2> /dev/null) && return 1
	[[ $RESULT ]] && printf "%s" "$RESULT"
	return 0
}

# function set_required_os() {
# 	# $1: target macos version
# 	KEXTS=("${STARTUP_KEXT}" "${EGPU_KEXT}")
# 	local NVDA_REQUIRED_OS TARGET_BUILD="$1" KEY=":IOKitPersonalities:NVDAStartup:NVDARequiredOS"
# 	for KEXT in "${KEXTS[@]}"; do
# 		if [[ -f "${KEXT}/Contents/Info.plist" ]]; then
# 			NVDA_REQUIRED_OS=$(plistb "Print ${KEY}" "${KEXT}/Contents/Info.plist") || e "$ERR_PLIST_READ"
# 			if [[ $NVDA_REQUIRED_OS == "$TARGET_BUILD" ]]; then
# 				printf '%s: Already set to %b%s%b\n' "$(basename "$KEXT")"  "$B" "$TARGET_BUILD" "$R"
# 		        else
# 				printf '%s: %s -> %b%s%b\n' "$(basename "$KEXT")" "$NVDA_REQUIRED_OS" "$B" "$TARGET_BUILD" "$R"
# 				CHANGES_MADE=true
# 				plistb "Set ${KEY} ${TARGET_BUILD}" "${KEXT}/Contents/Info.plist" || e "$ERR_PLIST_WRITE"
# 			fi
# 		fi
# 	done
# 	RESTART_REQUIRED=true
# 	if ! $KEXT_ALLOWED && ! s /usr/bin/codesign -v "$STARTUP_KEXT"; then
# 		warning "Disable SIP, run 'kextcache -i /' to allow modified drivers to load"
# 		KEEP_KEXTCACHE_OUTPUT=true
# 		RESTART_REQUIRED=false
# 	fi
# }

# function check_ngfxcompat() {
# 	if kextstat | $grep -qiE -e 'nvidiagraphicsfixup|whatevergreen'; then
# 		$grep -i -e 'boot-args=' <<< "$BOOT_LOG" | $grep -qi -e 'ngfxcompat=1' && return 0
# 		/usr/sbin/nvram boot-args 2> /dev/null | $grep -qi -e 'ngfxcompat=1' && return 0
# 		/usr/sbin/ioreg -c IOPCIDevice -rd 1 -k force-compat | $grep -qi -e 'force-compat' && return 0
# 	fi
# 	return 1
# }

# function check_kextsToPatch() {
# 	if $grep -qiE -e 'nvdastartupweb.*allowed' <<< "$BOOT_LOG"; then
# 		return 0
# 	else
# 		return 1
# 	fi
# }

# function check_required_os() {
# 	[[ ! -f "${STARTUP_KEXT}/Contents/Info.plist" ]] && return 0
	
# 	local RESULT KEY=":IOKitPersonalities:NVDAStartup:NVDARequiredOS"
# 	RESULT=$(plistb "Print $KEY" "${STARTUP_KEXT}/Contents/Info.plist") || e "$ERR_PLIST_READ"
	
# 	[[ $RESULT == "$LOCAL_BUILD" ]] && return 0
		
# 	# WhateverGreen/NvidiaGraphicsFixup
# 	check_ngfxcompat && return 0
		
# 	# KextsToPatch
# 	# $FAKE_SMC && check_kextsToPatch && return 0
		
# 	# Plist patching
# 	((NEVER_PATCH_PLISTS == 1)) && return 0
		
# 	ask "Modify installed driver for the current macOS version?" || return 0
# 	set_required_os "$LOCAL_BUILD"
# 	return 1
# }

# function sql_add_kext() {
# 	# $1: bundle id
# 	SQL+="insert or replace into kext_policy (team_id, bundle_id, allowed, developer_name, flags) "
# 	SQL+="values (\"6KR3T733EC\",\"${1}\",1,\"NVIDIA Corporation\",1); "
# }

# function match_build() {
# 	# $1: local, $2: remote
# 	local -i LOCAL=$1 REMOTE=$2
# 	local PREVIOUS=$((LOCAL - 1)) NEXT=$((LOCAL + 1))
# 	if ((REMOTE == NEXT)) ; then
# 		return 0
# 	fi
# 	if ((REMOTE >= 17)) && ((REMOTE == PREVIOUS)); then
# 		return 0
# 	fi
# 	return 1
# }

# function stage_bundles() {
# 	/bin/mkdir -p /Library/GPUBundles
# 	/usr/bin/rsync -r /System/Library/Extensions/GeForce*Web*.bundle /Library/GPUBundles
# } 2> /dev/null

# function load_all() {
# 	/sbin/kextload /Library/Extensions/NVDA* /Library/Extensions/GeForce* /System/Library/Extensions/AppleHDA.kext
# } > /dev/null 2>&1

# TASK == PATCH STARTUP PERSONALITIES

if [[ $TASK == "PATCH STARTUP PERSONALITIES" ]]; then
	if [[ ! -f "${STARTUP_KEXT}/Contents/Info.plist" ]]; then
		printf 'NVIDIA driver not found\n'
		$UNSET_NVRAM
		exit_quietly
	else
		set_required_os "$OPT_REQUIRED_OS"
	fi
	if $CHANGES_MADE; then
		update_caches
		$SET_NVRAM
		exit_after_changes
	else
		exit_quietly
	fi
fi

# TASK == UNINSTALL

if [[ $TASK == "UNINSTALL" ]]; then
	ask "Uninstall NVIDIA web drivers?" || exit_quietly
	printf '%bRemoving files...%b\n' "$B" "$R"
	CHANGES_MADE=true
	RESTART_REQUIRED=true
	uninstall_drivers
	update_caches
	$UNSET_NVRAM
	exit_after_changes "Uninstall complete."
fi

# ******************* START OF PACKAGE CHOOSER *******************

if [[ $TASK == "USER URL" ]]; then
	# Invoked with -u option, proceed to installation
	printf 'URL: %s\n' "$REMOTE_URL"
elif [[ $TASK == "FILE" ]]; then
	# Parsed file path, proceed to installation
	printf 'File: %s\n' "$OPT_FILEPATH"
else
	# No URL / filepath
	if [[ $TASK == "CHOOSE FROM LIST" ]]; then
		declare -a LIST_URLS LIST_VERSIONS LIST_CHECKSUMS LIST_BUILDS
		declare -i VERSION_MAX_WIDTH
	fi
	# Get installed version
	INFO_STRING=$(plistb "Print :CFBundleGetInfoString" "/Library/Extensions/GeForceWeb.kext/Contents/Info.plist")
	[[ $INFO_STRING ]] && INSTALLED_VERSION="${INFO_STRING##* }"
	# Get updates file
	printf '%bChecking for updates...%b\n' "$B" "$R"
	/usr/bin/curl -s --connect-timeout 15 -m 45 -o "$UPDATES_PLIST" "https://gfestage.nvidia.com/mac-update" \
		|| e "Couldn't get updates data from NVIDIA" $?
	# shellcheck disable=SC2155
	declare -i c=$($grep -c "<dict>" "$UPDATES_PLIST")
	for ((i = 0; i < c - 1; i += 1)); do
		unset -v "REMOTE_BUILD" "REMOTE_MAJOR" "REMOTE_URL" "REMOTE_VERSION" "REMOTE_CHECKSUM"
		! REMOTE_BUILD=$(plistb "Print :updates:${i}:OS" "$UPDATES_PLIST") && break			
		if [[ $REMOTE_BUILD == "$LOCAL_BUILD" || $TASK == "CHOOSE FROM LIST" ]]; then
			REMOTE_MAJOR=${REMOTE_BUILD:0:2}
			REMOTE_URL=$(plistb "Print :updates:${i}:downloadURL" "$UPDATES_PLIST")
			REMOTE_VERSION=$(plistb "Print :updates:${i}:version" "$UPDATES_PLIST")
			REMOTE_CHECKSUM=$(plistb "Print :updates:${i}:checksum" "$UPDATES_PLIST")
			if [[ $TASK == "CHOOSE FROM LIST" ]]; then
				if [[ $LOCAL_MAJOR == "$REMOTE_MAJOR" ]] || ($OPT_LIST_MORE && match_build "$LOCAL_MAJOR" "$REMOTE_MAJOR"); then
					LIST_URLS+=("$REMOTE_URL")
					LIST_VERSIONS+=("$REMOTE_VERSION")
					LIST_CHECKSUMS+=("$REMOTE_CHECKSUM")
					LIST_BUILDS+=("$REMOTE_BUILD")
					[[ ${#REMOTE_VERSION} -gt $VERSION_MAX_WIDTH ]] && VERSION_MAX_WIDTH=${#REMOTE_VERSION}
				fi
				((${#LIST_VERSIONS[@]} > 47)) && break
				continue
			fi	
			break
		fi
	done;
	if [[ $TASK == "CHOOSE FROM LIST" ]]; then
		MACOS_PRODUCT_VERSION="$(/usr/bin/sw_vers -productVersion)"
		while true; do
			printf '%bCurrent driver:%b ' "$B" "$R"
			if [[ $INSTALLED_VERSION ]]; then
				printf '%s\n' "$INSTALLED_VERSION"
			else
				printf 'Not installed\n'
			fi
			printf '%bRunning on:%b macOS %s (%s)\n\n' "$B" "$R" "$MACOS_PRODUCT_VERSION" "$LOCAL_BUILD"
			LIST_COUNT=${#LIST_VERSIONS[@]}
			[[ $LIST_COUNT -eq 0 ]] && e "No drivers available for $MACOS_PRODUCT_VERSION, -a lists incompatible versions."
			FORMAT_COMMAND="/usr/bin/tee"
			TPUT_LINES=$(/usr/bin/tput lines)
			MAX_ROWS=$((TPUT_LINES - 5))
			if ((LIST_COUNT > MAX_ROWS)) || ((LIST_COUNT > 15)); then
				FORMAT_COMMAND="/usr/bin/column"
			fi
			VERSION_FORMAT_STRING="%-${VERSION_MAX_WIDTH}s"
			for ((i = 0; i < LIST_COUNT; i += 1)); do
				ROW="$(printf '%6s.' $((i + 1)))"
				ROW+="  "
				# shellcheck disable=SC2059
				ROW+="$(printf "$VERSION_FORMAT_STRING" "${LIST_VERSIONS[$i]}")"
				ROW+="  "
				ROW+="${LIST_BUILDS[$i]}"
				printf '%s\n' "$ROW"
			done | $FORMAT_COMMAND
			printf '\n'
			printf '%bWhat now?%b [1-%s] : ' "$B" "$R" "$LIST_COUNT"
			read -r int
			[[ -z $int ]] && exit_quietly
			if [[ $int =~ ^[0-9] ]] && ((int >= 1)) && ((int <= LIST_COUNT)); then
				((int -= 1))
				REMOTE_URL=${LIST_URLS[$int]}
				REMOTE_VERSION=${LIST_VERSIONS[$int]}
				REMOTE_BUILD=${LIST_BUILDS[$int]}
				REMOTE_CHECKSUM=${LIST_CHECKSUMS[$int]}
				break
			fi
			printf '\nTry again...\n\n'
			/usr/bin/tput bel
		done
	fi
	# Determine next action
	if [[ -z $REMOTE_URL ]] || [[ -z $REMOTE_VERSION ]]; then
		# No driver available, or error during check, exit
		printf 'No driver available for %s\n' "$LOCAL_BUILD"
		if ! check_required_os; then
			update_caches
			$SET_NVRAM
			exit_after_changes
		fi
		exit_quietly
	elif [[ $REMOTE_VERSION == "$INSTALLED_VERSION" ]]; then
		# Chosen version already installed
		if [[ -f ${STARTUP_KEXT}/Contents/Info.plist ]]; then
			REQUIRED_OS_KEY=":IOKitPersonalities:NVDAStartup:NVDARequiredOS"
			LOCAL_REQUIRED_OS=$(plistb "Print $REQUIRED_OS_KEY" "${STARTUP_KEXT}/Contents/Info.plist"); fi
		if [[ $LOCAL_REQUIRED_OS ]]; then
			printf '%s for %s already installed\n' "$REMOTE_VERSION" "$LOCAL_REQUIRED_OS"
		else
			printf '%s already installed\n' "$REMOTE_VERSION"
			OPT_REINSTALL_SAME=true
		fi
		if ! s codesign -v "$STARTUP_KEXT"; then
			printf 'Invalid signature: '
			$KEXT_ALLOWED && printf 'Allowed\n'
			! $KEXT_ALLOWED && printf 'Not allowed\n'
		fi		
		if ! check_required_os; then
			update_caches
			$SET_NVRAM
			exit_after_changes
		fi
		if $OPT_REINSTALL_SAME; then
			REINSTALL_MESSAGE=true
		else
			exit_quietly
		fi
	else
		if [[ $TASK == "CHOOSE FROM LIST" ]]; then
			printf 'Selected: %s for %s\n' "$REMOTE_VERSION" "$REMOTE_BUILD"
		else
			printf 'Web driver %s available...\n' "$REMOTE_VERSION"
		fi
	fi
fi

# ***************** START OF INSTALLER *****************

if $OPT_YES; then
	:
elif $REINSTALL_MESSAGE; then
	ask "Re-install?" || exit_quietly
else
	ask "Install?" || exit_quietly
fi

if [[ $TASK != "FILE" ]]; then
	# Check URL
	REMOTE_HOST=$(printf '%s' "$REMOTE_URL" | /usr/bin/awk -F/ '{print $3}')
	if ! s /usr/bin/host "$REMOTE_HOST"; then
		[[ $TASK == "USER URL" ]] && e "Unable to resolve host, check your URL"
		REMOTE_URL="https://images.nvidia.com/mac/pkg/"
		REMOTE_URL+="${REMOTE_VERSION%%.*}"
		REMOTE_URL+="/WebDriver-${REMOTE_VERSION}.pkg"
	fi
	HEADERS=$(/usr/bin/curl -I "$REMOTE_URL" 2>&1) || e "Failed to download HTTP headers"
	$grep -qe "octet-stream" <<< "$HEADERS" || warning "Unexpected HTTP content type"
	[[ $TASK != "USER URL" ]] && printf 'URL: %s\n' "$REMOTE_URL"

	# Download
	printf '%bDownloading package...%b\n' "$B" "$R"
	/usr/bin/curl --connect-timeout 15 -# -o "$INSTALLER_PKG" "$REMOTE_URL" || e "Failed to download package" $?

	# Checksum
	LOCAL_CHECKSUM=$(/usr/bin/shasum -a 512 "$INSTALLER_PKG" 2> /dev/null | /usr/bin/awk '{print $1}')
	if [[ $REMOTE_CHECKSUM ]]; then
		if [[ $LOCAL_CHECKSUM == "$REMOTE_CHECKSUM" ]]; then
			printf 'SHA512: Verified\n'
		else
			e "SHA512 verification failed"
		fi
	else
		printf 'SHA512: %s\n' "$LOCAL_CHECKSUM"
	fi
else
	/bin/cp "$OPT_FILEPATH" "$INSTALLER_PKG"
fi

# Unflatten

# mayankk2308: use --expand-full to expand packages and payloads
printf '%bExtracting...%b\n' "$B" "$R"
/usr/sbin/pkgutil --expand-full "$INSTALLER_PKG" "$EXPAND_FULL" || e "Failed to extract package" $?
DIRS=("$EXPAND_FULL"/*"$DRIVERS_DIR_HINT")
if [[ ${#DIRS[@]} -eq 1 ]] && [[ -d ${DIRS[0]} ]]; then
        DRIVERS_COMPONENT_DIR=${DIRS[0]}
else
        e "Failed to find drivers payload parent directory"
fi
DRIVERS_ROOT="${DRIVERS_COMPONENT_DIR}/Payload"
if [[ ! -d ${DRIVERS_ROOT}/Library/Extensions || ! -d ${DRIVERS_ROOT}/System/Library/Extensions ]]; then
	e "Drivers payload has an unexpected directory structure"
fi

# User-approved kernel extension loading

QUERY="select bundle_id from kext_policy where team_id=\"6KR3T733EC\" and (flags=1 or flags=8)"
APPROVED_BUNDLES=$(/usr/bin/sqlite3 /private/var/db/SystemPolicyConfiguration/KextPolicy "$QUERY")

if [[ $APPROVED_BUNDLES ]]; then
	NVIDIA_ALREADY_APPROVED=1
else
	if $FS_ALLOWED; then
		# Approve kexts
		printf '%bApproving extensions...%b\n' "$B" "$R"
		declare -a BUNDLES KEXT_INFO_PLISTS
		cd "$DRIVERS_ROOT" || e "Failed to find drivers root directory" $?
		KEXT_INFO_PLISTS=(./Library/Extensions/*.kext/Contents/Info.plist)
		for PLIST in "${KEXT_INFO_PLISTS[@]}"; do
			BUNDLE_ID=$(plistb "Print :CFBundleIdentifier" "$PLIST")
			[[ $BUNDLE_ID ]] && BUNDLES+=("$BUNDLE_ID")
		done
		for BUNDLE_ID in "${BUNDLES[@]}"; do
			sql_add_kext "$BUNDLE_ID"
		done
		sql_add_kext "com.nvidia.CUDA"
		/usr/bin/sqlite3 /private/var/db/SystemPolicyConfiguration/KextPolicy <<< "$SQL" \
			|| warning "sqlite3 exit code $?"
		NVIDIA_ALREADY_APPROVED=1
	else
		NVIDIA_ALREADY_APPROVED=0
	fi
fi
		
# Install

uninstall_drivers
CHANGES_MADE=true WANTS_KEXTCACHE=false RESTART_REQUIRED=true
if ! $FS_ALLOWED; then
	s /usr/bin/pkgbuild --identifier com.nvidia.web-driver --root "$DRIVERS_ROOT" "$DRIVERS_PKG"
	if ! $KEXT_ALLOWED && ((NVIDIA_ALREADY_APPROVED == 0)); then
		# Show a warning in case macOS prompts to restart before we are done
		warning "Don't restart until this process is complete."; fi
	printf '%bInstalling...%b\n' "$B" "$R"
	s /usr/sbin/installer -allowUntrusted -pkg "$DRIVERS_PKG" -target / || e "installer error" $?
else
	printf '%bInstalling...%b\n' "$B" "$R"
	/usr/bin/rsync -r "${DRIVERS_ROOT}"/* /
	WANTS_KEXTCACHE=true
fi

# Check extensions are loadable

s /sbin/kextload "$STARTUP_KEXT"
if [[ $? -eq 27 ]]; then
	 # kextload returns 27 when a kext's team ID needs user-approval
	/usr/bin/tput bel
	printf 'Allow NVIDIA Corporation in security preferences to continue...\n'
	WANTS_KEXTCACHE=true
	while ! s /usr/bin/kextutil -tn "$STARTUP_KEXT"; do
		sleep 5
	done
fi

# Update caches and NVRAM

((STAGED_BUNDLES_EXIST == 1 || OPT_ALWAYS_STAGE_BUNDLES == 1)) && stage_bundles
check_required_os || WANTS_KEXTCACHE=true
if $WANTS_KEXTCACHE; then
	update_caches
else
	load_all
fi
touch /Library/Extensions
$SET_NVRAM

# Exit

exit_after_changes "Installation complete."
