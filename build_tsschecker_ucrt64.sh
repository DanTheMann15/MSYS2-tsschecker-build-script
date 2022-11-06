echo -e "This script will create a static build of tsschecker for Windows 64bit (x86_64)"
echo "INFO: Please make sure your package lists are updated before proceeding"
echo "WARNING: Make sure you are using the MSYS2 MinGW Universal C Runtime 64-bit shell"
read -p "Press ENTER to continue or hit CTRL+C to abort"
echo -e "Preparing enviornment:"
sleep 1
echo -e "Setting PATH Environment variables:"
export PATH=$PATH:/tmp/tsschecker_build_win-ucrt64/bin
export LIBRARY_PATH=$LIBRARY_PATH:/tmp/tsschecker_build_win-ucrt64/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/tsschecker_build_win-ucrt64/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/tmp/tsschecker_build_win-ucrt64/lib/pkgconfig:/tmp/tsschecker_build_win-ucrt64/share/pkgconfig
export C_INCLUDE_PATH=$C_INCLUDE_PATH:-I/mingw64/include:-I/tmp/tsschecker_build_win-ucrt64/include
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:-I/mingw64/include:-I/tmp/tsschecker_build_win-ucrt64/include
export OBJC_INCLUDE_PATH=$OBJC_INCLUDE_PATH:-I/mingw64/include:-I/tmp/tsschecker_build_win-ucrt64/include
sleep 1
echo -e "Installing Required packages:"
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-toolchain mingw-w64-ucrt-x86_64-openssl mingw-w64-ucrt-x86_64-libzip
pacman -S --needed --noconfirm make automake autoconf autoconf-archive autogen bc bison flex cmake pkgconf openssl libtool m4 libidn2 git patch ed sed texinfo libunistring libunistring-devel python cython python-devel zsh
echo "Packages installed, creating working directory:"
export CURL_VERSION="7.86.0"
export BUILD_OPTIONS="--enable-static --disable-shared --prefix=/tmp/tsschecker_build_win-ucrt64"
export IS_STATIC=1
mkdir ./tsschecker_build_win-ucrt64
cd ./tsschecker_build_win-ucrt64
set -e
export CC=gcc
export CXX=g++
echo -e "Cloning required dependencies:"
sleep 1
git clone --recursive https://github.com/libimobiledevice/libplist.git
git clone --recursive https://github.com/libimobiledevice/libimobiledevice-glue.git
git clone --recursive https://github.com/libimobiledevice/libirecovery.git
git clone --recursive https://github.com/tihmstar/libgeneral.git
git clone --recursive https://github.com/tihmstar/libfragmentzip.git
git clone --recursive https://github.com/DanTheMann15/tsschecker.git
echo "applying patches:"
echo "patching libirecovery"
wget -q https://gist.github.com/1Conan/2d015aad17f87f171b32ebfd9f48fb96/raw/c12fca047f8b0bba1c8983470bf863d80d7e1c1d/libirecovery.patch
patch -p1 < libirecovery.patch -d ./libirecovery
sleep 1
echo "patching libgeneral"
sed -i'' 's|vasprintf(&_err, err, ap);|_err=(char*)malloc(1024);vsprintf(_err, err, ap);|' ./libgeneral/libgeneral/exception.cpp
sleep 1
echo "patching libfragmentzip"
sed -i'' 's|fopen(savepath, \"w\")|fopen(savepath, \"wb\")|' ./libfragmentzip/libfragmentzip/libfragmentzip.c
sleep 1
echo "patches applied, continuing:"
sleep 1
echo "Building curl"
sleep 1
wget https://curl.se/download/curl-$CURL_VERSION.tar.gz
tar -zxvf curl-$CURL_VERSION.tar.gz
cd ./curl-$CURL_VERSION
./configure $BUILD_OPTIONS --disable-dependency-tracking --with-schannel --with-winidn --without-brotli --without-libgsasl --without-libpsl --without-librtmp --without-zstd
make install LDFLAGS=-all-static
cd ..
echo "Building libplist"
sleep 1
cd ./libplist
./autogen.sh $BUILD_OPTIONS --without-cython
make install LDFLAGS=-all-static
cd ..
echo "Building libimobiledevice-glue"
sleep 1
cd ./libimobiledevice-glue
./autogen.sh $BUILD_OPTIONS
make install LDFLAGS=-all-static
cd ..
echo "Building libirecovery"
sleep 1
cd ./libirecovery
libtoolize --force
aclocal -I m4
autoheader
automake --add-missing
autoconf
./configure $BUILD_OPTIONS --with-dummy --without-udev
make install LDFLAGS=-all-static
cd ..
echo "Building libgeneral"
sleep 1
cd ./libgeneral
./autogen.sh $BUILD_OPTIONS
make install LDFLAGS=-all-static
cd ..
echo "Building libfragmentzip"
sleep 1
cd ./libfragmentzip
./autogen.sh $BUILD_OPTIONS
make install LDFLAGS=-all-static
cd ..
echo "Building tsschecker"
sleep 1
cd ./tsschecker
./autogen.sh $BUILD_OPTIONS
make LDFLAGS=-all-static
cd ..
echo "Done building, cleaning up temp files:"
sleep 1
rm -f curl-$CURL_VERSION.tar.gz
rm -fr curl-$CURL_VERSION
rm -fr libplist
rm -fr libimobiledevice-glue
rm -fr libirecovery
rm -fr libgeneral
rm -fr libfragmentzip
rm -f libirecovery.patch
rm -fr /tmp/tsschecker_build_win-ucrt64
mv -f tsschecker/tsschecker/tsschecker.exe ../tsschecker_win-ucrt64.exe
cd ..
rm -fr tsschecker_build_win-ucrt64
echo "Done!"
echo "tsschecker.exe can be found inside the working directory"
