# SIM_BUILD ?=  ../../tb_output/sim_build

SIM ?= ghdl
EXTRA_ARGS ?= --std=08
TOPLEVEL_LANG ?= vhdl

VHDL_SOURCES += $(PWD)/../../src/definitions.vhdl $(PWD)/../../src/$(TEST_NAME).vhdl
TOPLEVEL = $(TEST_NAME)
MODULE = test
COCOTB_RESULTS_FILE ?= ../../tb_output/$(TEST_NAME)_results.xml

include $(shell cocotb-config --makefiles)/Makefile.sim
