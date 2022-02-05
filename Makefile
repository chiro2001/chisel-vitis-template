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

VPP = v++
VITIS_PLATFORM = xilinx_u280_xdma_201920_3 # can be queried by 'plaforminfo -l'
XO = ./vivado_exports/rtl_kernel_wizard_0.xo
XCLBIN_LINK_CFG = ./vivado_exports/xclbin_link.cfg
TEMP_DIR = $(XCLBIN_BUILD_DIR)/tmp

xclbin: $(XO) $(XCLBIN_LINK_CFG)
	mkdir -p $(XCLBIN_BUILD_DIR)
	$(VPP) -t hw --platform $(VITIS_PLATFORM) --temp_dir $(TEMP_DIR) --link $(XO) --config $(XCLBIN_LINK_CFG) -o $(XCLBIN_BUILD_DIR)/kernel.xclbin

.PHONY: xclbin
