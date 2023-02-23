TOP_MODULE := cpu
SRC_FILES := $(wildcard src/*.v)
TEST_FILE := sim/register_tb.v

bin/${TOP_MODULE}_test.o: ${SRC_FILES}
	iverilog -o bin/${TOP_MODULE}_test.o -s ${TOP_MODULE} ${SRC_FILES}

test: bin/${TOP_MODULE}_test.o
	vvp bin/${TOP_MODULE}_test.o

compile: ${SRC_FILES}
	yosys -p "read_verilog ${SRC_FILES}; synth_gowin -top ${TOP_MODULE} -json bin/${TOP_MODULE}.json"
	

show: ${SRC_FILES}
	yosys -p "read_verilog ${SRC_FILES}; show ${TOP_MODULE}"