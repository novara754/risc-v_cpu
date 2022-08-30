# [WIP] RISC-V CPU 

Implementation of a RISC-V CPU in VHDL.

RISC-V is a fully free and open ISA (instruction set architecture) that is gaining popularity,
especially in hobbyist spheres.
The RISC-V specification details a base instruction set (RV32I) as well as many extensions, such
as for floating-point number support, atomics, and privileged instructions.
Feel free to visit [the RISC-V official website](https://riscv.org/) to learn more
about RISC-V.

## Goals

This project is highly work-in-progress, and the current goal is to implement
the RV32-I ISA. This way simple programs written in RISC-V assembly or higher languages like
C, C++ or Rust should be able to run on the CPU designed in this repository.

Of course for a CPU to something interesting it needs to communicate with the outside world,
i.e. support IO. For this I plan to add different devices connected to the CPU, such as
UART, VGA and simple GPIO support. However the main goal for now is to implement
the ISA itself, which will be complicated enough.

## Structural Overview

This repository contains three major subdirectories: `src/`, `tb/` and `tcl/`.

The `src/` subdirectory contains the synthesisable modules to implement the RISC-V CPU.
Currently these are...

  - the `register_file` to store the contents of the general purpose registers (X0-X31), as well
  as to provide simple input/output mechanics for working with these registers,
  - the `decoder` which breaks instructions down into control signals for the register file, ALU,
  etc.,
  - the `alu` which implements mathematical and logical operations on 32-bit values as dictated
  by the control signals from the instruction decoder,
  - the `memory` which implements a basic RAM block and allows read data and instructions
  concurrently while also allowing storing data of different widths (byte, half-word, word),
  - the `core` which combines the `register_file`, `decoder`, `alu`, and a program counter
  register and interconnects these parts to allow execution of instruction streams.

The `definitions.vhdl` file contains common type definitions used by each of the modules.

Testbenches can be found in the `tb/` subdirectory. These testbenches provide behavioral tests 
for each of the previously described modules. These are mostly automated and will compare the
modules' outputs to expected outputs, failing if they do not match. The `core_tb` testbench
however is not automated yet and requires human supervision.
The testbenches can be executed using the TCL scripts located in the `tcl/` subdirectory.
These scripts are written to work with [Xilinx Vivado](https://www.xilinx.com/support/download.html),
a mostly free IDE.
The scripts can be invoked as follows:
```
$ vivado -nolog -nojournal -mode batch -source ./tcl/<file>.tcl
```

## Progress

Exceptions are not yet supported.

Supported instructions (RV32I):
 - [x] ADDI
 - [x] ADD
 - [x] BNE
 - [x] SW
 - [x] JAL
 - [ ] SLTI
 - [ ] XORI
 - [ ] ORI
 - [ ] ANDI
 - [ ] SLLI
 - [ ] SRLI
 - [ ] SRAI
 - [ ] SUB
 - [ ] SLL
 - [ ] SLT
 - [ ] SLTU
 - [ ] XOR
 - [ ] SRL
 - [ ] SRA
 - [ ] OR
 - [ ] AND
 - [ ] JALR
 - [ ] BEQ
 - [ ] BLT
 - [ ] BGE
 - [ ] BLTU
 - [ ] BGEU
 - [ ] LW
 - [ ] LH
 - [ ] LB
 - [ ] SH
 - [ ] SB
 - [ ] LUI
 - [ ] AUIPC
 - [ ] FENCE
 - [ ] FENCE.I
 - [ ] ECALL
 - [ ] EBREAK
 - [ ] CSRRW
 - [ ] CSRRS
 - [ ] CSRRC
 - [ ] CSRRWI
 - [ ] CSRRSI
 - [ ] CSRRCI

## License

Licensed under the [BSD 3-Clause License](./LICENSE).
