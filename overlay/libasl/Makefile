CFLAGS=-I../include -I../xnu-2782.20.48/EXTERNAL_HEADERS -I.

# Ignore some headers
CFLAGS+=-D_MACH_INTERFACE_H_

# for __mbstate_t
CFLAGS+=-include wchar.h

# for 'bool'
CFLAGS+=-include stdbool.h

# for 'bootstrap_priv.h', not sure if this is a good idea
CFLAGS+=-I../include/liblaunch

#TODO: use mig to generate asl_ipcUser.c

libasl.a:
	clang -o libasl.a $(CFLAGS) asl.c asl_core.c asl_file.c asl_msg.c asl_object.c \
	asl_string.c syslog.c asl_client.c asl_fd.c asl_legacy1.c \
	asl_msg_list.c asl_store.c asl_util.c asl_common.c asl_memory.c
