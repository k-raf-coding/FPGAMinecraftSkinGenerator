module top (
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
);

    wire resetn = KEY[0]; // DE1-SoC KEY buttons are active-low

    reg [9:0] x;
    reg [8:0] y;

    wire [8:0] color = 9'b111_000_000; // red (COLOR_DEPTH=9)
    wire write = resetn && (y < 9'd150); //perm law

    vga_adapter #(
        .RESOLUTION("160x120"),
        .COLOR_DEPTH(9),
        .BACKGROUND_IMAGE("./EmptyPNG_160x120_tes.mif")
    ) vga (
        .resetn(resetn),
        .clock(CLOCK_50),
        .color(color),
        .x(x),
        .y(y),
        .write(write),
        .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
        .VGA_HS(VGA_HS), .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );

endmodule