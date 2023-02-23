module controlUint (
    output reg [7:0]regs_rdata,
                    regs_wdata,
                    regs_raddr,
                    regs_waddr,

    output reg  mem_ce,
                mem_rst,
                mem_wre,
    input [7:0] mem_data_in,

    output reg  pc_w,
                pc_r,
                pc_rst,
                pc_inc,

    input clk
);

localparam FETCH = 0;
localparam DECODE = 1;
localparam EXECUTE0 = 2;
localparam EXECUTE1 = 3;

reg [2:0]state = 0; 

reg [7:0] inst;

/* 
TODO: use and manage mem_data by dbus
    : (not by taking seperate signal from mem and update arch)
*/

// TODO: TO AYMEN: UPDATE THE CPU ACCORDINGLY ASAP

always @(negedge clk) begin
    case(state)
        FETCH: begin
            // pc on abus, mem read from abus
            pc_r <= 1;
            mem_ce <= 1;
            mem_wre <= 0;
            state <= DECODE;
        end
        DECODE: begin
            // get that mem_data into control unit for decoding
            inst <= mem_data_in;
            // inc pc
            pc_inc <= 1;
            state <= EXECUTE0;
        end
        EXECUTE0: begin
        case(inst[7:3])
            0: begin // ldr immediate
                // fetch next byte immediate data
                pc_r <= 1;
                mem_wre <= 0;
                state <= EXECUTE1;
            end
        endcase
        end
        EXECUTE1: begin
            case(inst[7:3])
            0: begin // ldr immediate
                // reg write from dbus, mem_data to dbus
                regs_wdata[inst[2:0]] <= 1;
                mem_wre <= 1;
                // inc pc cause second byte fetched
                pc_inc <= 1;
                state <= FETCH;
            end
        endcase
        end
    endcase
end
endmodule