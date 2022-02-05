CHISEL_BUILD_DIR = ./build/chisel

############################## Chisel Flow #############################
test:
	mill -i __.test.testOnly vitisrtlkernel.VitisRTLKernelTest

verilog:
	mkdir -p $(CHISEL_BUILD_DIR)
	mill -i chiselVitisTemplate.runMain --mainClass vitisrtlkernel.VitisRTLKernelVerilog -td $(CHISEL_BUILD_DIR)

help:
	mill -i __.runMain --mainClass vitisrtlkernel.VitisRTLKernelVerilog --help

compile:
	mill -i __.compile

bsp:
	mill -i mill.bsp.BSP/install

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat

clean:
	-rm -rf $(CHISEL_BUILD_DIR)

.PHONY: test verilog help compile bsp reformat checkformat clean

############################## XCLBIN Flow #############################

XCLBIN_BUILD_DIR = ./build/xclbin

XCLBIN_TEMP_DIR = $(XCLBIN_BUILD_DIR)/tmp
XCLBIN_LOG_DIR = $(XCLBIN_BUILD_DIR)/log 
XCLBIN_REPORT_DIR = $(XCLBIN_BUILD_DIR)/report

VPP = v++
KERNEL_XO = $(XO).xo
LINK_CFG = $(XO).cfg


xclbin: $(KERNEL_XO) $(LINK_CFG)
	$(VPP) -t hw \
	--temp_dir $(XCLBIN_TEMP_DIR) --log_dir $(XCLBIN_LOG_DIR) --report_dir $(XCLBIN_REPORT_DIR) \
	--link $(KERNEL_XO) \
	--config $(LINK_CFG) -o $(XO).xclbin

clean_vpp :
	-rm -rf $(XCLBIN_TEMP_DIR)
	-rm -rf $(XCLBIN_LOG_DIR)
	-rm -rf $(XCLBIN_REPORT_DIR)
	-rm -rf ./.ipcaches

.PHONY: xclbin clean_vpp
