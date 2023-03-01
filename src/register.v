/*
register r0(
    .rdata(),
    .wdata(),
    .in_data(),
    .out_data(),

    .raddr(),
    .waddr(),
    .in_addr(),
    .out_addr(),

    .clk()
);
*/

module register(
    input clk ,rdata, wdata,
    input [7:0] in_data,
    output [7:0] out_data,
    input raddr, waddr,
    input [7:0] in_addr,
    output [7:0] out_addr
    );

assign out_data = rdata ? rr : 8'bz;
assign out_addr = raddr ? rr : 8'bz;

reg [7:0]rr;

always @(posedge clk) begin
    if(wdata == 1 && waddr == 0)
        rr <= in_data;
    else if (wdata == 0 && waddr == 1)
        rr <= in_addr;
end
endmodule
