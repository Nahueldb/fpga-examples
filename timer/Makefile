TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/timer.v
TOPLEVEL = timer
MODULE = timer_tb
WAVES = 1

SIM = icarus

COMPILE_ARGS += -Ptimer.CLK_FREQ=10
include $(shell cocotb-config --makefiles)/Makefile.sim
