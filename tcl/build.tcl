# --- Design sources ---
read_vhdl ./src/definitions.vhdl
read_vhdl ./src/alu.vhdl
read_vhdl ./src/register_file.vhdl
read_vhdl ./src/decoder.vhdl
read_vhdl ./src/memory.vhdl
read_vhdl ./src/core.vhdl

# --- Simulation sources ---
read_vhdl ./tb/alu_tb.vhdl
read_vhdl ./tb/register_file_tb.vhdl
read_vhdl ./tb/decoder_tb.vhdl
read_vhdl ./tb/memory_tb.vhdl
read_vhdl ./tb/core_tb.vhdl

# --- Use VHDL 2008 ---
set_property file_type {VHDL 2008} [get_files *.vhdl]

# --- Synthesis ---
quit
