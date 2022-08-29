# --- Design sources ---
read_vhdl ./src/definitions.vhdl
read_vhdl ./src/alu.vhdl

# --- Simulation sources ---
read_vhdl ./tb/alu_tb.vhdl

# --- Use VHDL 2008 ---
set_property file_type {VHDL 2008} [get_files *.vhdl]

# --- Run simulation ---
save_project_as -force risc_v proj
set_property top alu_tb [get_fileset sim_1]
launch_simulation -simset sim_1 -mode behavioral
quit
