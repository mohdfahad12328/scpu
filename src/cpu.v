
`define SYNTH_VIEW
// `define __GOWIN__

module cpu(

`ifdef SYNTH_VIEW
	
	// regs cs
	output [7:0]
			regs_rdata,
			regs_wdata,
			regs_raddr,
			regs_waddr,
			regs_alu_r_a,
			regs_alu_r_b,
			regs_alu_w,

	// memory cs 
	output	mem_ce, mem_r, mem_w, mem_rst, mem_oe,

	// pc cs
	output  pc_w, pc_r, pc_rst, pc_inc,

	// alu cs
	output alu_en, output[7:0] alu_opr,

	// buses
	output [7:0]data_bus,
	output[15:0]addr_bus,
	output [7:0]alu_a_bus,
				alu_b_bus,
				alu_out_bus,

`endif

output [7:0]led,
input clk
);

/*------------------------------------------------------------------------------
--  BUSES
------------------------------------------------------------------------------*/
`ifndef SYNTH_VIEW

wire [7:0]  data_bus;
wire [15:0] addr_bus;
wire [7:0] alu_a_bus, alu_b_bus, alu_out_bus;

`endif

/*------------------------------------------------------------------------------
--  REGISTERS
------------------------------------------------------------------------------*/
`ifndef SYNTH_VIEW

wire [7:0] regs_raddr, regs_waddr, regs_rdata, regs_wdata;
wire [7:0] regs_alu_r_a, regs_alu_r_b, regs_alu_w;

`endif

register r0(
	.rdata(regs_rdata[0]),
	.wdata(regs_wdata[0]),
	.in_data(data_bus),
	.out_data(data_bus),

	.raddr(regs_raddr[0]),
	.waddr(regs_waddr[0]),
	.in_addr(addr_bus[15:8]),
	.out_addr(addr_bus[15:8]),

	.alu_r_a(regs_alu_r_a[0]),
	.alu_r_b(regs_alu_r_b[0]),
	.alu_w(regs_alu_w[0]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),

	.clk(clk)
);

register r1(
	.rdata(regs_rdata[1]),
	.wdata(regs_wdata[1]),
	.in_data(data_bus),
	.out_data(data_bus),

	.raddr(regs_raddr[1]),
	.waddr(regs_waddr[1]),
	.in_addr(addr_bus[7:0]),
	.out_addr(addr_bus[7:0]),
	
	.alu_r_a(regs_alu_r_a[1]),
	.alu_r_b(regs_alu_r_b[1]),
	.alu_w(regs_alu_w[1]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

register r2(
	.rdata(regs_rdata[2]),
	.wdata(regs_wdata[2]),
	.in_data(data_bus),
	.out_data(data_bus),

	.raddr(regs_raddr[2]),
	.waddr(regs_waddr[2]),
	.in_addr(addr_bus[15:8]),
	.out_addr(addr_bus[15:8]),
	
	.alu_r_a(regs_alu_r_a[2]),
	.alu_r_b(regs_alu_r_b[2]),
	.alu_w(regs_alu_w[2]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

register r3(
	.rdata(regs_rdata[3]),
	.wdata(regs_wdata[3]),
	.in_data(data_bus),
	.out_data(data_bus),

	.raddr(regs_raddr[3]),
	.waddr(regs_waddr[3]),
	.in_addr(addr_bus[7:0]),
	.out_addr(addr_bus[7:0]),
	
	.alu_r_a(regs_alu_r_a[3]),
	.alu_r_b(regs_alu_r_b[3]),
	.alu_w(regs_alu_w[3]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

register r4(
	.rdata(regs_rdata[4]),
	.wdata(regs_wdata[4]),
	.in_data(data_bus),
	.out_data(data_bus),
	
	.raddr(regs_raddr[4]),
	.waddr(regs_waddr[4]),
	.in_addr(addr_bus[15:8]),
	.out_addr(addr_bus[15:8]),
	
	.alu_r_a(regs_alu_r_a[4]),
	.alu_r_b(regs_alu_r_b[4]),
	.alu_w(regs_alu_w[4]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

register r5(
	.rdata(regs_rdata[5]),
	.wdata(regs_wdata[5]),
	.in_data(data_bus),
	.out_data(data_bus),
  
	.raddr(regs_raddr[5]),
	.waddr(regs_waddr[5]),
	.in_addr(addr_bus[7:0]),
	.out_addr(addr_bus[7:0]),
	
	.alu_r_a(regs_alu_r_a[5]),
	.alu_r_b(regs_alu_r_b[5]),
	.alu_w(regs_alu_w[5]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

register r6(
	.rdata(regs_rdata[6]),
	.wdata(regs_wdata[6]),
	.in_data(data_bus),
	.out_data(data_bus),

	.raddr(regs_raddr[6]),
	.waddr(regs_waddr[6]),
	.in_addr(addr_bus[15:8]),
	.out_addr(addr_bus[15:8]),
	
	.alu_r_a(regs_alu_r_a[6]),
	.alu_r_b(regs_alu_r_b[6]),
	.alu_w(regs_alu_w[6]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

register r7(
	.rdata(regs_rdata[7]),
	.wdata(regs_wdata[7]),
	.in_data(data_bus),
	.out_data(data_bus),
	
	.raddr(regs_raddr[7]),
	.waddr(regs_waddr[7]),
	.in_addr(addr_bus[7:0]),
	.out_addr(addr_bus[7:0]),
	
	.alu_r_a(regs_alu_r_a[7]),
	.alu_r_b(regs_alu_r_b[7]),
	.alu_w(regs_alu_w[7]),
	.alu_a_bus(alu_a_bus),
	.alu_b_bus(alu_b_bus),
	.alu_out_bus(alu_out_bus),
	
	.clk(clk)
);

/*------------------------------------------------------------------------------
--  MEMORY
------------------------------------------------------------------------------*/
`ifndef SYNTH_VIEW
	wire mem_ce, mem_r, mem_w, mem_rst, mem_oe;
`endif

memory mem(
	.out_data(data_bus),
	.in_data(data_bus),

	.addr(addr_bus),
	
	.ce(mem_ce),
	.w(mem_w),
	.r(mem_r),
	.oe(mem_oe),
	.rst(mem_rst),
	
	.led(led),
	
	.clk(clk)
);

/*------------------------------------------------------------------------------
--  PROGRAM COUNTER
------------------------------------------------------------------------------*/
`ifndef SYNTH_VIEW
wire pc_w, pc_r, pc_rst, pc_inc;
`endif

pc pc(
	.w(pc_w),
	.r(pc_r),
	.rst(pc_rst),
	.inc(pc_inc),
	
	.in(addr_bus),
	.out(addr_bus),

	.clk(clk)
);

/*------------------------------------------------------------------------------
--  ALU
------------------------------------------------------------------------------*/
`ifndef SYNTH_VIEW
wire alu_en;
wire [7:0]alu_opr; 
`endif

alu alu(
	.a_data_bus(alu_a_bus),
	.b_data_bus(alu_b_bus),
	.out_data_bus(alu_out_bus),
	.opr(alu_opr),
	.en(alu_en)
);

/*------------------------------------------------------------------------------
--  CONTROL UNIT
------------------------------------------------------------------------------*/
controlUint control_unit(
	.regs_rdata(regs_rdata),
	.regs_wdata(regs_wdata),
	.regs_raddr(regs_raddr),
	.regs_waddr(regs_waddr),

	.regs_alu_r_a(regs_alu_r_a),
	.regs_alu_r_b(regs_alu_r_b),
	.regs_alu_w(regs_alu_w),
	.alu_en(alu_en),
	.alu_opr(alu_opr),

	.mem_ce(mem_ce),
	.mem_rst(mem_rst),
	.mem_w(mem_w),
	.mem_r(mem_r),
	.mem_oe(mem_oe),

	.pc_w(pc_w),
	.pc_r(pc_r),
	.pc_rst(pc_rst),
	.pc_inc(pc_inc),

	.data_bus_in(data_bus),
	.data_bus_out(data_bus),
	.addr_bus_in(addr_bus),
	.addr_bus_out(addr_bus),

	.clk(clk)
);

endmodule
