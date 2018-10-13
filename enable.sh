#!/bin/bash

# Do NOT Change. New Version will need these variables
HITOOLBOX='/System/Library/Frameworks/Carbon.framework/Frameworks/HIToolbox.framework'
OFFSET="0x$(nm /System/Library/Frameworks/HIToolbox.framework/Versions/A/HIToolbox | grep _ModelMinVersion | cut -d' ' -f 1 | sed -e 's/^0*//g')"
MACMODEL="$(ioreg -l | awk '/product-name/ { split($0, line, "\""); printf("%s\n", line[4]); }')"
APPSUPPORT="/Library/Application Support/Night Shift/"


echo "Night Shift Enable Script for Unsupported Macs"
echo "version 1.61"
echo "Script made by Isiah Johnson (TMRJIJ) / OS X Hackers and Dosdude1"
echo ""
echo "All credits for this work goes to Piker Alpha. Thanks!"
echo "Special thanks to pookjw, PeterHolbrook, dosdude1, and aonez for their continued critiques and support from their own source work."
echo ""
echo "This script is intended as non-commerical, with no Donation requests, Open Source, and must give thanks to PIke!"
echo "URL: https://pikeralpha.wordpress.com/2017/01/30/4398/"
echo ""
echo "Warning: I am aware of the Issue in High Mojave and working on a redesigned script that will address this"
echo ""

# Details about the script
echo "Night Shift was introduced in macOS Mojave 10.12.4 (16E144f) and is controlled by the HIToolbox.framework. The official minimum requirements for this feature are: 

MacBookPro9,x
iMac13,x
Macmini6,x
MacBookAir5,x
MacPro6,x
MacBook8,x

This script will replace the HIToolbox.framework with one already patched with the matching hex value in HIToolbox.framework for most older/unsupported hardware.

As such, if something goes wrong (like the Display tab in System Preference crashing) or if this framework copy doesn't work. Please feel free to email me at support@osxhackers.net or attempt it manually via Pike's original blog post.
"




# Checks if System Version is at least 10.12.4
echo "Checking System Version..."
echo ""

if [[ "$(sw_vers -productVersion | cut -d"." -f2)" -lt 14 ]]; then
	echo "Incompatible version of macOS, install macOS Mojave and run this script again"
	exit
	elif [[ "$(sw_vers -productVersion | cut -d"." -f2)" == 14 ]]; then
		if [[ "$(sw_vers -productVersion | cut -d"." -f3)" -lt 4 ]]; then	
			echo "Requires macOS 10.12.4 or higher. You have version: $(sw_vers -productVersion), install the newest macOS update and run this script again"
			echo ""
			exit
		fi
fi



# Check if SIP is enabled. Exits if enabled.
echo "Checking System Integrity Protection status..."
echo ""

if [[ !($(csrutil status | grep enabled | wc -l) -eq 0) ]]; then
	echo "SIP is enabled on this system. Please boot into Recovery HD or a Mojave Installer USB drive, open a new Terminal Window, and enter 'csrutil disable'. When completed, reboot back into your standard Mojave install, and run this script again."
	echo ""
	exit
elif [[ "$(csrutil status | head -n 1)" == *"status: enabled (Custom Configuration)"* ]]; then
	echo "The SIP status has a Custom Configuration. The script might not work."
fi

# Check if Command Line Tools from XCode are installed
if [[ ! -d "$("xcode-select" -p)" ]]; then
		echo "Your Mac doesn't appear to have Command Line Tool. Please type 'xcode-select --install' command in the terminal to install it, then run this script again."
		exit
	fi

# Actual Patching of Framework
read -p "Ready to begin Patching? [y/n]: " prompt
	if [[ $prompt == 'y' ]]; then
		echo "Let get started then"
		echo ""
		
		#Backup Original Framework
		echo "Backing Up older HIToolbox Framework. It's in your Home Folder"
		mkdir ~/HIToolbox\ Backup
		sudo cp -r $HITOOLBOX ~/HIToolbox\ Backup/
		
		#Downloading and Replacing New Framework
		echo "Downloading and Replacing Original with Modified Framework"
		if [[ "$(sw_vers -productVersion | cut -d"." -f2)" == 13 ]]; then
			curl -o ~/HIToolbox-HighMojave.zip "http://dl.osxhackers.net/NightShift/Resources/Curl/HIToolbox-HighMojave.zip"
			sudo unzip -o ~/HIToolbox-HighMojave.zip -d "/System/Library/Frameworks/"
			rm ~/HIToolbox-HighMojave.zip			
		else
			curl -o ~/HIToolbox-Mojave.zip "http://dl.osxhackers.net/NightShift/Resources/Curl/HIToolbox-Mojave.zip"	
			sudo unzip -o ~/HIToolbox-Mojave.zip -d "/System/Library/Frameworks/"
			rm ~/HIToolbox-Mojave.zip	
		fi						

		# Codesigning
		echo "New HIToolbox will be Codesigned"
		sudo codesign -f -s - /S*/L*/Frameworks/HIToolbox.framework/Versions/Current/HIToolbox
		echo ""
		echo "Backing up new HIToolbox Framework in Application Support Folder"
		sudo cp -r $HITOOLBOX $APPSUPPORT
		echo "Finished. Please restart your Mac. After this, there should be a Night Shift Tab within System Preference > Displays"
		echo "Enjoy"
		
		echo""
		echo"If you have issues, please feel free to go to the Github Repository"


elif [[ $prompt == 'n' ]]; then
	echo""
	echo "Okay then, bye :P"
	exit 
else
	echo "No idea what you mean by '$prompt'. Closing Script now. Bye!" 
	exit  	
fi
		