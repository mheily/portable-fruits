nextbsd=~/src/NextBSD

.PHONY: build download

default: download clean unpack merge build

download: libnotify.tgz libc.tgz xnu.tgz

# TODO: verify MD5sums
unpack:
	mkdir build
	cd build && tar zxf ../libnotify.tgz 
	cd build && tar zxf ../libc.tgz 
	cd build && tar zxf ../xnu.tgz 

merge:
	rsync -av $(nextbsd)/lib/libasl/ ./build/libasl/
	rsync -av ./overlay/ ./build/ 

build:
	cd build/libasl && make
	cd build/Libnotify-133.1.1/notifyd && make

libnotify.tgz:
	wget -O libnotify.tgz http://opensource.apple.com/tarballs/Libnotify/Libnotify-133.1.1.tar.gz

libc.tgz:
	wget -O libc.tgz http://opensource.apple.com/tarballs/Libc/Libc-1044.10.1.tar.gz

xnu.tgz:
	wget -O xnu.tgz http://www.opensource.apple.com/tarballs/xnu/xnu-2782.20.48.tar.gz
clean:
	rm -rf build
