PREFIX ?= /usr/local

install:
	ln -sf $(CURDIR)/bin/tabby $(PREFIX)/bin/tabby

uninstall:
	rm -f $(PREFIX)/bin/tabby

test:
	zsh tests/cli.zsh
