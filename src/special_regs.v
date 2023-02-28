module pc (
    input w, r, rst, inc, clk,
    input [15:0] in,
    output [15:0] out
);

reg [15:0] pc_reg;
assign out = r ? pc_reg : 16'bz;

always @(posedge clk) begin
    if(rst)
        pc_reg <= 0;
    else if (w)
        pc_reg <= in;
    else if (inc)
        pc_reg <= pc_reg + 1;
end
endmodule
