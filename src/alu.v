module alu (
	input[7:0]	a_data_bus,
				b_data_bus,
	output[7:0] out_data_bus,
	input [7:0] opr,
	input en,
	input [7:0] direct_data_bus,
	input direct_data_bus_en
);

localparam 	ADD = 0,
			SUB = 1,
			MUL = 2,
			DIV = 3,
			AND = 4,
			OR  = 5,
			XOR = 6,
			CMP = 7; 

wire [7:0]b_t_data_bus;
assign b_t_data_bus = (en && direct_data_bus_en) ? direct_data_bus : b_data_bus;

assign out_data_bus = (en && (opr == ADD)) ? (a_data_bus + b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == SUB)) ? (a_data_bus - b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == MUL)) ? (a_data_bus * b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == DIV)) ? (a_data_bus / b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == SUB)) ? (a_data_bus - b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == AND)) ? (a_data_bus & b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == OR )) ? (a_data_bus | b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == XOR)) ? (a_data_bus ^ b_t_data_bus) : 8'bz;

endmodule