# --- Design sources ---
read_vhdl ./src/definitions.vhdl
read_vhdl ./src/alu.vhdl
read_vhdl ./src/register_file.vhdl
read_vhdl ./src/decoder.vhdl
read_vhdl ./src/memory.vhdl
read_vhdl ./src/core.vhdl

# --- Simulation sources ---
read_vhdl ./tb/core_tb.vhdl
read_mem ./tb/core_tb_mem.bin

# --- Use VHDL 2008 ---
set_property file_type {VHDL 2008} [get_files *.vhdl]

# --- Run simulation ---
save_project_as -force risc_v proj
set_property top core_tb [get_fileset sim_1]
start_gui
launch_simulation -simset sim_1 -mode behavioral
