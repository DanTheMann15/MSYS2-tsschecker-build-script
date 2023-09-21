# MSYS2-tsschecker-build-script
A Bash script to automatically build tsschecker static for Windows (32-bit or 64-bit) using MSYS2.

#### Basic Instructions:
1. Download and Install MSYS2 from: https://www.msys2.org/
2. Start the "MSYS2 MSYS" shell and run <code>pacman -Syu</code> and update all of the packages,<br/>then restart the shell when prompted and repeat as needed until all packages are fully updated.
3. Restart MSYS2 in the MINGW32, MINGW64 or UCRT64 shell, and then run the corresponding script.

#### Notes:
Feel free to change tsschecker repositories if desired within the script by changing the URL in the 35th line,<br/>the default repository is: https://github.com/DanTheMann15/tsschecker

<b>Requirements:</b><br/>MSYS2 Requires a 64-bit installation of Windows 8.1 or later.
