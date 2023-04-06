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
    output [7:0]led,
    output tx
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
    .tx(tx),
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

    output tx,
    output [7:0]led
);

localparam IO_SIZE = 4; 

reg [7:0] led_mem [0:0];
reg [7:0] uart_mem[1:0];
reg [7:0] data_reg;

assign out_data = (ce & oe) ? data_reg : 8'bz;

/*
INTERFACES
0   : led
1.0 : uart-send-signal
1.1 : uart-send-ack
2   : uart-send-data  
*/

assign led = led_mem[0];
localparam LED_MEM = 0;
localparam  UART_MEM_START = 1,
            UART_MEM_END = 2;

wire em_ack;

emitter em(
    .tx(tx),
    .dataIn(uart_mem[1]),
    .clk(clk),
    .write(uart_mem[0][0]),
    .ack(em_ack)
);

always @(posedge clk) begin
    if (rst) begin
        data_reg <= 0;
    end
    else if(ce & w) begin
        if(addr == LED_MEM)
            led_mem[addr - LED_MEM] <= in_data;
        else if (addr >= UART_MEM_START && addr <= UART_MEM_END)
            uart_mem[addr - UART_MEM_START] <= in_data;
    end
    else if(ce & r) begin
        if(addr == LED_MEM)
            data_reg <= led_mem[addr - LED_MEM];
        else if (addr >= UART_MEM_START && addr <= UART_MEM_END)
            data_reg <= uart_mem[addr - UART_MEM_START];
    end
    else begin
       if(em_ack) begin
            uart_mem[0][1] <= 1;
       end
    end
end

// TODO: here priority is given to program rather than io, is it fine?

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

parameter RAM_SIZE = 2**15;
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
