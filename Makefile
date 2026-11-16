PREFIX       ?= /usr/local
BINDIR       ?= $(PREFIX)/bin
STRICTA_REPO ?= https://github.com/lucianmarin/stricta.git
STRICTA_DIR  ?= .pkgs/lucianmarin/stricta
STRICTA      ?= $(STRICTA_DIR)/stricta
STRLIB_REPO  ?= https://github.com/lucianmarin/strlib.git
STRLIB_DIR   ?= .pkgs/lucianmarin/strlib
TARGET        = fetch

.PHONY: all test install uninstall update-deps clean distclean

all: $(TARGET)

$(STRICTA):
	@if [ ! -d "$(STRICTA_DIR)/.git" ]; then \
		mkdir -p .pkgs/lucianmarin; \
		git clone --depth 1 "$(STRICTA_REPO)" "$(STRICTA_DIR)"; \
	else \
		git -C "$(STRICTA_DIR)" pull --ff-only --quiet || true; \
	fi
	$(MAKE) -C "$(STRICTA_DIR)" all

$(STRLIB_DIR)/os.str:
	@if [ ! -d "$(STRLIB_DIR)/.git" ]; then \
		mkdir -p .pkgs/lucianmarin; \
		git clone --depth 1 "$(STRLIB_REPO)" "$(STRLIB_DIR)"; \
	else \
		git -C "$(STRLIB_DIR)" pull --ff-only --quiet || true; \
	fi

$(TARGET): $(STRICTA) $(STRLIB_DIR)/os.str fetch.str semver.str manifest.str github.str
	$(STRICTA) -I .pkgs -M "strlib=$(STRLIB_DIR)" fetch.str -o $(TARGET)

test: $(TARGET)
	@set -e; \
	STRICTA_BIN="$(abspath $(STRICTA))" $(STRICTA) -I . -I .pkgs -M "strlib=$(STRLIB_DIR)" tests/test_fetch.str -o /tmp/fetch_test_bin; \
	STRICTA_BIN="$(abspath $(STRICTA))" /tmp/fetch_test_bin; \
	rm -f /tmp/fetch_test_bin

update-deps:
	git -C "$(STRICTA_DIR)" pull --ff-only
	$(MAKE) -C "$(STRICTA_DIR)" all
	git -C "$(STRLIB_DIR)" pull --ff-only

install: $(TARGET)
	install -d "$(DESTDIR)$(BINDIR)"
	install -m 755 $(TARGET) "$(DESTDIR)$(BINDIR)/$(TARGET)"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/$(TARGET)"

clean:
	rm -f $(TARGET) *.ll *.o *.out

distclean: clean
	rm -rf .pkgs .stricta
