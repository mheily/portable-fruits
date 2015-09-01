SRCS=notify_proc.c notifyd.c service.c timer.c

#NOTE: not in upstream: notify_ipcServer.c


notifyd:
	$(CC) -I../../libasl -I../../xnu-2782.20.48/EXTERNAL_HEADERS -I. -o notifyd $(SRCS)

