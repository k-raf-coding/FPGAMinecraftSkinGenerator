module Top(
	 input  wire       CLOCK_50,
    input  wire [3:0] KEY,
    output wire [7:0] VGA_R,
    output wire [7:0] VGA_G,
    output wire [7:0] VGA_B,
    output wire       VGA_HS,
    output wire       VGA_VS,
    output wire       VGA_BLANK_N,
    output wire       VGA_SYNC_N,
    output wire       VGA_CLK
	 output wire [6:0] HEX0, 
	 output wire [6:0] HEX1, 
	 output wire [6:0] HEX2, 
	 output wire [6:0] HEX3, 
	 output wire [6:0] HEX4, 
	 output wire [6:0] HEX5,
	 output wire [9:0] LEDR,
	 inout wire PS2_DAT, 
	 inout wire PS2_CLK
);


endmodule