module mouse_cursor(
input wire [7:0] x,
input wire [7:0] y,
input wire CLOCK_50,
input wire 
);

vga_adapter adapterVGA(
.resetn(), 
.clock(), 
.color(), 
.x(x), 
.y(y), 
.write(1),
.VGA_R(), 
.VGA_G(), 
.VGA_B(), 
.VGA_HS(), 
.VGA_VS(), 
.VGA_BLANK_N(), 
.VGA_SYNC_N(), 
.VGA_CLK()
)


endmodule