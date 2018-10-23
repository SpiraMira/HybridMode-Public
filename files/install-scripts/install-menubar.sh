#!/bin/bash

# ** NOTE : STILL IN DEV - DO NOT USE **

# Do NOT Change. New Version will need these variables
HITOOLBOX='/System/Library/Frameworks/Carbon.framework/Frameworks/HIToolbox.framework'
# OFFSET="0x$(nm /System/Library/PrivateFrameworks/HIToolbox.framework/Versions/A/HIToolbox | grep _ModelMinVersion | cut -d' ' -f 1 | sed -e 's/^0*//g')"
MACMODEL="$(ioreg -l | awk '/product-name/ { split($0, line, "\""); printf("%s\n", line[4]); }')"
APPSUPPORT="/Library/Application Support/HybridMode/"


echo "Disable Menu bar transparency for Unsupported Macs"


# Details about the script
echo "This script will replace the HIToolbox.framework application with one that sets menubar transparency OFF."


# Checks if System Version is at least 10.14
echo "Checking System Version..."
echo ""

if [[ "$(sw_vers -productVersion | cut -d"." -f2)" -lt 13 ]]; then
	echo "Incompatible version of macOS, install macOS Mojave and run this script again"
	exit
	elif [[ "$(sw_vers -productVersion | cut -d"." -f2)" == 13 ]]; then
		if [[ "$(sw_vers -productVersion | cut -d"." -f3)" -lt 6 ]]; then	
			echo "Requires macOS 10.14 or higher. You have version: $(sw_vers -productVersion), install the newest macOS update and run this script again"
			echo ""
			exit
		fi
fi

# Check if SIP is enabled. Exits if enabled.
echo "Checking System Integrity Protection status..."
echo ""

# if [[ !($(csrutil status | grep enabled | wc -l) -eq 0) ]]; then
# 	echo "SIP is enabled on this system. Please boot into Recovery HD or a Mojave Installer USB drive, open a new Terminal Window, and enter 'csrutil disable'. When completed, reboot back into your standard Sierra install, and run this script again."
# 	echo ""
# 	exit
# elif [[ "$(csrutil status | head -n 1)" == *"status: enabled (Custom Configuration)"* ]]; then
# 	echo "The SIP status has a Custom Configuration. The script might not work."
# fi

# Check if Command Line Tools from XCode are installed
if [[ ! -d "$("xcode-select" -p)" ]]; then
	echo "Your Mac doesn't appear to have Command Line Tool. Please type 'xcode-select --install' command in the terminal to install it, then run this script again."
	exit
else
	echo "Your Mac appears to have XCode Command Line Tools. You're set!"
fi


function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Usage
# $ get_latest_release "creationix/nvm"
# v0.31.4

function get_latest_release() {
    curl --silent "https://api.github.com/repos/certbot/certbot/tags" | jq -r '.[0].name'
}


# Actual Patching of Framework
read -p "Ready to begin Patching? [y/n]: " prompt
	if [[ $prompt == 'y' ]]; then
		echo "Let get started then"
		echo ""
		
		#Backup Original Framework
		echo "Backing Up older HIToolbox Framework. It's in your Home Folder"
		mkdir ~/HIToolbox\ Backup
		sudo cp -R $HITOOLBOX ~/HIToolbox\ Backup/
		
		#Downloading and Replacing New Framework
		echo "Downloading and Replacing Original with Modified Framework"
		if [[ "$(sw_vers -productVersion | cut -d"." -f2)" == 13 ]]; then
			# 
			# download and install HIToolbox here...
			echo "Downloading patch..."
			# https://stackoverflow.com/questions/20396329/how-to-download-github-release-from-private-repo-using-command-line/35688093#35688093
			# wget --no-check-certificate --content-disposition https://github.com/joyent/node/tarball/v0.7.1
			# # --no-check-cerftificate was necessary for me to have wget not puke about https
			# curl -LJO https://github.com/joyent/node/tarball/v0.7.1
			# 		
		else
			# 	
			# ERROR
			echo "Error..."
			# 
		fi						

		# Codesigning
		echo "New HIToolbox will be Codesigned"
		# sudo codesign -f -s - $HITOOLBOX/Versions/Current/HIToolbox
		echo ""
		echo "Backing up new HIToolbox Framework in Application Support Folder"
		sudo cp -R $HITOOLBOX "$APPSUPPORT"
		echo "Finished. Please restart your Mac. After this, there should be a solid white or black menu bar"
		echo "Enjoy"
		
		echo ""
		echo "If you have issues, please feel free to go to the Github Repository"


elif [[ $prompt == 'n' ]]; then
	echo""
	echo "Okay then, bye :P"
	exit 
else
	echo "No idea what you mean by '$prompt'. Closing Script now. Bye!" 
	exit  	
fi
		