# [WIP] RISC-V CPU 

Implementation of a RISC-V CPU in SystemVerilog.

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

This repository contains two subdirectories: `src/` and `tb/`.

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

The `definitions.sv` file contains common type definitions used by each of the modules.

Testbenches can be found in the `tb/` subdirectory. These testbenches provide behavioral tests 
for each of the previously described modules. These are mostly automated and will compare the
modules' outputs to expected outputs, failing if they do not match.

The testbenches are written using [cocotb](https://www.cocotb.org/). Please follow the installation
instructions in the [cocotb documentation](https://docs.cocotb.org/en/stable/install.html).
The simulator used for the testbenches is [Icarus Verilog](https://iverilog.icarus.com/) which also
needs to be installed accordingly. To make sure you get the latest version I recommend downloading
and building it from source.

To execute the testbenches you need to run `make` in the root directory of this repository.
This will automatically scan each subdirectory of the `tb/` directory and execute each test script.
The result of all tests will written to the console output.
Individual tests can be executed by using `make tb/<sub>` where `<sub>` is the name of the 
subdirectory of the respective test you wish to run.

## Progress

Exceptions are not yet supported.

Supported instructions (RV32I):
 - [x] ADDI
 - [x] XORI
 - [x] ORI
 - [x] ANDI
 - [x] SLLI
 - [x] SRLI
 - [x] SRAI
 - [x] ADD
 - [x] BNE
 - [x] SW
 - [x] JAL
 - [ ] SLTI
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
