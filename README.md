# HybridMode Patchers

**Fix Mojave Light Mode on unsupported machines**

Motivated by all the folks on dosdude1's Macrumors 10.14 Mojave Unsupported Forum

Motivated by [Pike](https://pikeralpha.wordpress.com/2017/01/30/4398)

## Screen Shots

* "flat" Mode

![alt tag](Resources/ScreenShot-LightMode.png)

![alt tag](Resources/ScreenShot-DarkMode.png)

* "hybrid" Light with solid menubars

![alt tag](Resources/hybrid1.png)

![alt tag](Resources/hybrid2.png)

## History

* October 8, 2018 : 
  * start of beta testing

## Compatibility Testing

NOTE: Open an Issue if you would like to revise this list

|macOS release|version|description|device ID|Status|
|-------------|-------|-----------|---------|------|
|10.4.1|18B45D|first GM security update|macbook pro 5,3|Passed|
|"|"|"|macbook pro 5,2|Testing|

## How to use

**NOTE: These instructions are for experienced users. You must be comfortable with the Terminal and shell commands**
**General purpose installers and wrappers are still in development.  Stay Tuned for upcoming releases**

1. Disable [SIP](https://developer.apple.com/library/content/documentation/Security/Conceptual/System_Integrity_Protection_Guide/ConfiguringSystemIntegrityProtection/ConfiguringSystemIntegrityProtection.html)[*](https://en.wikipedia.org/wiki/System_Integrity_Protection)
2. Backup the appropriate native applications to a safe place (they are also distributed in the zip archive)
3. Download the latest stable releases from the [Releases](https://github.com/aonez/NightShiftPatcher/releases) section
4. Unzip the files into a temp directory
5. Copy the appropriate patched application to its native location
6. Restart your device
7. Voilà - profit!

## Troubleshooting

* If the system does not boot, restart in [single-user mode](https://support.apple.com/en-bh/HT201573) or with the [recovery partition](https://support.apple.com/en-us/HT201314)

* Find the aprpopriate application backup
* Overwrite the current application with the backup
* restart your computer

## TODOs (in no particular order)

* develop scripts and wrappers
* add a GUI app to wrap this all up neatly
* keep track of tested machines and gpus
* add more documentation
* add more screenshots
