CFLAGS=-I../xnu-2782.20.48/EXTERNAL_HEADERS -I.

#TODO: use mig to generate asl_ipcUser.c

libasl.a:
	clang -o libasl.a $(CFLAGS) asl.c asl_core.c asl_file.c asl_msg.c asl_object.c \
	asl_string.c syslog.c asl_client.c asl_fd.c asl_legacy1.c \
	asl_msg_list.c asl_store.c asl_util.c asl_common.c asl_memory.c
