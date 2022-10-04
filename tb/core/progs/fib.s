  addi x10, x0, 8
  addi x12, x0, 0
  addi x13, x0, 1
loop:
  add x11, x13, x0
  addi x10, x10, -1
  add x13, x13, x12
  add x12, x11, x0
  bne x10, x0, loop
  add x10, x11, x0
