# MSYS2-tsschecker-build-script
A couple of bash scripts to automatically build tsschecker static for Windows using MSYS2.

#### Basic Instructions:
1. Download and Install MSYS2 from: https://www.msys2.org/
2. Start the "MSYS2 MSYS" shell and run <code>pacman -Syu</code> and update all of the packages, restart the shell when prompted
3. After restarting the shell, run <code>pacman -Syu</code> again and update all remaining packages
4. Restart MSYS2 in the MinGW 32-bit or MinGW 64-bit shell
5. Run the script for the edition of windows you want to build for: (win32 for 32-bit or win64 for 64-bit)

#### Notes:
Feel free to change forks if desired within the script by changing the URL in the 24th line

the default fork is https://github.com/1Conan/tsschecker
