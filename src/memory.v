// MEMORY MODULE

module memory(output [7:0] out_data,
              input [7:0] in_data,
              input [15:0] addr,
              input wire clk,
              ce,
              w,
              r,
              rst,
              oe);

reg [7:0] mem [1024:0];
reg [7:0] data_reg;

assign out_data = (ce & oe) ? data_reg : 8'bz;

always @(posedge clk) begin
    if (rst)
        data_reg <= 0;
    else
        if (ce & r)
            data_reg <= mem[addr];
        else if (ce & w)
            mem[addr] <= in_data;
    
end
endmodule
