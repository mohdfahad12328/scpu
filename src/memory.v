/*
memory mem(
    .out_data(),
    .in_data(),
    .addr(),
    .clk(),
    .ce(),
    .wre(),
    .rst()
);
*/

module memory(
output     [7:0] out_data,
input      [7:0] in_data,
input     [15:0] addr,
input wire clk, ce, wre, rst
);

reg [7:0] mem [1024:0];
reg [7:0] out_data_reg;

assign out_data = ce ? out_data_reg : 8'bz;

always @(posedge clk)
if (rst)
    out_data_reg <= 0;
else 
    if (ce & !wre)
        out_data_reg <= mem[addr];
    else if (ce & wre)
        mem[addr] <= in_data;
        
endmodule
