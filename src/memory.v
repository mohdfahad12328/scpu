// MEMORY MODULE

module memory(output reg [7:0] out_data,
              input [7:0] in_data,
              input [15:0] addr,
              input wire clk,
              ce,
              w,
              r,
              rst,
              oe
            );

reg [7:0] mem [1024:0];
reg [7:0] data_reg;

 always @(oe)
     if(!oe)
         out_data <= 8'bz;

//assign out_data = r ? mem[addr] : 8'bz;

always @(posedge clk) begin
    if (rst)
        data_reg <= 0;
    else if (ce & w)
        mem[addr] <= in_data;
    else if(ce & r)
        out_data <= mem[addr];
    else 
        out_data <= 8'bz;
end
endmodule