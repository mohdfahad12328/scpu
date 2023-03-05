/*------------------------------------------------------------------------------
--  MEMORY MODULE
------------------------------------------------------------------------------*/
`define __GOWIN__
// `define SYNTH_VIEW

module memory(
    output [7:0] out_data,
    input [7:0] in_data,
    input [15:0] addr,
    input clk,
    ce,
    w,
    r,
    rst,
    oe,
    output [7:0]led
);

`ifdef __GOWIN__
localparam RAM_SIZE = 2**11;
`endif

`ifdef SYNTH_VIEW
localparam RAM_SIZE = 2**11;
`endif

wire ram_or_io_n;

assign ram_ce = (ce && (addr < RAM_SIZE)) ? 1 : 0;
assign io_ce = (ce && (addr >= RAM_SIZE)) ? 1 : 0;

io_memory io_mem (
    .out_data(out_data),
    .in_data(in_data),
    .addr({1'b0,addr[14:0]}),
    .ce(io_ce),
    .oe(oe),
    .w(w),
    .r(r),
    .rst(rst),
    .led(led),
    .clk(clk)
);

ram_memory ram_mem (
    .out_data(out_data),
    .in_data(in_data),
    .addr(addr),
    .ce(ram_ce),
    .oe(oe),
    .w(w),
    .r(r),
    .rst(rst),
    .clk(clk)
);

endmodule

/*------------------------------------------------------------------------------
--  IO MEMORY MODULE
------------------------------------------------------------------------------*/

module io_memory(
    output [7:0] out_data,
    input [7:0] in_data,
    input [15:0] addr,
    input clk,
    ce,
    w,
    r,
    rst,
    oe,
    output [7:0]led
);

localparam IO_SIZE = 4; 

reg [7:0] mem [IO_SIZE-1:0];

assign out_data = (ce & oe & r) ? mem[addr] : 8'bz;

assign led = mem[0];

always @(posedge clk) begin
    if (ce & rst)
        mem[addr] <= 0;
    else if(ce & w)
        mem[addr] <= in_data;
end

endmodule

/*------------------------------------------------------------------------------
--  RAM MEMORY MODULE
------------------------------------------------------------------------------*/

module ram_memory (
    output [7:0] out_data,
    input [7:0] in_data,
    input [15:0] addr,
    input clk,
    ce,
    w,
    r,
    rst,
    oe
);


`ifdef __GOWIN__

// wire [7:0] out_data_t;
// assign out_data = (ce & r & oe) ? out_data_t : 8'bz;

// wire wre;
// assign wre = w ? 1 : (r ? 0 : 1);

// Gowin_SP ram(
//     .dout(out_data_t),
//     .clk(clk),
//     .ce(ce),
//     .reset(rst),
//     .wre(wre),
//     .ad(addr[10:0]),
//     .din(in_data),
//     .oce(1'b1)
// );

// Gowin_RAM16S ram(
//     .dout(out_data_t), //output [7:0] dout
//     .wre(wre), //input wre
//     .ad(addr[10:0]), //input [10:0] ad
//     .di(in_data), //input [7:0] di
//     .clk(clk) //input clk
// );

localparam RAM_SIZE = 2**11;
reg [7:0] mem[RAM_SIZE-1:0];

assign out_data = (ce & r & oe) ? mem[addr] : 8'bz;

initial
    $readmemb("/home/luffy/gowin-projects/scpu-fpga/src/data.txt",mem, 0, 5);

always @(posedge clk) begin
    if (ce & rst)
        mem[addr] <= 0;
    else if(ce & w)
        mem[addr] <= in_data;
end

`endif


`ifdef SYNTH_VIEW

localparam RAM_SIZE = 2**11;
reg [7:0] mem[RAM_SIZE-1:0];

assign out_data = (ce & r & oe) ? mem[addr] : 8'bz;

initial
    $readmemb("/home/luffy/gowin-projects/scpu-fpga/src/data.txt",mem, 0, 5);

always @(posedge clk) begin
    if (ce & rst)
        mem[addr] <= 0;
    else if(ce & w)
        mem[addr] <= in_data;
end

`endif

endmodule