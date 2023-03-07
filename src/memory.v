/*------------------------------------------------------------------------------
--  MEMORY MODULE
------------------------------------------------------------------------------*/

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

localparam RAM_SIZE = 2**15;

wire ram_ce = (ce && (addr < RAM_SIZE)) ? 1 : 0;
wire io_ce = (ce && (addr >= RAM_SIZE)) ? 1 : 0;

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

ram_memory ram_mem(
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
defparam ram_mem.RAM_SIZE = RAM_SIZE;

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
reg [7:0] data_reg;

assign out_data = (ce & oe) ? data_reg : 8'bz;

assign led = {mem[0][7:6], ~mem[0][5:0]};

always @(posedge clk) begin
    if (rst)
        data_reg <= 0;
    else if(ce & w)
        mem[addr] <= in_data;
    else if(ce & r)
        data_reg <= mem[addr];
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

parameter RAM_SIZE = 2**11;
reg [7:0] mem[RAM_SIZE-1:0];
reg [7:0] data_reg;

assign out_data = (ce & oe) ? data_reg : 8'bz;

initial
$readmemb("/home/luffy/gowin-projects/scpu-fpga/src/data.txt",mem, 0);

always @(posedge clk) begin
    if (rst)
        data_reg <= 0;
    else if(ce & w)
        mem[addr] <= in_data;
    else if(ce & r)
        data_reg <= mem[addr];
end

endmodule