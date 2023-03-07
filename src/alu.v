module alu (
	input[7:0]	a_data_bus,
				b_data_bus,
	output[7:0] out_data_bus,
	input [7:0] opr,
	input en
);

localparam 	ADD = 2**0,
			SUB = 2**1,
			MUL = 2**2,
			DIV = 2**3,
			AND = 2**4,
			OR  = 2**5,
			XOR = 2**6,
			CMP = 2**7; 

assign out_data_bus = (en && (opr == ADD)) ? (a_data_bus + b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == SUB)) ? (a_data_bus - b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == MUL)) ? (a_data_bus * b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == DIV)) ? (a_data_bus / b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == SUB)) ? (a_data_bus - b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == AND)) ? (a_data_bus & b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == OR )) ? (a_data_bus | b_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == XOR)) ? (a_data_bus ^ b_data_bus) : 8'bz;

endmodule