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
    output wire       VGA_CLK,
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

wire [7:0] finalx, finaly;


vga_top head_vga(
    .CLOCK_50(CLOCK_50),
    .KEY(KEY),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_SYNC_N(VGA_SYNC_N),
    .VGA_CLK(VGA_CLK)
);

ps2_top head_ps2(
.HEX0(HEX0), 
.HEX1(HEX1),
.HEX2(HEX2), 
.HEX3(HEX3), 
.HEX4(HEX4), 
.HEX5(HEX5),
.LEDR(LEDR),
.PS2_DAT(PS2_DAT), 
.PS2_CLK(PS2_CLK),
.KEY(KEY), 
.CLOCK_50(CLOCK_50)
.finX(finalx),
.finY(finaly)
);

endmodule