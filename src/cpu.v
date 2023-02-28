
`define SYNTH_VIEW

module cpu(

`ifdef SYNTH_VIEW
    
    output [7:0]regs_rdata,
                regs_wdata,
                regs_raddr,
                regs_waddr,
    
    output      mem_ce, mem_r, mem_w, mem_rst, mem_oe,

    output      pc_w, pc_r, pc_rst, pc_inc,

    output [7:0]data_bus,
    output[15:0]addr_bus,

`endif

input clk
);

// --------------------------------------------------------
// buses
// --------------------------------------------------------

`ifndef SYNTH_VIEW

wire [7:0]  data_bus;
wire [15:0] addr_bus;

`endif

// --------------------------------------------------------
// registers
// --------------------------------------------------------

    `ifndef SYNTH_VIEW

    wire [7:0] regs_raddr, regs_waddr, regs_rdata, regs_wdata;

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

    .clk(clk)
    );

// --------------------------------------------------------
// control unit
// --------------------------------------------------------

controlUint control_unit(
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

    .data_bus_in(data_bus),
    .data_bus_out(data_bus),
    // .addr_bus_in(addr_bus),
    // .addr_bus_out(addr_bus),

    .clk(clk)
);

// --------------------------------------------------------
// memory
// --------------------------------------------------------

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
    
    .clk(clk)
);

// --------------------------------------------------------
// PC
// --------------------------------------------------------
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

endmodule
