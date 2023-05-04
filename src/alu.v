module alu (
	input[7:0]	a_data_bus,
				b_data_bus,
	output[7:0] out_data_bus,
	output[7:0] status_word,
	input [3:0] opr,
	input en,
	input [7:0] direct_data_bus,
	input direct_data_bus_en,
	input clk
);

localparam 	ADD = 0,
			SUB = 1,
			MUL = 2,
			DIV = 3,
			AND = 4,
			OR  = 5,
			XOR = 6,
			CMP = 7,
			INC = 8,
			DEC = 9,
			NOT = 10,
			SHL = 11,
			SHR = 12,
			RTR = 13,
			RTL = 14; 

// z|e|gt|lt|cf|0|0|0
reg [7:0]sw = 0;
wire [7:0]sw_w;
assign status_word = sw;
localparam 	SW_Z = 7,
			SW_E = 6,
			SW_GT = 5,
			SW_LT = 4,
			SW_CF = 3;

wire [7:0]b_t_data_bus;
assign b_t_data_bus = (en && direct_data_bus_en) ? direct_data_bus : b_data_bus;

assign {sw_w[SW_CF],out_data_bus} = (en && (opr == ADD)) ? (a_data_bus + b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == SUB)) ? (a_data_bus - b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == MUL)) ? (a_data_bus * b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == DIV)) ? (a_data_bus / b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == AND)) ? (a_data_bus & b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == OR )) ? (a_data_bus | b_t_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == XOR)) ? (a_data_bus ^ b_t_data_bus) : 8'bz;

assign out_data_bus = (en && (opr == INC)) ? (a_data_bus + 1) : 8'bz;
assign out_data_bus = (en && (opr == DEC)) ? (a_data_bus - 1) : 8'bz;
assign out_data_bus = (en && (opr == NOT)) ? (~a_data_bus) : 8'bz;
assign out_data_bus = (en && (opr == SHL)) ? (a_data_bus << 1) : 8'bz;
assign out_data_bus = (en && (opr == SHR)) ? (a_data_bus >> 1) : 8'bz;
assign out_data_bus = (en && (opr == RTL)) ? ({a_data_bus[6:0],a_data_bus[7]}) : 8'bz;
assign out_data_bus = (en && (opr == RTR)) ? ({a_data_bus[0],a_data_bus[7:1]}) : 8'bz;


assign sw_w[SW_Z] = en && (opr == CMP) && (a_data_bus == 0);
assign sw_w[SW_E] = en && (opr == CMP) && (a_data_bus == b_t_data_bus);
assign sw_w[SW_GT] = en && (opr == CMP) && (a_data_bus > b_t_data_bus);
assign sw_w[SW_LT] = en && (opr == CMP) && (a_data_bus < b_t_data_bus);
assign sw_w[2] = 0;
assign sw_w[1] = 0;
assign sw_w[0] = 0;

always @(posedge clk) begin
	if(en && (opr == CMP))
		sw <= sw_w;
end

endmodule
