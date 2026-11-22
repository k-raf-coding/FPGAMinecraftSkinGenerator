module ps2_top(
HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
LEDR,
PS2_DAT, PS2_CLK,
KEY, CLOCK_50
);

inout PS2_DAT, PS2_CLK;
input [0:0] KEY;
input CLOCK_50;
output reg [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
output [9:0] LEDR;

assign LEDR [8:3] = 6'b0;

wire FPGA_to_send_command, command_timeout_err, FPGA_sent_command, FPGA_received_byte;
wire [7:0] FPGA_byte, FPGA_command_output; // Receiving the byte from the mouse movements and interactables (mouse btns, movement, etc)
wire ready;

wire xsign, ysign, xoverflow, yoverflow, left, right, mid, packet_valid;
wire [7:0] delx, dely;
assign FPGA_command_output = 8'hF4;

wire [7:0] netx, nety;
altera_up_ps2 ps2_controller(
.clk(CLOCK_50),
.reset(~KEY[0]),
.the_command(FPGA_command_output),
.send_command(FPGA_to_send_command),
.PS2_CLK(PS2_CLK),
.PS2_DAT(PS2_DAT),
.error_communication_timed_out(command_timeout_err),
.command_was_sent(FPGA_sent_command),
.received_data(FPGA_byte),
.received_data_en(FPGA_received_byte)
);

mouse_init rstFSM(
.cmd_timeout(command_timeout_err),
.clk(CLOCK_50),
.reset(KEY[0]),
.command_sent(FPGA_sent_command),
.mouse_response(FPGA_byte),
.ready_to_read(ready),
.mouse_response_en(FPGA_received_byte),
.send_command(FPGA_to_send_command)
);

mouse_packet packets(
.reset(KEY[0]),
.byte_en(FPGA_received_byte),
.byte(FPGA_byte),
.mid(mid),
.left(left),
.right(right),
.delta_x(delx),
.delta_y(dely),
.x_sign(xsign),
.y_sign(ysign),
.x_overflow(xoverflow),
.y_overflow(yoverflow),
.CLOCK_50(CLOCK_50),
.ready(ready),
.packet_valid(packet_valid)
);

mouse_position(
.xsign(xsign),
.ysign(ysign),
.xoverflow(xoverflow),
.yoverflow(yoverflow),
.delx(delx),
.dely(dely),
.packet_valid(packet_valid),
.x(netx),
.y(nety),
.CLOCK_50(CLOCK_50),
.reset(KEY[0])
);

always @(*) begin
	case (netx[7:4])
		4'h0: HEX5 = 7'b1000000;
		4'h1: HEX5 = 7'b1111001;
		4'h2: HEX5 = 7'b0100100;
		4'h3: HEX5 = 7'b0110000;
		4'h4: HEX5 = 7'b0011001;
		4'h5: HEX5 = 7'b0010010;
		4'h6: HEX5 = 7'b0000010;
		4'h7: HEX5 = 7'b1111000;
		4'h8: HEX5 = 7'b0000000;
		4'h9: HEX5 = 7'b0010000;
		4'hA: HEX5 = 7'b0001000;
		4'hB: HEX5 = 7'b0000011;
		4'hC: HEX5 = 7'b1000110;
		4'hD: HEX5 = 7'b0100001;
		4'hE: HEX5 = 7'b0000110;
		4'hF: HEX5 = 7'b0001110;
		default: HEX5 = 7'b1111111;
	endcase
end

// HEX4: cursor x, lower digit
always @(*) begin
	case (netx[3:0])
		4'h0: HEX4 = 7'b1000000;
		4'h1: HEX4 = 7'b1111001;
		4'h2: HEX4 = 7'b0100100;
		4'h3: HEX4 = 7'b0110000;
		4'h4: HEX4 = 7'b0011001;
		4'h5: HEX4 = 7'b0010010;
		4'h6: HEX4 = 7'b0000010;
		4'h7: HEX4 = 7'b1111000;
		4'h8: HEX4 = 7'b0000000;
		4'h9: HEX4 = 7'b0010000;
		4'hA: HEX4 = 7'b0001000;
		4'hB: HEX4 = 7'b0000011;
		4'hC: HEX4 = 7'b1000110;
		4'hD: HEX4 = 7'b0100001;
		4'hE: HEX4 = 7'b0000110;
		4'hF: HEX4 = 7'b0001110;
		default: HEX4 = 7'b1111111;
	endcase
end

// HEX3: cursor y, upper digit
always @(*) begin
	case (nety[7:4])
		4'h0: HEX3 = 7'b1000000;
		4'h1: HEX3 = 7'b1111001;
		4'h2: HEX3 = 7'b0100100;
		4'h3: HEX3 = 7'b0110000;
		4'h4: HEX3 = 7'b0011001;
		4'h5: HEX3 = 7'b0010010;
		4'h6: HEX3 = 7'b0000010;
		4'h7: HEX3 = 7'b1111000;
		4'h8: HEX3 = 7'b0000000;
		4'h9: HEX3 = 7'b0010000;
		4'hA: HEX3 = 7'b0001000;
		4'hB: HEX3 = 7'b0000011;
		4'hC: HEX3 = 7'b1000110;
		4'hD: HEX3 = 7'b0100001;
		4'hE: HEX3 = 7'b0000110;
		4'hF: HEX3 = 7'b0001110;
		default: HEX3 = 7'b1111111;
	endcase
end

// HEX2: cursor y, lower digit
always @(*) begin
	case (nety[3:0])
		4'h0: HEX2 = 7'b1000000;
		4'h1: HEX2 = 7'b1111001;
		4'h2: HEX2 = 7'b0100100;
		4'h3: HEX2 = 7'b0110000;
		4'h4: HEX2 = 7'b0011001;
		4'h5: HEX2 = 7'b0010010;
		4'h6: HEX2 = 7'b0000010;
		4'h7: HEX2 = 7'b1111000;
		4'h8: HEX2 = 7'b0000000;
		4'h9: HEX2 = 7'b0010000;
		4'hA: HEX2 = 7'b0001000;
		4'hB: HEX2 = 7'b0000011;
		4'hC: HEX2 = 7'b1000110;
		4'hD: HEX2 = 7'b0100001;
		4'hE: HEX2 = 7'b0000110;
		4'hF: HEX2 = 7'b0001110;
		default: HEX2 = 7'b1111111;
	endcase
end

// HEX1: last byte from mouse, upper digit
always @(*) begin
	case (FPGA_byte[7:4])
		4'h0: HEX1 = 7'b1000000;
		4'h1: HEX1 = 7'b1111001;
		4'h2: HEX1 = 7'b0100100;
		4'h3: HEX1 = 7'b0110000;
		4'h4: HEX1 = 7'b0011001;
		4'h5: HEX1 = 7'b0010010;
		4'h6: HEX1 = 7'b0000010;
		4'h7: HEX1 = 7'b1111000;
		4'h8: HEX1 = 7'b0000000;
		4'h9: HEX1 = 7'b0010000;
		4'hA: HEX1 = 7'b0001000;
		4'hB: HEX1 = 7'b0000011;
		4'hC: HEX1 = 7'b1000110;
		4'hD: HEX1 = 7'b0100001;
		4'hE: HEX1 = 7'b0000110;
		4'hF: HEX1 = 7'b0001110;
		default: HEX1 = 7'b1111111;
	endcase
end

// HEX0: last byte from mouse, lower digit
always @(*) begin
	case (FPGA_byte[3:0])
		4'h0: HEX0 = 7'b1000000;
		4'h1: HEX0 = 7'b1111001;
		4'h2: HEX0 = 7'b0100100;
		4'h3: HEX0 = 7'b0110000;
		4'h4: HEX0 = 7'b0011001;
		4'h5: HEX0 = 7'b0010010;
		4'h6: HEX0 = 7'b0000010;
		4'h7: HEX0 = 7'b1111000;
		4'h8: HEX0 = 7'b0000000;
		4'h9: HEX0 = 7'b0010000;
		4'hA: HEX0 = 7'b0001000;
		4'hB: HEX0 = 7'b0000011;
		4'hC: HEX0 = 7'b1000110;
		4'hD: HEX0 = 7'b0100001;
		4'hE: HEX0 = 7'b0000110;
		4'hF: HEX0 = 7'b0001110;
		default: HEX0 = 7'b1111111;
	endcase
end

assign LEDR[9] = ready;
assign LEDR[2] = mid;
assign LEDR[1] = right;
assign LEDR[0] = left;
endmodule