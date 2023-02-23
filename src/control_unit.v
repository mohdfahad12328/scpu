module controlUint (
    output reg [7:0]regs_rdata,
                    regs_wdata,
                    regs_raddr,
                    regs_waddr,
    
    output reg  mem_ce,
                mem_rst,
                mem_wre,

    input clk
)/*synthesis syn_black_box*/;

always @(negedge clk) begin
    
end


endmodule