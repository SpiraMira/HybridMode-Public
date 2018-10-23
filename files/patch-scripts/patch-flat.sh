#!/bin/sh
#title            :patch-flat.sh
#description      :some fixes for Mojave Light Mode for unupported macs 
#date             :20180924
#version          :0.01
#description      :A script that patches AppKit in-place to prevent NSVisualEffectView from processing vibrancy (like a restricted reduce transparency mode)
#
# 2018-10-03 - pkouame - moved bbe to Resources
# 2018-10-02 - pkouame - replace the problematic perl regex with bbe
# 2018-10-01 - pkouame - added GM hashes
# 2018-10-01 - pkouame - added better SIP verification
# 2018-10-01 - pkouame - created
#
# TODOs
#   sprinkled throughout the code
#
# some credits 
#
# pikeralpha  - for the clues and techniques I use to generate the patch hex strings
# Floris497   - for script inspiration CoreDisplay patch
# TMRJIJ      - for script inspiration
# many others...
#

# printf "Not Yet Ready for Prime Time - Watch the repo and stay tuned"
# exit 1

thiscommand=$0

# some screen colors
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
YELLOW='\033[1;31m'
WHITE='\033[1;97m'
LIGHTGRAY='\033[1;37m'
DARKGRAY='\033[1;90m'
NC='\033[0m' # No Color

# printf "${RED}Not Yet Ready for Prime Time - Watch the repo and stay tuned.${NC}"
# exit 1

nm="/usr/bin/nm"
xxd="/usr/bin/xxd"
codesign="/usr/bin/codesign"
plistbuddy="/usr/libexec/PlistBuddy"
bbe="./Resources/bbe-0.2.2/src/bbe"

checkSIP=$false
checkSystemVersion=$false

# change for debug purposes
# AppKitLocation="/System/Library/Frameworks/AppKit.framework/Versions/Current/AppKit"
# for development
AppKitLocation="./Test/AppKit.framework/Versions/C/AppKit"

function testLocation() {
  if  [[ ! -f "${AppKitLocation}" ]] ; then
     echo "Could not find: ${AppKitLocation}. Exiting."; 
     exit 4
  else
     printf "Found:${AppKitLocation}\n";     
  fi
}

# Current AppKit md5 Checksum (includes codesign signature)
AppKitCurrent="$(md5 -q $AppKitLocation)"

# Current AppKit md5 Checksum of the '(__DATA,__data)' section expoted by otool
# This makes it possable to detect a patch regardless of the signing certificate
oToolAppKitCurrent="$(otool -t $AppKitLocation |tail -n +2 |md5 -q)"

# md5 checksum of '(__DATA,__data)' section exported by otool from unpatched AppKites
# for future use of detecting a false patch, where the executible's checksum is changed by codesigning but not the actual code.
oToolAppKitUnpatched=(
  55f25a8bba1be7bb1674ab035a6cdce3  '10.14 18B45d'    1   'v1:Mojave 10.14.1beta bypasses reduced transparency processing in Visual Effect View CoreUIOptions'
)

# md5 checksum of '(__DATA,__data)' section exported by otool from patched AppKits
oToolAppKitPatched=(
  608088e2da166ebe1a49ca813f0a90d2  '10.14 18B45d'    1  'v1:Mojave 10.14.1beta bypasses reduced transparency processing in Visual Effect View CoreUIOptions'
)

#############################################################
# Get Operating System Product Version
#############################################################
function testSystemVersion {
  if [[ !$checkSystemVersion ]]; then 
    return 
  fi
  plist="${1}/System/Library/CoreServices/SystemVersion.plist"
  if  [ -f "${plist}" ]; then
      version=$("${plistbuddy}" -c "print :ProductVersion" "${plist}")
  else
      if  [ "${1}" == '/' ] || [ "${1}" == '' ]; then
          version=$(sw_vers -productVersion)
      else
          echo "[ERR] Get Operating System Product Version."
          exit 1
      fi
  fi

  if  [[ "$(printf ${version} | awk -F'.' '/10.14/{print $3}')" < "4" ]]; then
      printf "[ERR] Unsupported Operating System. This patch is meant for macOS Mojave.\n"
      exit 2
  fi
}

function makeExit {
  printf "Closing..\n"
  exit
}

function checkCodeSign {
  return
  # echo 'Checking new signature...'
  # SIGNCHECK="$(codesign --verify --deep --verbose=2 --strict "${AppKitLocation}" 2>&1 >/dev/null)"
  # if [[ ${SIGNCHECK} = *"valid on disk"*"satisfies its Designated Requirement"* ]]; then
  #   echo "${GREEN}New signature checked${NC}"
  # else
  #   # rm -R "${AppKitLocation}"
  #   echo "${RED}\nThe new signature is invalid or can't be applied. Check the original framework sigature is valid and try again. No patch applied.\n${ORANGE}${SIGNCHECK}\n\n${NC}"
  #   exit
  # fi  
}

function doInstall {
  if hash codesign 2>/dev/null; then
      printf "Re-signing $AppKitLocation\n"
      sudo codesign -fv -s - $AppKitLocation
      checkCodeSign      
  else
      printf "${RED}Problem codesigning."    
      printf "Do you have Xcode installed? Check \"\$ xcodeselect\"${NC}\n"      
  fi  
}

function askExit {
  read -p "Do you want to continue? [Y/n] " -n 1 -r
  echo 
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    makeExit
  fi
}

function askInstall {
  read -p "Do you want to install? [Y/n] " -n 1 -r
  echo 
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doInstall
  fi
}

function SIPInfo {
  printf "more info: Google 'SIP'\n"
}

function help {
  printf "using this script without input will patch AppKit if a supported version found\n"
  printf "patch [v1-v3]\t patch on a specific version\n"
  printf "\t\t eg. $(basename $thiscommand) patch v2\n"
  printf "unpatch\t\t undo patch\n"
  printf "status\t\t Shows you if you have an known or unknown patch\n"
  printf "list\t\t List the supported versions for this patch\n"
  printf "md5\t\t gives all your md5 hashes\n"
  printf "help\t\t show this help message\n"
}

function testSIP {
  if [[ !$checkSIP ]]; then 
    return 
  fi
  if hash csrutil 2>/dev/null; then
    if [[ "$(csrutil status | head -n 1)" == *"status: enabled (Custom Configuration)"* ]]; then
      printf "SIP might or might not be disabled\n"
      printf "the script might or might not be working\n"
      printf "check \"\$ csrutil status\"\n"
      SIPInfo
      askExit
    elif [[ "$(csrutil status | head -n 1)" == *"status: enabled"* ]]; then
      printf "SIP is enabled, this script will only work if SIP is disabled\n"
      if [[ -z $1 ]]; then
        makeExit
      fi
    elif [[ "$(csrutil status | head -n 1)" == *"status: disabled"* ]]; then
      printf "SIP looks to be disabled, all good!\n"
    else
      printf "${RED}Unknown csrutil result! Exiting.${NC}\n"
      exit 4
    fi
    #statements
  else
      printf "${RED}No csrutil!. Houston we have a problem. Exiting.${NC}\n"    
      exit 4
  fi  
}

# The secret sauce...(generated with secretsauce.sh utility)
# TODO: figure out how to substitue these variables in the perl command line directly.  Perl doesn't like some hex
v1_originalHex="\x74\x28\x48\x8B\x3D\xDE\x3E\x0A\x01\x48\x8B\x35\xAF\x13\x07\x01\x4D\x89\xF4\x41\xFF\xD4\x48\x8B\x35\x62\xB4\x07\x01\x48\x89\xC7\x41\xFF\xD4\x84\xC0\x0F\x94\xC0"
v1_patchedHex="\xEB\x28\x48\x8B\x3D\xDE\x3E\x0A\x01\x48\x8B\x35\xAF\x13\x07\x01\x4D\x89\xF4\x41\xFF \xD4\x48\x8B\x35\x62\xB4\x07\x01\x48\x89\xC7\x41\xFF\xD4\x84\xC0\x0F\x94\xC0"

function AppKitPatch {
  testSIP
  case "$1" in
  1)  printf "Patching AppKit with patch version 1\n"
      # sudo perl -i.bak -pe '$before = qr"\x74\x28\x48\x8B\x3D\xDE\x3E\x0A\x01"s;$M += s/$before/\xEB\x28\x48\x8B\x3D\xDE\x3E/g;END{print "Number of matches:$M.\n"; exit 1 unless $M>0}' $AppKitLocation        
      # bbe - the only reliable binary hex editor - no real success safe results with perl or sed regular expressions
      ${bbe} -e "s/\x74\x28\x48\x8B\x3D\xDE\x3E\x0A\x01\x48\x8B\x35\xAF\x13\x07\x01\x4D\x89\xF4\x41\xFF\xD4\x48\x8B\x35\x62\xB4\x07\x01\x48\x89\xC7\x41\xFF\xD4\x84\xC0\x0F\x94\xC0/\xEB\x28\x48\x8B\x3D\xDE\x3E\x0A\x01\x48\x8B\x35\xAF\x13\x07\x01\x4D\x89\xF4\x41\xFF\xD4\x48\x8B\x35\x62\xB4\x07\x01\x48\x89\xC7\x41\xFF\xD4\x84\xC0\x0F\x94\xC0/" -e "w file.tmp" -o /dev/null $AppKitLocation
      # NOTE: need to process the return code from perl here so NO extra commands that may corrupt the return value please.
      if [[ $? == 0 ]]; then
# TODO more error handling here?
        mv -f $AppKitLocation $AppKitLocation.bak
        mv -f file.tmp $AppKitLocation
        printf "Patch succeeded! A backup was created here [ %s ] (in the bundle).\n" $AppKitLocation.bak
        askInstall
      else
        printf "${RED}Patch unsuccessful! Probably couldn't find the hex pattern.${NC}\n"
        rm -f file.tmp
        AppKitUnpatch
# TODO: need to revert the backup file automatically (?)
        exit 4
      fi 
	  	;;
  2)  printf "Patching AppKit with patch version 2\n"
		# sudo perl -i.bak -pe '$before = qr"\xB8\x01\x00\x00\x00\xF6\xC1\x01\x0F\x85\x96\x04\x00\x00"s;s/$before/\x31\xC0\x90\x90\x90\x90\x90\x90\xE9\x97\x04\x00\x00\x90/g' $AppKitLocation
        askInstall
	  	;;
  3)  printf "Patching AppKit with patch version 3\n"
  # 		sudo perl -i.bak -pe '$before = qr"\xB8\x01\x00\x00\x00\xF6\xC1\x01\x0F\x85\xAD\x04\x00\x00"s;s/$before/\x31\xC0\x90\x90\x90\x90\x90\x90\xE9\xAE\x04\x00\x00\x90/g' $AppKitLocation
        askInstall
	  	;;
  4)  printf "Patching AppKit with patch version 4\n"
  # 		sudo perl -i.bak -pe '$oldtest1 = qr"\xE8\x37\x02\x00\x00\xBB\xE6\x02\x00\xE0\x85\xC0\x0F\x85\x9C\x00\x00\x00"s;$newtest1 = "\xE8\x37\x02\x00\x00\xBB\xE6\x02\x00\xE0\x31\xC0\x0F\x85\x9C\x00\x00\x00"; $oldtest2 = qr"\xE8\x65\x00\x00\x00\x85\xC0\xBB\xE6\x02\x00\xE0\x0F\x85\xCA\xFE\xFF\xFF"s;$newtest2 = "\xE8\x65\x00\x00\x00\x31\xC0\xBB\xE6\x02\x00\xE0\x0F\x85\xCA\xFE\xFF\xFF";s/$oldtest1/$newtest1/g;s/$oldtest2/$newtest2/g' $AppKitLocation
        askInstall
    	;;
  *)  printf "${RED}This patch does not exist, make sure you used the right patch identfier${NC}\n"
      exit
      ;;
  esac
}

function AppKitUnpatch {
  testSIP
  
  if [[ -f "$AppKitLocation.bak" ]]; then
    sudo mv $AppKitLocation.bak $AppKitLocation
    printf "${GREEN}Moved backup file back in place\n${NC}"
  else 
    printf "${YELLOW}No backup found, the patch has either not been done, or the backup file has been deleted...${NC}"
  fi
}

function AppKitPrintAllMD5 {
  echo "---- BEGINNING MD5 HASH SUMS ---- version: $(sw_vers -productVersion) build:$(sw_vers -buildVersion)"
  echo
  printf "     otool AppKit: $(otool -t $AppKitLocation |tail -n +2 |md5 -q)\n"
  if [[ -f "$AppKitLocation.bak" ]]; then
    printf " otool AppKit.bak: $(otool -t $AppKitLocation.bak |tail -n +2 |md5 -q)\n"
  else
    printf " otool AppKit.bak: NO FILE (this is okay)\n"
  fi
  printf "           AppKit: $(md5 -q $AppKitLocation)\n"
  if [[ -f "$AppKitLocation.bak" ]]; then
    printf "       AppKit.bak: $(md5 -q $AppKitLocation.bak)\n"
  else
    printf "       AppKit.bak: NO FILE (this is okay)\n"
  fi
  echo
  echo "---- ENDING MD5 HASH SUMS -------"
}

function testAppKitPatch {
  if [[ ! -f "$AppKitLocation.bak" ]]; then
    echo "Patch failed to run"
  elif [[ $(otool -t $AppKitLocation.bak |tail -n +2 |md5 -q) !=  $(otool -t $AppKitLocation |tail -n +2 |md5 -q) ]]; then
    echo "The code of AppKit changed, the patch was probbably succesfull"
  else
    echo "The code is still the same.. Patch did seem to run, but was probbably from the wrong version.."
    echo "If you are running an new os run $thiscommand md5 and ask the maintainer of this script to add support for your system"
  fi

}

function test {
  if [[ ! -z $1 && $1 == "status" ]]; then
    testSIP "Don't Exit"  # Just checking patch status, can do it even if SIP is enabled
  else
    testSIP
  fi
  
  printf "\n"
  nothingWasFound=true;
  for ((i=0; i < ${#AppKitUnpatched[@]}; i+=4)); do
    if [[ $AppKitCurrent == ${AppKitUnpatched[$i]} ]]; then
      printf "Detected unpatched AppKit on OS X %s.\n" "${AppKitUnpatched[$i+1]}"
      nothingWasFound=false
      if [[ ! -z $1 ]]; then
        if [[ $1 == "patch" ]]; then
          AppKitPatch ${AppKitUnpatched[$i+2]}
          makeExit
        fi
      fi
    fi
  done
  for ((i=0; i < ${#oToolAppKitUnpatched[@]}; i+=4)); do
    if [[ $oToolAppKitCurrent == ${oToolAppKitUnpatched[$i]} ]]; then
      printf "(otool) Detected unpatched AppKit on OS X %s.\n" "${oToolAppKitUnpatched[$i+1]}"
      nothingWasFound=false
      if [[ ! -z $1 ]]; then
        if [[ $1 == "patch" ]]; then
          AppKitPatch ${oToolAppKitUnpatched[$i+2]} 
          makeExit
        fi
      fi
    fi
  done
  for ((i=0; i < ${#AppKitPatched[@]}; i+=4)); do
    if [[ $AppKitCurrent == ${AppKitPatched[$i]} ]]; then
      printf "Detected patched AppKit on OS X %s.\n" "${AppKitPatched[$i+1]}"
      nothingWasFound=false
    fi
  done
  for ((i=0; i < ${#oToolAppKitPatched[@]}; i+=4)); do
    if [[ $oToolAppKitCurrent == ${oToolAppKitPatched[$i]} ]]; then
      printf "(otool) Detected patched AppKit on OS X %s.\n" "${oToolAppKitPatched[$i+1]}"
      nothingWasFound=false
    fi
  done
  if $nothingWasFound; then
    echo "Unknown version of AppKit found.."
    AppKitPrintAllMD5
  fi
}
function listSupportedVersions {
  nothingWasFound=true;
  for ((i=0; i < ${#oToolAppKitUnpatched[@]}; i+=4)); do
    printf "%d: %s %s %s %s\n" "${i}" "${oToolAppKitUnpatched[$i]}" "${oToolAppKitUnpatched[$i+1]}" "${oToolAppKitUnpatched[$i+2]}" "\"${oToolAppKitUnpatched[$i+3]}\""
  done  
}

function options {
  testLocation
  testSystemVersion
  if [[ $1 == "patch" ]]; then
    #test if there is a backup file
    if [[ -f "$AppKitLocation.bak" ]]; then
      printf "\n${RED}An backup file already exists, if you force this patch on an already patched version you will loose the original backup!\n"
      printf "This will lead you to reinstall the OS if you loose a working version of AppKit. be carefull\n"
      printf "It might be wise to undo the patch before trying to redo it using: $thiscommand unpatch${NC}\n"
      askExit
    fi
    if [[ -z $2 ]]; then
      printf "Did not specify patch version\n"
      makeExit
    fi
    case "$2" in
      v1) AppKitPatch 1;;
      v2) AppKitPatch 2;;
      v3) AppKitPatch 3;;
      v4) AppKitPatch 4;;
      *)  AppKitPatch 0;;
    esac
    testAppKitPatch 
    exit 
  elif [[ $1 == 'unpatch' ]] || [[ $1 == 'depatch' ]]; then
    if [[ ! -f "$AppKitLocation.bak" ]]; then
      printf "There is no backup file, we can not undo the patch. the patch might not even been done.\n"
      makeExit
    fi
    AppKitUnpatch
  elif [[ $1 == 'test' ]] || [[ $1 == 'status' ]]; then
    test 'status'
    exit
  elif [[ $1 == 'md5' ]]; then
    AppKitPrintAllMD5
    exit
  elif [[ $1 == 'help' ]] || [[ $1 == '-h' ]] || [[ $1 == '--help' ]]; then
    help
    exit
  elif [[ $1 == 'list' ]] ; then
    listSupportedVersions
    exit
  elif [[ -z $1 ]]; then
    test "patch"
    exit
  else
    printf "invalid arguments\n"
    printf "\n"
	  help
    exit
  fi
}

# runs the script
options $1 $2