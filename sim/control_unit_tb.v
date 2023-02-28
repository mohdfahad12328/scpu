`timescale 1ns/1ps

module control_unit_tb ();

reg clk = 0;

always begin clk <= ~clk; #5; end

wire reg [7:0]
            regs_rdata,
            regs_wdata,
            regs_raddr,
            regs_waddr;
wire   		mem_ce,
            mem_rst,
            mem_w,
            mem_r,
            mem_oe;
wire   		pc_w,
            pc_r,
            pc_rst,
            pc_inc;
wire [7:0]  data_bus;
wire [15:0] addr_bus;


cpu uut (
            .regs_rdata(regs_rdata),
            .regs_wdata(regs_wdata),
            .regs_raddr(regs_raddr),
            .regs_waddr(regs_waddr),
				.mem_ce(mem_ce),
            .mem_rst(mem_rst),
            .mem_w(mem_w),
            .mem_r(mem_r),
            .mem_oe(mem_oe),
				.pc_w(pc_w),
            .pc_r(pc_r),
            .pc_rst(pc_rst),
            .pc_inc(pc_inc),
				.data_bus(data_bus),
				.addr_bus(addr_bus),
				.clk(clk)
);

initial begin
	uut.mem.mem[0] = 8'b0;
	uut.mem.mem[1] = 8'b0;
	#100;
	$finish;
end

endmodule : control_unit_tb