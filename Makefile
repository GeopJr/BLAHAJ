.PHONY: all install uninstall test build debug static
PREFIX ?= /usr

all: build

debug:
	shards build

build:
	shards build --production --release --no-debug
	
static:
	shards build --production --release --no-debug --static

build_mt:
	shards build --production --no-debug --release -Dpreview_mt
	
static_mt:
	shards build --production --no-debug --release -Dpreview_mt --static

test_all: test test_mt

test:
	crystal spec --order random

test_mt:
	crystal spec --order random -Dpreview_mt 

install:
	install -D -m 0755 bin/blahaj $(PREFIX)/bin/blahaj

uninstall:
	rm -f $(PREFIX)/bin/blahaj
