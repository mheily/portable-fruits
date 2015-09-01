#
# Copyright (c) 2015 Mark Heily <mark@heily.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

.PHONY: build download

default: download clean unpack merge patch build

download: libnotify.tgz libc.tgz xnu.tgz NextBSD

# TODO: verify MD5sums
unpack:
	mkdir build
	cd build && tar zxf ../libnotify.tgz 
	cd build && tar zxf ../libc.tgz 
	cd build && tar zxf ../xnu.tgz 

merge:
	mkdir -p build/include/sys
	cp build/xnu-2782.20.48/bsd/sys/fileport.h \
	   build/xnu-2782.20.48/bsd/sys/_types.h \
	   build/xnu-2782.20.48/bsd/sys/appleapiopts.h \
		build/include/sys
	#
	mkdir -p build/include/sys/_types
	cp build/xnu-2782.20.48/bsd/sys/_types/_mach_port_t.h \
	  build/include/sys/_types
	#
	mkdir -p build/include/i386
	cp build/xnu-2782.20.48/bsd/i386/_types.h build/include/i386
	#
	mkdir -p build/include/servers
	cp NextBSD/include/servers/bootstrap.h build/include/servers
	#
	mkdir -p build/include/liblaunch
	cp -R NextBSD/lib/liblaunch/bootstrap_priv.h build/include/liblaunch
    #
	cp build/Libnotify-133.1.1/notify.h build/include
	#
	rsync -a ./build/xnu-2782.20.48/osfmk/mach/ build/include/mach/
	rsync -a NextBSD/lib/libasl/ ./build/libasl/
	rsync -a ./overlay/ ./build/ 

patch:
#perl -pi -e 's,#include <i386/_types.h>,,' build/include/mach/i386/vm_types.h
#	perl -pi -e 's,^typedef.*__u?int64_t;,,' build/include/i386/_types.h
#	perl -pi -e 's,^typedef.*__u?int64_t;,,' build/include/i386/_types.h
	perl -pi -e 's,#include <machine/_types.h>,,' build/include/sys/_types.h
	perl -pi -e 's,#include <sys/_pthread/_pthread_types.h>,,' build/include/sys/_types.h
	perl -pi -e 's,#include <i386/eflags.h>,,' build/include/mach/machine/thread_status.h
	perl -pi -e 's,#include <i386/eflags.h>,,' build/include/mach/i386/thread_status.h
	perl -pi -e 's,#include <machine/endian.h>,,' build/include/mach/mach_traps.h

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

NextBSD:
	git clone --depth 1 https://github.com/NextBSD/NextBSD.git NextBSD
	cd NextBSD && git reset --hard ab3b752ed68df06b6630ae3eda8eee4fb35820c2
