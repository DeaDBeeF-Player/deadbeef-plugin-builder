CC=gcc
CFLAGS=-Wall
LDFLAGS=-lpthread -ldl -lm

all:
	mkdir -p x86_64
	$(CC) -m64 $(CFLAGS) pluginfo.c $(LDFLAGS) -o x86_64/pluginfo

clean:
	rm *.o i686/pluginfo x86_64/pluginfo
