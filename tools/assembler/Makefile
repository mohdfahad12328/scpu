PROJECT=scpu-asm

all: main.cpp
	clang++ --std=c++17 -o ${PROJECT} -g main.cpp

test: main.cpp
	clang++ --std=c++17 -D TEST -o ${PROJECT} -g main.cpp

debug: main.cpp
	clang++ --std=c++17 -D DEBUG -o ${PROJECT} -g main.cpp

debug-test: main.cpp
	clang++ --std=c++17 -D DEBUG -D TEST -o ${PROJECT} -g main.cpp