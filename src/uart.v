// /*
// module uart(

// );
// endmodule

// module receiver(

// );
// endmodule
// */

module emitter 
#(
	parameter DELAY_FRAMES = 234 // 27Mhz / 115200 BaudRate
)
(
	output tx,
	input[7:0] dataIn,
	input write,
	input clk,
	output ack
);

reg [3:0] state = 0;
reg [24:0] counter = 0;
reg [3:0]  bitCounter = 0;
reg [7:0] dataOut = 0;

reg txReg = 1;
assign tx = txReg;

reg ackReg = 0;
assign ack = ackReg;

localparam 	IDLE = 0,
			START_BIT = 1,
			SEND_BYTE = 2,
			END_BIT   = 3;

always @(posedge clk) begin
case(state)

IDLE: begin
	if(write) begin
		state <= START_BIT;
		counter <= 0;
		bitCounter <= 0;
		dataOut <= dataIn;
		ackReg <= 0;
	end
	else begin
		txReg <= 1;
	end
end

START_BIT: begin
	txReg <= 0;
	if ((counter + 1) == DELAY_FRAMES) begin
		state <= SEND_BYTE;
		counter <= 0;
	end
	else begin
		counter <= counter + 1;
	end
end

SEND_BYTE: begin
	if((counter + 1) == DELAY_FRAMES) begin
		if(bitCounter == 7) begin
			state <= END_BIT;
			bitCounter <= 0;
		end
		else begin
			txReg <= dataOut[7 - bitCounter];
			bitCounter <= bitCounter + 1;
		end
		counter <= 0;
	end
	else begin
		counter <= counter + 1;
	end
end

END_BIT: begin
	if((counter + 1) == DELAY_FRAMES) begin
		state <= IDLE;
		counter <= 0;
		ackReg <= 1;
	end
	else begin
		counter <= counter + 1;
		txReg <= 1;
	end
end

endcase
end

endmodule
