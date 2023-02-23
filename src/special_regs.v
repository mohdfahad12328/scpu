module pc (
    input w, r, rst, inc, clk,
    input [15:0] in,
    output [15:0] out
);

reg [15:0] regsiter;
assign out = r ? register : 16'bz;

always @(posedge clk) begin
    if(rst)
        register <= 0;
    else if (w)
        register <= in;
    else if (inc)
        register <= register + 1;
end
endmodule
