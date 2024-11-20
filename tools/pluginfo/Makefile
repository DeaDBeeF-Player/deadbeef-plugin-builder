CC:=gcc
CFLAGS+=-Wall
LDFLAGS:=-lpthread -ldl -lm

SUFFIX=
ifeq ($(OS),Windows_NT)
	SUFFIX=.exe
endif

all: x86_64/pluginfo

x86_64: x86_64/pluginfo

arm64: arm64/pluginfo

i686: i686/pluginfo

x86_64/pluginfo: 
	mkdir -p x86_64
	$(CC) -m64 -I ../../static-deps/lib-x86-64/include $(CFLAGS) pluginfo.c $(LDFLAGS) -o x86_64/pluginfo

arm64/pluginfo: 
	mkdir -p arm64
	$(CC) -m64 -I ../../static-deps/lib-x86-64/include $(CFLAGS) pluginfo.c $(LDFLAGS) -o arm64/pluginfo

i686/pluginfo:
	mkdir -p i686
	$(CC) -m32 -I ../../static-deps/lib-x86-32/include $(CFLAGS) pluginfo.c $(LDFLAGS) -o i686/pluginfo

.PHONY: clean
clean:
	rm -f i686/pluginfo$(SUFFIX) x86_64/pluginfo$(SUFFIX)
