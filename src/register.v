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
    // data and addr
    input rdata, wdata,
    input [7:0] in_data,
    output [7:0] out_data,
    input raddr, waddr,
    input [7:0] in_addr,
    output [7:0] out_addr,
    input inc, dec,
    // alu
    input alu_r_a, alu_r_b, alu_w,
    output [7:0] alu_a_bus, alu_b_bus,
    input [7:0] alu_out_bus,
    // clk
    input clk
    );

reg [7:0]r;

assign out_data = rdata ? r : 8'bz;
assign out_addr = raddr ? r : 8'bz;

assign alu_a_bus = alu_r_a ? r : 8'bz;
assign alu_b_bus = alu_r_b ? r : 8'bz;

always @(posedge clk) begin
    if(wdata == 1 && waddr == 0)
        r <= in_data;
    else if (wdata == 0 && waddr == 1)
        r <= in_addr;
    else if (alu_w)
        r <= alu_out_bus;
    else if (inc)
        r <= r+1;
    else if (dec)
        r <= r-1;
end

endmodule
