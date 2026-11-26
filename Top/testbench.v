`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 20;

	reg CLOCK_50;
	reg reset, ready, data_en;
	reg [7:0] data;

	wire [7:0] delta_x, delta_y, x, y;
	wire x_sign, y_sign, x_ovf, y_ovf, left, right, mid, packet_valid;

	initial begin
		CLOCK_50 <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end

	// Testing for multiple edge cases in my code (mainly for overflowing, wrapping around 160x120 resolution, and just handling basic mouse movement w/ 2's complements)
	initial begin
		reset <= 1'b0; ready <= 1'b0; data_en <= 1'b0; data <= 8'h00;   // reset (active-low)
		#40 reset <= 1'b1;                                                // done reset: x = 80, y = 60

		#20 data <= 8'hFA; data_en <= 1'b1;   // FA while ready = 0: ignored, x stays 80
		#20 data_en <= 1'b0;
		#20 ready <= 1'b1;                    // init finished

		// Packet 1: right 5            -> x = 85
		#20 data <= 8'h08; data_en <= 1'b1;   // byte 0: no signs
		#20 data_en <= 1'b0;
		#20 data <= 8'h05; data_en <= 1'b1;   // byte 1: dx = +5
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;   // byte 2: dy = 0
		#20 data_en <= 1'b0;

		// Packet 2: left 10            -> x = 75
		#20 data <= 8'h18; data_en <= 1'b1;   // byte 0: x sign = 1
		#20 data_en <= 1'b0;
		#20 data <= 8'hF6; data_en <= 1'b1;   // byte 1: F6 = -10
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;

		// Packet 3: left 80, wraps     -> x = 155   (75 - 80 = -5, + 160)
		#20 data <= 8'h18; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'hB0; data_en <= 1'b1;   // byte 1: B0 = -80
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;

		// Packet 4: right 10, wraps    -> x = 5     (155 + 10 = 165, - 160)
		#20 data <= 8'h08; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'h0A; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;

		// Packet 5: up 5               -> y = 55
		#20 data <= 8'h08; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'h05; data_en <= 1'b1;   // byte 2: dy = +5 (up)
		#20 data_en <= 1'b0;

		// Packet 6: left click         -> left = 1, x and y unchanged
		#20 data <= 8'h09; data_en <= 1'b1;   // byte 0: bit 0 = left button
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;

		// Packet 7: x overflow right   -> x = 159
		#20 data <= 8'h48; data_en <= 1'b1;   // byte 0: bit 6 = x overflow
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;
		#20 data <= 8'h00; data_en <= 1'b1;
		#20 data_en <= 1'b0;

	end // initial

	mouse_packet U1 (
		.CLOCK_50(CLOCK_50), 
		.reset(reset), 
		.ready(ready),
		.byte(data), 
		.byte_en(data_en),
		.delta_x(delta_x), 
		.delta_y(delta_y),
		.x_sign(x_sign), 
		.y_sign(y_sign),
		.x_overflow(x_ovf), 
		.y_overflow(y_ovf),
		.left(left), 
		.right(right), 
		.mid(mid),
		.packet_valid(packet_valid)
	);

	mouse_position U2 (
		.CLOCK_50(CLOCK_50), 
		.reset(reset),
		.packet_valid(packet_valid),
		.delx(delta_x), 
		.dely(delta_y),
		.xsign(x_sign), 
		.ysign(y_sign),
		.xoverflow(x_ovf), 
		.yoverflow(y_ovf),
		.x(x), .y(y)
	);

endmodule