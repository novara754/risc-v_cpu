# SIM_BUILD ?=  ../../tb_output/sim_build

SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../../src/definitions.sv $(PWD)/../../src/$(TEST_NAME).sv
TOPLEVEL = $(TEST_NAME)
MODULE = test
COCOTB_RESULTS_FILE ?= ../../tb_output/$(TEST_NAME)_results.xml

include $(shell cocotb-config --makefiles)/Makefile.sim
