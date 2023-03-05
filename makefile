TOP_MODULE := cpu
SRC_FILES := $(wildcard src/*.v)
TEST_FILE := sim/register_tb.v
CST_FILE = src/scpu-fpga.cst

BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

bin/${TOP_MODULE}_test.o: ${SRC_FILES}
	iverilog -o bin/${TOP_MODULE}_test.o -s ${TOP_MODULE} ${SRC_FILES}

test: bin/${TOP_MODULE}_test.o
	vvp bin/${TOP_MODULE}_test.o

synth: ${SRC_FILES}
	yosys -p "read_verilog ${SRC_FILES}; synth_gowin -top ${TOP_MODULE} -json bin/${TOP_MODULE}.json"
	
pnr: bin/${TOP_MODULE}.json
	nextpnr-gowin --json bin/${TOP_MODULE}.json --write bin/${TOP_MODULE}_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst ${CST_FILE}

bsgen: bin/${TOP_MODULE}_pnr.json ${CST_FILE}
	gowin_pack -d ${FAMILY} -o bin/${TOP_MODULE}.fs bin/${TOP_MODULE}_pnr.json

show: ${SRC_FILES}
	yosys -p "read_verilog ${SRC_FILES}; show ${TOP_MODULE}"