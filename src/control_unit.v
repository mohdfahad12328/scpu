/*------------------------------------------------------------------------------
--  CONTROL UNIT
------------------------------------------------------------------------------*/

module controlUint (

	// registers
	output [7:0]
			regs_rdata,
			regs_wdata,
			regs_raddr,
			regs_waddr,
			
			regs_alu_r_a,
			regs_alu_r_b,
			regs_alu_w,

	// memory
	output  mem_ce,
			mem_rst,
			mem_w,
			mem_r,
			mem_oe,

	// program counter
	output  pc_w,
			pc_r,
			pc_rst,
			pc_inc,

	// alu
	output [2:0]
		   	alu_opr,
	output 	alu_en,
	output alu_direct_data_bus_en,

	// buses
	input [7:0]   data_bus_in,
	output [7:0]  data_bus_out,
	input [15:0]  addr_bus_in,
	output [15:0] addr_bus_out,
	
	// clk
	input clk
);


localparam HIGH = 1;
localparam LOW  = 0;


// registers interface

reg [7:0] 	r_rdata = 0,
			r_wdata = 0,
			r_raddr = 0,
			r_waddr = 0;

assign regs_rdata = r_rdata;
assign regs_wdata = r_wdata;
assign regs_raddr = r_raddr;
assign regs_waddr = r_waddr;


// inst register
reg [7:0] inst, inst_t;
wire inst_r, inst_w;
wire inst_t_r, inst_t_w;
assign data_bus_out = inst_r ? inst : 8'bz;
assign data_bus_out = inst_t_r ? inst_t : 8'bz;

always @(posedge clk)
	if (inst_w)
		inst <= data_bus_in;

always @(posedge clk) begin
	if (inst_t_w)
		inst_t <= data_bus_in;
end

// addr register
reg [15:0] addrr;
wire addrr_r, addrr_wl, addrr_wh;
assign addr_bus_out = addrr_r ? addrr : 16'bz;
always @(posedge clk) begin
	if(addrr_wl) begin
		addrr[7:0] <= data_bus_in;
	end
	else if(addrr_wh) begin
		addrr[15:8] <= data_bus_in;
	end
end

// alu
reg [3:0]alu_opr_r = 0;
reg [7:0]r_alu_w = 0, r_alu_r_a = 0, r_alu_r_b = 0;
assign alu_opr = alu_opr_r;
localparam 	ALU_ADD = 2**0,
			ALU_SUB = 2**1,
			ALU_MUL = 2**2,
			ALU_DIV = 2**3,
			ALU_AND = 2**4,
			ALU_OR  = 2**5,
			ALU_XOR = 2**6,
			ALU_CMP = 2**7;

assign regs_alu_w = r_alu_w;
assign regs_alu_r_a = r_alu_r_a;
assign regs_alu_r_b = r_alu_r_b;

/*------------------------------------------------------------------------------
--  ALL CONTROL SIGNALS
------------------------------------------------------------------------------*/
/* 
	ncs --> no of control signals
	acs --> all control signals
*/
localparam ncs = 2 + 2 + 3 + 5 + 4 + 2; // isnt_t,alu,addrr,mem,pc,inst
reg [ncs-1:0] acs = 0;
assign {	inst_t_r, inst_t_w,
			alu_direct_data_bus_en ,alu_en,
			addrr_r, addrr_wl, addrr_wh,
			mem_ce, mem_oe, mem_r, mem_rst, mem_w,
			pc_inc, pc_r, pc_rst, pc_w,
			inst_r, inst_w
	} = acs;

localparam 	INST_W = 2**0,
			INST_R = 2**1,
			PC_W   = 2**2,
			PC_RST = 2**3,
			PC_R   = 2**4,
			PC_INC = 2**5,
			MEM_W  = 2**6,
			MEM_RST= 2**7,
			MEM_R  = 2**8,
			MEM_OE = 2**9,
			MEM_CE = 2**10,
			ADDRR_WH = 2**11,
			ADDRR_WL = 2**12,
			ADDRR_R = 2**13,
			ALU_EN  = 2**14,
			ALU_D_EN = 2**15,
			INST_T_W = 2**16,
			INST_T_R = 2**17;


/*------------------------------------------------------------------------------
--  STATE MACHINE PARAMETERS
------------------------------------------------------------------------------*/
reg [3:0]state		 = 0;

localparam 	WAIT     = 0,
			FETCH0   = 1,
			FETCH1   = 2,
			EXECUTE0 = 3,
			EXECUTE1 = 4,
			EXECUTE2 = 5,
			EXECUTE3 = 6,
			EXECUTE4 = 7,
			EXECUTE5 = 8;

reg [2:0]wait_cnt = 0;
localparam WAIT_TIME = 2;

/*------------------------------------------------------------------------------
--  EXECUTION STATE MACHINE
------------------------------------------------------------------------------*/
always @(negedge clk) begin
case(state)

WAIT: begin
	wait_cnt <= wait_cnt + 1;
		if(wait_cnt == WAIT_TIME)
			state <= FETCH0;
		else state <= state;
	end
		
/*------------------------------------------------------------------------------
--  FETCH
------------------------------------------------------------------------------*/
FETCH0: begin
	r_wdata <= LOW;
	r_rdata <= LOW;
	r_waddr <= LOW;
	r_raddr <= LOW;
	r_alu_w <= LOW; 
	r_alu_r_a<=LOW;
	r_alu_r_b<=LOW;
	alu_opr_r<=LOW;
	// mem[pc]
	acs <= MEM_CE|MEM_R|PC_R;
	
	state <= FETCH1;
end
		
FETCH1: begin
	// inst <- mem[pc]; pc <- pc + 1;
	acs <= MEM_CE|MEM_OE|PC_R|INST_W|PC_INC;

	state <= EXECUTE0;
end

/*------------------------------------------------------------------------------
--  EXECUTE0
------------------------------------------------------------------------------*/
EXECUTE0: begin

// IMMEDIATE MODE
if(inst[7:3] >= 5'b00000 && inst[7:3] <= 5'b01000) begin
	// mem[pc];
	acs <= MEM_CE|MEM_R|PC_R;
	state <= EXECUTE1;
end

// REGISTER DIRECT
if(inst[7:3] >= 5'b01001 && inst[7:3] <= 5'b10010) begin
	// mem[pc];
	acs <= MEM_CE|MEM_R|PC_R;
	state <= EXECUTE1;
end

// REGISTER REGISTER
if (inst <= 8'hff && inst >= 8'hf7) begin
	// mem[pc];
	acs <= MEM_CE|MEM_R|PC_R;
	state <= EXECUTE1;
end

// REGISTER INDIRECT
if (inst <= 8'hf6 && inst >= 8'hed) begin
	// mem[pc];
	acs <= MEM_CE|MEM_R|PC_R;
	state <= EXECUTE1;
end

end

/*------------------------------------------------------------------------------
-- EXECUTE1 
------------------------------------------------------------------------------*/
EXECUTE1: begin

// IMMEDIATE MODE
if (inst[7:3] >= 5'b00000 && inst[7:3] <= 5'b01000) begin 
	// LDR
	if (inst[7:3] == 5'b00000) begin
		// r <- mem[pc]; pc <- pc + 1;
		acs <= MEM_CE|MEM_OE|PC_R|PC_INC;
		r_wdata[inst[2:0]] <= HIGH;
		state <= FETCH0;	
	end
	// ALU
	else begin
			acs <= MEM_CE|MEM_OE|PC_R|PC_INC|ALU_EN|ALU_D_EN;
			r_alu_r_a[inst[2:0]] <= HIGH;
			r_alu_w[inst[2:0]] <= HIGH;
			alu_opr_r <= inst[7:3] - 1;
			state <= FETCH0;
		end
	end

// REGISTER DIRECT
if(inst[7:3] >= 5'b01001 && inst[7:3] <= 5'b10010) begin
	// addrr[15:8] <- mem[pc]; pc <- pc + 1;
	acs <= MEM_CE|MEM_OE|PC_R|ADDRR_WH|PC_INC;
	state <= EXECUTE2;
end

// REGISTER REGISTER
if (inst <= 8'hff && inst >= 8'hf7) begin
	// isnt_t <- mem[pc];
	acs <= MEM_CE|MEM_OE|PC_R|INST_T_W;
	state <= EXECUTE2;
end

// REGISTER INDIRECT
if (inst <= 8'hf6 && inst >= 8'hed) begin
	// isnt_t <- mem[pc];
	acs <= MEM_CE|MEM_OE|PC_R|INST_T_W;
	state <= EXECUTE2;
end

end

/*------------------------------------------------------------------------------
--  EXECUTE2
------------------------------------------------------------------------------*/		
EXECUTE2: begin

// REGISTER DIRECT
if(inst[7:3] >= 5'b01001 && inst[7:3] <= 5'b10010) begin
	// mem[pc]
	acs <= MEM_CE|MEM_R|PC_R;
	state <= EXECUTE3;
end

// REGISTER REGISTER
if (inst <= 8'hff && inst >= 8'hf7) begin
	// LDR
	if(inst == 8'hff) begin
		acs <= PC_INC;
		r_wdata[inst_t[5:3]] <= HIGH;
		r_rdata[inst_t[2:0]] <= HIGH;
	end
	else begin
		acs <= ALU_EN|MEM_CE|MEM_OE|PC_R|PC_INC;
		r_alu_r_a[inst_t[5:3]] <= HIGH;
		r_alu_r_b[inst_t[2:0]] <= HIGH;
		r_alu_w[inst_t[5:3]] <= HIGH;
		alu_opr_r <= inst - 8'hfe;
	end
	state <= FETCH0;
end

// REGISTER INDIRECT
if (inst <= 8'hf6 && inst >= 8'hed) begin
	case(inst_t[1:0])
		0: begin
			r_raddr <= 2**0 + 2**1;
		end
		1: begin
			r_raddr <= 2**2 + 2**3;
		end
		2: begin
			r_raddr <= 2**4 + 2**5;
		end
		3: begin
			r_raddr <= 2**6 + 2**7;
		end
	endcase
	// STR
	if(inst == 8'hed) begin
		acs <= MEM_CE|MEM_W|PC_INC;
		r_rdata[inst_t[4:2]] <= HIGH;
		state <= FETCH0;
	end
	// LDR, ALU
	else begin
		acs <= MEM_CE|MEM_R|PC_INC;
		state <= EXECUTE3;
	end
end

end

/*------------------------------------------------------------------------------
--  EXECUTE3
------------------------------------------------------------------------------*/
EXECUTE3: begin

// REGISTER DIRECT
if(inst[7:3] >= 5'b01001 && inst[7:3] <= 5'b10010) begin
	// addrr[7:0] <- mem[pc]; pc <- pc + 1;
	acs <= MEM_CE|MEM_OE|PC_R|ADDRR_WL|PC_INC;
	state <= EXECUTE4;
end

// REGISTER INDIRECT
if (inst <= 8'hf6 && inst >= 8'hed) begin
	// LDR
	if (inst == 8'hf6) begin
		acs <= MEM_CE|MEM_OE;
		r_wdata[inst_t[4:2]] <= HIGH;
	end
	// ALU
	else begin
		acs <= MEM_CE|MEM_OE|ALU_EN|ALU_D_EN;
		r_alu_r_a[inst_t[4:2]] <= HIGH;
		r_alu_w[inst_t[4:2]] <= HIGH;
		alu_opr_r <= inst - 8'hf5;
	end
	state <= FETCH0;
end

end

/*------------------------------------------------------------------------------
--  EXECUTE4
------------------------------------------------------------------------------*/
EXECUTE4: begin

// REGISTER DIRECT
if(inst[7:3] >= 5'b01001 && inst[7:3] <= 5'b10010) begin
	// STR
	if(inst[7:3] == 5'b10010) begin
	// mem[addrr] <- r;
	acs <= MEM_CE|MEM_W|ADDRR_R;
	r_rdata[inst[2:0]] <= HIGH;
	state <= FETCH0;
	end
	// LDR OR ALU
	else begin
		// mem[addrr]
		acs <= MEM_CE|MEM_R|ADDRR_R;
		state <= EXECUTE5;
	end
end

end

/*------------------------------------------------------------------------------
--  EXECUTE5
------------------------------------------------------------------------------*/
EXECUTE5: begin

// REGISTER DIRECT
if(inst[7:3] >= 5'b01001 && inst[7:3] <= 5'b10010) begin
	// LDR
	if (inst[7:3] == 5'b01001) begin
		// r <- mem[addrr];
		acs <= MEM_CE|MEM_OE|ADDRR_R;
		r_wdata[inst[2:0]] <= HIGH;
		state <= FETCH0;	
	end
	// ALU
	else begin
			acs <= MEM_CE|MEM_OE|ADDRR_R|ALU_EN|ALU_D_EN;
			r_alu_r_a[inst[2:0]] <= HIGH;
			r_alu_w[inst[2:0]] <= HIGH;
			alu_opr_r <= inst[7:3] - 5'b01010;
			state <= FETCH0;
		end
	end
end

endcase

end
endmodule
