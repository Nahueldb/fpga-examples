TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/blink.v
TOPLEVEL = blink_led
MODULE = blink_tb
WAVES = 1

SIM = icarus

include $(shell cocotb-config --makefiles)/Makefile.sim
