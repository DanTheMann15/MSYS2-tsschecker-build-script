echo -e "This script will help make a static build of tsschecker for Windows (i686)"
echo "INFO: Please make sure your package lists are updated before proceeding"
echo "WARNING: Make sure you are using the MSYS2 MinGW 32-bit shell"
read -p "Press ENTER to continue or hit CTRL+C to abort"
echo -e "Preparing enviornment:"
sleep 1
pacman -S --needed --noconfirm mingw-w64-i686-toolchain mingw-w64-i686-openssl mingw-w64-i686-libzip
pacman -S --needed --noconfirm make automake autoconf autoconf-archive autogen bc bison flex cmake pkgconf openssl libtool m4 libidn2 git patch ed sed texinfo libunistring libunistring-devel python cython python-devel zsh
echo "Packages installed, creating working directory:"
export STATIC_FLAG="--enable-static --disable-shared"
export IS_STATIC=1
mkdir ./tsschecker_build_win32
cd ./tsschecker_build_win32
set -e
export CC=gcc
export CXX=g++
echo -e "Cloning required dependencies\n"
sleep 1
git clone --recursive https://github.com/libimobiledevice/libimobiledevice-glue.git
git clone --recursive https://github.com/libimobiledevice/libplist.git
git clone --recursive https://github.com/libimobiledevice/libirecovery.git
git clone --recursive https://github.com/tihmstar/libgeneral.git
git clone --recursive https://github.com/tihmstar/libfragmentzip.git
git clone --recursive https://github.com/1Conan/tsschecker.git
echo "applying patches:"
echo "patching libgeneral"
sed -i'' 's|vasprintf(&_err, err, ap);|_err=(char*)malloc(1024);vsprintf(_err, err, ap);|' ./libgeneral/libgeneral/exception.cpp
sleep 1
echo "patching libirecovery"
wget -q https://gist.github.com/1Conan/2d015aad17f87f171b32ebfd9f48fb96/raw/c12fca047f8b0bba1c8983470bf863d80d7e1c1d/libirecovery.patch
patch -p1 < libirecovery.patch -d ./libirecovery
sleep 1
echo "patching libfragmentzip"
sed -i'' 's|fopen(savepath, \"w\")|fopen(savepath, \"wb\")|' ./libfragmentzip/libfragmentzip/libfragmentzip.c
sleep 1
echo "patches applied, continuing:\n"
sleep 1
echo "Building curl"
sleep 1
wget https://github.com/curl/curl/releases/download/curl-7_79_1/curl-7.79.1.tar.gz
tar -zxvf curl-7.79.1.tar.gz
cd ./curl-7.79.1
./configure $STATIC_FLAG --disable-dependency-tracking --enable-ipv6 --with-winssl --with-schannel --with-winidn --without-ssl --with-zlib
make install
cd ..
echo "Building libplist"
sleep 1
cd ./libplist
./autogen.sh $STATIC_FLAG --without-cython
make install
cd ..
echo "Building libimobiledevice-glue"
sleep 1
cd ./libimobiledevice-glue
./autogen.sh $STATIC_FLAG
make install
cd ..
echo "Building libirecovery"
sleep 1
cd ./libirecovery
libtoolize --force
aclocal -I m4
autoheader
automake --add-missing
autoconf
./configure --enable-static --disable-shared --with-dummy
make install
cd ..
echo "Building libgeneral"
sleep 1
cd ./libgeneral
./autogen.sh $STATIC_FLAG
make install
cd ..
echo "Building libfragmentzip"
sleep 1
cd ./libfragmentzip
./autogen.sh $STATIC_FLAG
make install
cd ..
echo "Building tsschecker"
sleep 1
cd ./tsschecker
./autogen.sh $STATIC_FLAG
make LDFLAGS=-all-static
cd ..
echo "Done building, cleaning up temp files:"
sleep 1
rm -f curl-7.79.1.tar.gz
rm -fr curl-7.79.1
rm -fr libplist
rm -fr libimobiledevice-glue
rm -fr libirecovery
rm -fr libgeneral
rm -fr libfragmentzip
rm -f libirecovery.patch
echo "Done!"
echo "tsschecker.exe can be found inside the working directory"
