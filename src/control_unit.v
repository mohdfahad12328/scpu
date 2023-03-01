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
    // input [15:0]  addr_bus_in,
    // output [15:0] addr_bus_out,
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


// memory interface

// reg [4:0] mem_c = 0;
// localparam  MEM_CE = 16,
// MEM_OE = 8,
// MEM_R = 4,
// MEM_RST = 2,
// MEM_W = 1;

// assign {mem_ce, mem_oe, mem_r, mem_rst, mem_w} = mem_c;


// program counter

// reg [3:0]pc_c = 0;
// localparam  PC_INC = 8,
// PC_R = 4,
// PC_RST = 2,
// PC_W = 1;

// assign {pc_inc, pc_r, pc_rst, pc_w} = pc_c;


// inst register

reg [7:0] inst;
wire inst_r, inst_w;

// reg [1:0] inst_c = 0;
// localparam  INST_R = 2,
// INST_W = 1;

// assign {inst_r, inst_w} = inst_c;

assign data_bus_out = inst_r ? inst : 8'bz;
always @(posedge clk)
    if (inst_w)
        inst <= data_bus_in;


// all control signals
/* 
	ncs --> no of control signals
 	acs --> all control signals
*/
localparam ncs = 5 + 4 + 2; // mem,pc,inst
reg [ncs-1:0] acs = 0;
assign {	mem_ce, mem_oe, mem_r, mem_rst, mem_w,
					pc_inc, pc_r, pc_rst, pc_w,
					inst_r, inst_w
	} = acs;

localparam INST_W = 2**0,
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

// execution state machine

reg [2:0]state      = 0;
localparam FETCH    = 0;
localparam DECODE   = 1;
localparam EXECUTE0 = 2;
localparam EXECUTE1 = 3;

always @(negedge clk) begin
    case(state)
        FETCH: begin
            // mem[pc]
            acs <= MEM_CE | MEM_R | PC_R;
            
            state <= DECODE;
        end
        DECODE: begin
            // isnt <- mem[pc]
            // pc <- pc + 1
            acs  <= MEM_CE | MEM_OE | INST_W | PC_INC;
            
            state <= EXECUTE0;
        end
        
        EXECUTE0: begin
            
            case(inst[7:3])
                // ldr immediate
                0: begin
                    // mem[pc]
            				acs <= MEM_CE | MEM_R | PC_R;

                    state <= EXECUTE1;
                end
                
                1: begin
                    
                end
                
            endcase
        end
        
        EXECUTE1: begin
            
            case(inst[7:3])
                // ldr immediate
                0: begin
                    // reg <- mem[pc]
                    // pc <- pc + 1
                    acs <= MEM_CE | MEM_OE | PC_INC;
                    r_wdata[inst[2:0]] <= HIGH;
                    
                    state <= FETCH;
                end
            endcase

        end

    endcase
end

endmodule
