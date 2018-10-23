# HybridMode Patchers : In-Place Patching Instructions

Everywhere where you see `~/Downloads/patch-xxx.sh` replace the 'xxx' with the actual name of the shell script in the above table

1. before you start make sure SIP is disabled. ([Info about SIP](#some-information-on-sip)).  These scripts all test the SIP status, but avoid the headache by being prepared.
2. Download the patch(es) you need to your downloads folder
3. open the Terminal (found at /Applications/Utilities/Terminal.app)
4. run `chmod +x ~/Downloads/patch-xxx.sh` (this makes the patch executable)
5. run the script `~/Downloads/patch-xxx.sh` patch v1 (an example - applies v1 of the patch-xxx - see below)
6. follow the instructions and fill you password when asked for
7. (if you need more than 1 patch, go back to step 3 here and continue with the next patch there)
8. reboot your machine

If you wan't to request new functions for this script feel free to open an issue with the request.

## Patch Options

* Command Line format: **patch-xxx.sh arg1 arg2**

* Each patch implements a consistent set of command line options.  They are described below

### Patch

* patch-xxx.sh path v[1-x]

This patches the binary.  Use **patch-xxx.sh list** to decide which version (1-x) to apply

### Uninstall

* patch-xxx.sh unpatch | depatch

This copies the .bak file back in place effectively removing the patch binary

### Help

* patch-xxx.sh help

This displays standard help

### List

* patch-xxx.sh list

This displays the list of releases supported and the appropriate version number to use on the patch command line.  The actual code is also a good source

### Status

* patch-xxx.sh status

This prints a summary of your patch situation

### Checksum status

* patch-xxx.sh md5

This prints out the md5 hashes used to compare patched and unpatched binaries.  It takes into account code signing issues with generating meaningful hashes

## Some information on SIP

* You have to disable SIP (System Integrity Protection) before applying. [How to disable SIP](http://apple.stackexchange.com/a/209530)
* You can disable/enable this only when you boot into the recovery partition.
* If you booted into the recovery partition and open the terminal you use
  * ```csrutil disable``` to disable;
  * ```csrutil enable``` to enable;
  * ```csrutil status``` to check the status of SIP you can also check the status on your normal system.
  
the changes to SIP are only visible in the terminal after a reboot, so it will still notify you that SIP is on when you disable it and run ```csrutil status``` right after it.

## Troubleshooting

* TODO