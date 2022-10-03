TEST_NAME = core
include ../testbench.mk

VHDL_SOURCES += \
	$(PWD)/../../src/alu.vhdl \
	$(PWD)/../../src/decoder.vhdl \
	$(PWD)/../../src/memory.vhdl \
	$(PWD)/../../src/register_file.vhdl

.PHONY: prepare
prepare:
	$(MAKE) -C progs/ all
