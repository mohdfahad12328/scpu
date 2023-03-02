// CONTROL UNIT

module controlUint (
    output [7:0]
            regs_rdata,
            regs_wdata,
            regs_raddr,
            regs_waddr,
    output  mem_ce,
            mem_rst,
            mem_w,
            mem_r,
            mem_oe,
    output  pc_w,
            pc_r,
            pc_rst,
            pc_inc,
    input [7:0]   data_bus_in,
    output [7:0]  data_bus_out,
    input [15:0]  addr_bus_in,
    output [15:0] addr_bus_out,
    input clk
);


localparam HIGH = 1;
localparam LOW  = 0;


// registers interface

reg [7:0] r_rdata = 0;
reg [7:0] r_wdata = 0;
reg [7:0] r_raddr = 0;
reg [7:0] r_waddr = 0;

assign regs_rdata = r_rdata;
assign regs_wdata = r_wdata;
assign regs_raddr = r_raddr;
assign regs_waddr = r_waddr;


// inst register

reg [7:0] inst;
wire inst_r, inst_w;

assign data_bus_out = inst_r ? inst : 8'bz;
always @(posedge clk)
    if (inst_w)
        inst <= data_bus_in;

// addr register
reg [15:0] addrr;
wire addrr_r, addrr_w1, addrr_wh;
assign addr_bus_out = addrr_r ? addrr : 16'bz;
always @(posedge clk) begin
	if(addrr_wl) begin
		addrr[7:0] <= data_bus_in;
	end
	else if(addrr_wh) begin
		addrr[15:8] <= data_bus_in;
	end
end

// all control signals
/* 
	ncs --> no of control signals
 	acs --> all control signals
*/
localparam ncs = 3 + 5 + 4 + 2; // addrr,mem,pc,inst
reg [ncs-1:0] acs = 0;
assign {			addrr_r, addrr_wl, addrr_wh,
					mem_ce, mem_oe, mem_r, mem_rst, mem_w,
					pc_inc, pc_r, pc_rst, pc_w,
					inst_r, inst_w,
	} = acs;

localparam 		 INST_W = 2**0,
					 INST_R = 2**1,
					 PC_W   = 2**2,
					 PC_RST = 2**3,
					 PC_R   = 2**4,
					 PC_INC = 2**5,
					 MEM_W  = 2**6,
					 MEM_RST= 2**7,
					 MEM_R  = 2**8,
					 MEM_OE = 2**9,
					 MEM_CE = 2**10;
					 ADDRR_WH = 2**11;
					 ADDRR_WL = 2**12;
					 ADDRR_R = 2**13;
					 
// execution state machine

reg [2:0]state      = 0;
localparam FETCH    = 0;
localparam EXECUTE0 = 1;
localparam EXECUTE1 = 2;

always @(negedge clk) begin
    case(state)
        FETCH: begin
				r_wdata <= LOW;
            // isnt <- mem[pc]
            // pc <- pc + 1
            acs <= MEM_CE | MEM_OE | MEM_R | INST_W | PC_R | PC_INC;
            
            state <= EXECUTE0;
        end
        
        EXECUTE0: begin
            case(inst[7:3])
                // ldr immediate
                5'b00000: begin
                    // r <- mem[pc]; pc <- pc + 1;
							acs <= MEM_CE | MEM_OE | MEM_R | PC_R | PC_INC;
							r_wdata[inst[2:0]] <= HIGH;

                    state <= FETCH;
              end
					// str register direct
					5'b10010: begin
							// addrr[15:8] <- mem[pc]; pc <- pc + 1;
							acs <= MEM_CE | MEM_OE | MEM_R | PC_R | ADDRR_WH | PC_INC;
							
							state <= EXECUTE1;
					end
            endcase
        end
		  
		  EXECUTE1: begin
		  case(inst[7:3])
				// str register direct
				5'b10010: begin
						// addrr[7:0] <- mem[pc]; pc <- pc + 1;
						acs <= MEM_CE | MEM_OE | MEM_R | PC_R | ADDRR_WL | PC_INC;
						
						state <= EXECUTE2;
				end
			endcase
		  end
		  EXECUTE2: begin
			case(inst[7:3])
				// str register direct
				5'b10010: begin
						// mem[addrr] <- r; pc <- pc + 1;
						acs <= MEM_CE | MEM_W | ADDRR_R | PC_INC;
						r_rdata[inst[2:0]] <= HIGH;
						
						state <= FETCH;
				end
			endcase
		  end
		  end
    endcase
end

endmodule
