.PHONY: all
all: build/fib.bin

build/%.bin: build/%.o
	riscv32-unknown-elf-objcopy -O binary $< $@

build/%.o: %.s
	@mkdir -p build
	riscv32-unknown-elf-as -o $@ $<
