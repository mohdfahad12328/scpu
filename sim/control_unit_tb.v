`timescale 1ns/1ps

module control_unit_tb ();

reg clk = 0;


always begin clk <= ~clk; #5; end

initial begin
	
end


endmodule : control_unit_tb