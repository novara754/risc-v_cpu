TEST_NAME = core
include ../testbench.mk

VERILOG_SOURCES += \
	$(PWD)/../../src/alu.sv \
	$(PWD)/../../src/decoder.sv \
	$(PWD)/../../src/memory.sv \
	$(PWD)/../../src/register_file.sv

.PHONY: prepare
prepare:
	$(MAKE) -C progs/ all
