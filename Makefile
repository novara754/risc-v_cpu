TESTBENCHES := tb/decoder tb/alu tb/memory tb/register_file tb/core

.PHONY: $(TESTBENCHES)

.PHONY: all
all: $(TESTBENCHES)

$(TESTBENCHES):
	@cd $@ && $(MAKE) prepare
	@cd $@ && $(MAKE)

.PHONY: clean
clean:
	rm -f tb_output/*
	$(foreach TEST, $(TESTBENCHES), $(MAKE) -C $(TEST) clean;)

regression:
	$(foreach TEST, $(TESTBENCHES), $(MAKE) -C $(TEST) regression;)
