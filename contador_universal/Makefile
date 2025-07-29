TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/contador_display.v
TOPLEVEL = contador_display
MODULE = contador_universal_tb
WAVES = 1

SIM = icarus
LIBPYTHON_LOC=/usr/lib/google-cloud-sdk/platform/bundledpythonunix/lib/libpython3.12.so
include $(shell cocotb-config --makefiles)/Makefile.sim
