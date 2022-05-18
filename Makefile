.PHONY: all install uninstall test build debug static
PREFIX ?= /usr

all: build

debug:
	shards build

build:
	shards build --production --release --no-debug
	
static:
	shards build --production --release --no-debug --static

test:
	crystal spec --order random

install:
	install -D -m 0755 bin/blahaj $(PREFIX)/bin/blahaj

uninstall:
	rm -f $(PREFIX)/bin/blahaj
