SHELL := /bin/bash
.ONESHELL:

LIB       = tests/mtproto2.pvl
LIBDIR    = ./lib

LIBSRC = \
    $(LIBDIR)/common.pvl \
    $(LIBDIR)/encryption/common.pvl \
    $(LIBDIR)/encryption/authorization.pvl \
    $(LIBDIR)/encryption/cloud_chats.pvl \
    $(LIBDIR)/authorization.pvl \
    $(LIBDIR)/cloud_chat.pvl

QUERIES := $(filter %.pv,$(MAKECMDGOALS))
$(QUERIES): ; @true


.PHONY: $(QUERIES) build clean run benchmark

build:
	@if [ -f $(LIB) ]; then
		echo "build already exists, doing nothing"
	else
		echo "Building $(LIB) from:"
		for f in $(LIBSRC); do
			echo "  - $$f"
		done
		cat $(LIBSRC) > $(LIB)
		echo "Created $(LIB)"
	fi

clean:
	@echo "Cleaning..."
	rm -f $(LIB) *.out $(LIBDIR)/*.out
	rm -rf html/*

# example: make run tests/cloud_chat_*.pv
run: $(LIB)
	@if [ -z "$(QUERIES)" ]; then
		echo "Usage: make run <query.pv> [...]"
		exit 1
	fi
	for arg in $(QUERIES); do
		echo "=== QUERY: $$arg ==="
		time proverif -lib $(LIB) "$$arg" | grep "RESULT"
		echo
	done