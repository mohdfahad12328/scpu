`timescale 1ns/1ps

module control_unit_tb ();

reg clk = 1;

always begin clk <= ~clk; #5; end

wire [7:0]
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

wire        alu_en,
            alu_direct_data_bus_en;
wire [2:0]  alu_opr;          
wire [7:0]  alu_a_bus,
			alu_b_bus,
			alu_out_bus;

wire [7:0]  data_bus;
wire [15:0] addr_bus;

wire [7:0] led;

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
			
            .alu_en(alu_en),
            .alu_direct_data_bus_en(alu_direct_data_bus_en),
            .alu_opr(alu_opr),
            .alu_a_bus(alu_a_bus),
            .alu_b_bus(alu_b_bus),
            .alu_out_bus(alu_out_bus),

			.data_bus(data_bus),
			.addr_bus(addr_bus),
			.led(led),
			.clk(clk)
);

initial begin
	#400;
	$finish;
end

endmodule : control_unit_tb