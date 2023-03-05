// MEMORY MODULE

module memory(output [7:0] out_data,
              input [7:0] in_data,
              input [15:0] addr,
              input wire clk,
              ce,
              w,
              r,
              rst,
              oe,
              output [7:0]led
            );

reg [7:0] mem [256 - 1:0];

assign out_data = (ce & r & oe) ? mem[addr] : 8'bz;
assign led = mem[255];

initial begin
    $readmemb("/home/luffy/gowin-projects/scpu-fpga/src/data.txt", mem);
end

// wire out_data_wire;
// assign out_data = (r & oe) ? out_data_wire : 8'bz;

always @(posedge clk) begin
    if (ce & rst)
        mem[addr] <= 0;
    else if (ce & w)
        mem[addr] <= in_data;
end
endmodule
