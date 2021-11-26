# MSYS2-tsschecker-build-script
A Bash script to automatically build tsschecker static for Windows (32-bit or 64-bit) using MSYS2.

#### Basic Instructions:
1. Download and Install MSYS2 from: https://www.msys2.org/
2. Start the "MSYS2 MSYS" shell and run <code>pacman -Syu</code> and update all of the packages,<br/>then restart the shell when prompted and repeat as needed until all packages are fully updated.
3. Restart MSYS2 in the MinGW 32-bit (x86) or MinGW 64-bit (x64) shell (depending on whether you are building for 32 bit or 64 bit)<br/>then run the corresponding script and let it do it's thing.

#### Notes:
Feel free to change tsschecker repositories if desired within the script by changing the URL in the 25th line,<br/>the default repository is: https://github.com/1Conan/tsschecker

<b>Important:</b> you *MUST* be running a 64-bit edition of Windows 7 or newer, as MSYS2 does not support 32-bit Windows hosts.
