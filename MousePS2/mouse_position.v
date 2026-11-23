module mouse_position(
xsign,
ysign,
xoverflow,
yoverflow,
delx,
dely,
packet_valid,
x,
y,
CLOCK_50,
reset
);

input xsign, ysign, xoverflow, yoverflow, packet_valid, CLOCK_50, reset;
input [7:0] delx, dely;

wire [9:0] comp_x, comp_y, x_sum, y_sum;
reg [9:0] lim_x, lim_y, x_wrap, y_wrap;

output reg [7:0] x, y;

assign comp_x = {xsign, xsign, delx}; // setting to twos complement, sign extension since we may have up to -512 to 511
assign comp_y = {ysign, ysign, dely};

always @(*) begin
if (!comp_x[9] & comp_x > 10'd159) // Limit to 159
lim_x <= 10'd159;
else if(comp_x[9] & comp_x < 10'd865) // 865 = -159, Limit to -159, anything lower than 865 starts increasing in negatives due to 2s complements
lim_x <= 10'd865;
else 
lim_x <= comp_x;

if (!comp_y[9] & comp_y > 10'd119) // Same ideas as x
lim_y <= 10'd119;
else if(comp_y[9] & comp_y < 10'd905) // 905 = -119
lim_y <= 10'd905;
else 
lim_y <= comp_y; 

end

assign x_sum = {2'b00,  x} + lim_x;
assign y_sum = {3'b000, y} - lim_y; // subtract as vga takes y decreasing as going up

always @(*) begin
    if (x_sum[9])              x_wrap = x_sum + 10'd160;   // off the left (check signed bit)
    else if (x_sum >= 10'd160) x_wrap = x_sum - 10'd160;   // off the right (check resolution boundary)
    else                       x_wrap = x_sum;
	 
	 if (y_sum[9])              y_wrap = y_sum + 10'd120;   // off the left (same as x), REMEMBER: y going up is negative
    else if (y_sum >= 10'd120) y_wrap = y_sum - 10'd120;   // off the right
    else                       y_wrap = y_sum;
end

always @(posedge CLOCK_50) begin
    if (!reset) begin
        x <= 8'd80;
        y <= 7'd60;
    end
    else if (packet_valid) begin
        if (xoverflow) x <= xsign ? 8'd0   : 8'd159; // either shoot left or right
        else           x <= x_wrap[7:0];

        if (yoverflow) y <= ysign ? 7'd119 : 7'd0; // either shoot down or up
        else           y <= y_wrap[6:0];
    end
end
endmodule