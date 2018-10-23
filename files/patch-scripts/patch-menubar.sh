#!/bin/sh
#title            :patch_solid_menubar.sh
#description      :some fixes for Mojave Light Mode for unupported macs 
#date             :20180924
#version          :0.01
#description      :A script that patches HIToolbox in-place for a solid menu bar (black or white depending on the mode)
#
# 2018-09-24 - pkouame - added GM hashes
# 2018-09-20 - pkouame - added better SIP verification
# 2018-09-20 - pkouame - added screen colors for notifications
# 2018-09-16 - pkouame - removed touch Extensions (why?)
# 2018-09-16 - pkouame - replaced otool -t with otool -d . The former doesn't work since we want to compare the __DATA sections and not the __TEXT ones
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

checkSIP=$false
checkSystemVersion=$false

# change for debug purposes
# HIToolboxLocation="/System/Library/Frameworks/Carbon.framework/Frameworks/HIToolbox.framework/Versions/A/HIToolbox"
# for development
HIToolboxLocation="./Test/HIToolbox-18B45D.framework/Versions/A/HIToolbox"

function testLocation() {
  if  [[ ! -f "${HIToolboxLocation}" ]] ; then
     echo "Could not find: ${HIToolboxLocation}. Exiting."; 
     exit 4
  else
     printf "Found:${HIToolboxLocation}\n";     
  fi
}

# Current HIToolbox md5 Checksum (includes codesign signature)
HIToolboxCurrent="$(md5 -q $HIToolboxLocation)"

# Current HIToolbox md5 Checksum of the '(__DATA,__data)' section expoted by otool
# This makes it possable to detect a patch regardless of the signing certificate
oToolHIToolboxCurrent="$(otool -d $HIToolboxLocation |tail -n +2 |md5 -q)"

# md5 checksum of '(__DATA,__data)' section exported by otool from unpatched HIToolboxes
# for future use of detecting a false patch, where the executible's checksum is changed by codesigning but not the actual code.
oToolHIToolboxUnpatched=(
  8336f588fea577075d7c253992bf9eb5  '10.14.0 18A391'  1   'v1:Mojave GM patches __ZL29sIsMenuBarTransparencyEnabled from 0xFF to 0x00'
  80e14bd4bcf222d8ae0534517b07d08c  '10.14.1 18B45d'  2   'v1:Mojave beta security patch'
)

# md5 checksum of '(__DATA,__data)' section exported by otool from patched HIToolboxs
oToolHIToolboxPatched=(
  80e14bd4bcf222d8ae0534517b07d08c  '10.14.0 18A391'  1  'v1:Mojave GM patches __ZL29sIsMenuBarTransparencyEnabled from 0xFF to 0x00'
  80e14bd4bcf222d8ae0534517b07d08c  '10.14.1 18B45d'  2  'v1:Mojave beta security patch' 
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
  # SIGNCHECK="$(codesign --verify --deep --verbose=2 --strict "${HIToolboxLocation}" 2>&1 >/dev/null)"
  # if [[ ${SIGNCHECK} = *"valid on disk"*"satisfies its Designated Requirement"* ]]; then
  #   echo "${GREEN}New signature checked${NC}"
  # else
  #   # rm -R "${HIToolboxLocation}"
  #   echo "${RED}\nThe new signature is invalid or can't be applied. Check the original framework sigature is valid and try again. No patch applied.\n${ORANGE}${SIGNCHECK}\n\n${NC}"
  #   exit
  # fi  
}

function doInstall {
  if hash codesign 2>/dev/null; then
      printf "Re-signing $HIToolboxLocation\n"
      sudo codesign -fv -s - $HIToolboxLocation
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
  printf "using this script without input will patch HIToolbox if a supported version found\n"
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
# TODO: figure out how to substitue these variables in the perl command line directly
v1_originalHex="\xff\xfe\xfe\xff\xff\x00\xff\xff\x00\x00\x00\x00\x00\xcc\x70\x09\x00\x00\x00\x00\x00\xff\x00\x00"
v1_patchedHex="\x00\xfe\xfe\xff\xff\x00\xff\xff\x00\x00\x00\x00\x00\xcc\x70\x09\x00\x00\x00\x00\x00\xff\x00\x00"

function HIToolboxPatch {
  testSIP
  case "$1" in
  1)  printf "Patching HIToolbox with patch version 1\n"
      sudo perl -i.bak -Wpe '$before = qr"\xff\xfe\xfe\xff\xff\x00\xff\xff\x00\x00\x00\x00\x00\xcc\x70\x09\x00\x00\x00\x00\x00\xff\x00\x00"s;$M += s/$before/\x00\xfe\xfe\xff\xff\x00\xff\xff\x00\x00\x00\x00\x00\xcc\x70\x09\x00\x00\x00\x00\x00\xff\x00\x00/g;END{exit 1 unless $M>0}' $HIToolboxLocation        
      # NOTE: need to process the return code from perl here so NO extra commands that may corrupt the return value please.
      if [[ $? == 0 ]]; then
        printf "Patch succeeded! A backup was created here [ %s ] (in the bundle).\n" $HIToolboxLocation.bak
        askInstall
      else
        printf "${RED}Patch unsuccessful! Probably couldn't find the hex pattern.${NC}\n"
        HIToolboxUnpatch
# TODO: need to revert the backup file automatically (?)
        exit 4
      fi 
	  	;;
  2)  printf "Patching HIToolbox with patch version 2\n"
		# sudo perl -i.bak -pe '$before = qr"\xB8\x01\x00\x00\x00\xF6\xC1\x01\x0F\x85\x96\x04\x00\x00"s;s/$before/\x31\xC0\x90\x90\x90\x90\x90\x90\xE9\x97\x04\x00\x00\x90/g' $HIToolboxLocation
        askInstall
	  	;;
  3)  printf "Patching HIToolbox with patch version 3\n"
  # 		sudo perl -i.bak -pe '$before = qr"\xB8\x01\x00\x00\x00\xF6\xC1\x01\x0F\x85\xAD\x04\x00\x00"s;s/$before/\x31\xC0\x90\x90\x90\x90\x90\x90\xE9\xAE\x04\x00\x00\x90/g' $HIToolboxLocation
        askInstall
	  	;;
  4)  printf "Patching HIToolbox with patch version 4\n"
  # 		sudo perl -i.bak -pe '$oldtest1 = qr"\xE8\x37\x02\x00\x00\xBB\xE6\x02\x00\xE0\x85\xC0\x0F\x85\x9C\x00\x00\x00"s;$newtest1 = "\xE8\x37\x02\x00\x00\xBB\xE6\x02\x00\xE0\x31\xC0\x0F\x85\x9C\x00\x00\x00"; $oldtest2 = qr"\xE8\x65\x00\x00\x00\x85\xC0\xBB\xE6\x02\x00\xE0\x0F\x85\xCA\xFE\xFF\xFF"s;$newtest2 = "\xE8\x65\x00\x00\x00\x31\xC0\xBB\xE6\x02\x00\xE0\x0F\x85\xCA\xFE\xFF\xFF";s/$oldtest1/$newtest1/g;s/$oldtest2/$newtest2/g' $HIToolboxLocation
        askInstall
    	;;
  *)  printf "${RED}This patch does not exist, make sure you used the right patch identfier${NC}\n"
      exit
      ;;
  esac
}

function HIToolboxUnpatch {
  testSIP
  
  if [[ -f "$HIToolboxLocation.bak" ]]; then
    sudo mv $HIToolboxLocation.bak $HIToolboxLocation
    printf "${GREEN}Moved backup file back in place\n${NC}"
  else 
    printf "${YELLOW}No backup found, the patch has either not been done, or the backup file has been deleted...${NC}"
  fi
}

function HIToolboxPrintAllMD5 {
  echo "---- BEGINNING MD5 HASH SUMS ---- version: $(sw_vers -productVersion) build:$(sw_vers -buildVersion)"
  echo
  printf "     otool -d HIToolbox: $(otool -d $HIToolboxLocation |tail -n +2 |md5 -q)\n"
  if [[ -f "$HIToolboxLocation.bak" ]]; then
    printf " otool -d HIToolbox.bak: $(otool -d $HIToolboxLocation.bak |tail -n +2 |md5 -q)\n"
  else
    printf " otool -d HIToolbox.bak: NO FILE (this is okay)\n"
  fi
  printf "           HIToolbox: $(md5 -q $HIToolboxLocation)\n"
  if [[ -f "$HIToolboxLocation.bak" ]]; then
    printf "       HIToolbox.bak: $(md5 -q $HIToolboxLocation.bak)\n"
  else
    printf "       HIToolbox.bak: NO FILE (this is okay)\n"
  fi
  echo
  echo "---- ENDING MD5 HASH SUMS -------"
}

function testHIToolboxPatch {
  if [[ ! -f "$HIToolboxLocation.bak" ]]; then
    echo "Patch failed to run"
  elif [[ $(otool -d $HIToolboxLocation.bak |tail -n +2 |md5 -q) !=  $(otool -d $HIToolboxLocation |tail -n +2 |md5 -q) ]]; then
    echo "The code of HIToolbox changed, the patch was probbably succesfull"
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
  for ((i=0; i < ${#HIToolboxUnpatched[@]}; i+=4)); do
    if [[ $HIToolboxCurrent == ${HIToolboxUnpatched[$i]} ]]; then
      printf "Detected unpatched HIToolbox on OS X %s.\n" "${HIToolboxUnpatched[$i+1]}"
      nothingWasFound=false
      if [[ ! -z $1 ]]; then
        if [[ $1 == "patch" ]]; then
          HIToolboxPatch ${HIToolboxUnpatched[$i+2]}
          makeExit
        fi
      fi
    fi
  done
  for ((i=0; i < ${#oToolHIToolboxUnpatched[@]}; i+=4)); do
    if [[ $oToolHIToolboxCurrent == ${oToolHIToolboxUnpatched[$i]} ]]; then
      printf "(otool) Detected unpatched HIToolbox on OS X %s.\n" "${oToolHIToolboxUnpatched[$i+1]}"
      nothingWasFound=false
      if [[ ! -z $1 ]]; then
        if [[ $1 == "patch" ]]; then
          HIToolboxPatch ${oToolHIToolboxUnpatched[$i+2]} 
          makeExit
        fi
      fi
    fi
  done
  for ((i=0; i < ${#HIToolboxPatched[@]}; i+=4)); do
    if [[ $HIToolboxCurrent == ${HIToolboxPatched[$i]} ]]; then
      printf "Detected patched HIToolbox on OS X %s.\n" "${HIToolboxPatched[$i+1]}"
      nothingWasFound=false
    fi
  done
  for ((i=0; i < ${#oToolHIToolboxPatched[@]}; i+=4)); do
    if [[ $oToolHIToolboxCurrent == ${oToolHIToolboxPatched[$i]} ]]; then
      printf "(otool) Detected patched HIToolbox on OS X %s.\n" "${oToolHIToolboxPatched[$i+1]}"
      nothingWasFound=false
    fi
  done
  if $nothingWasFound; then
    echo "Unknown version of HIToolbox found.."
    HIToolboxPrintAllMD5
  fi
}
function listSupportedVersions {
  nothingWasFound=true;
  for ((i=0; i < ${#oToolHIToolboxUnpatched[@]}; i+=4)); do
    printf "%d: %s %s %s %s\n" "${i}" "${oToolHIToolboxUnpatched[$i]}" "${oToolHIToolboxUnpatched[$i+1]}" "${oToolHIToolboxUnpatched[$i+2]}" "\"${oToolHIToolboxUnpatched[$i+3]}\""
  done  
}

function options {
  testLocation
  testSystemVersion
  if [[ $1 == "patch" ]]; then
    #test if there is a backup file
    if [[ -f "$HIToolboxLocation.bak" ]]; then
      printf "\n${RED}An backup file already exists, if you force this patch on an already patched version you will loose the original backup!\n"
      printf "This will lead you to reinstall the OS if you loose a working version of HIToolbox. be carefull\n"
      printf "It might be wise to undo the patch before trying to redo it using: $thiscommand unpatch${NC}\n"
      askExit
    fi
    if [[ -z $2 ]]; then
      printf "Did not specify patch version\n"
      makeExit
    fi
    case "$2" in
      v1) HIToolboxPatch 1;;
      v2) HIToolboxPatch 2;;
      v3) HIToolboxPatch 3;;
      v4) HIToolboxPatch 4;;
      *)  HIToolboxPatch 0;;
    esac
    testHIToolboxPatch 
    exit 
  elif [[ $1 == 'unpatch' ]] || [[ $1 == 'depatch' ]]; then
    if [[ ! -f "$HIToolboxLocation.bak" ]]; then
      printf "There is no backup file, we can not undo the patch. the patch might not even been done.\n"
      makeExit
    fi
    HIToolboxUnpatch
  elif [[ $1 == 'test' ]] || [[ $1 == 'status' ]]; then
    test 'status'
    exit
  elif [[ $1 == 'md5' ]]; then
    HIToolboxPrintAllMD5
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