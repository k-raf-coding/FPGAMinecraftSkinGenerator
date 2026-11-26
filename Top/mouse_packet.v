module mouse_packet(
reset,
byte_en,
byte,
mid,
left,
right,
delta_x,
delta_y,
x_sign,
y_sign,
x_overflow,
y_overflow,
CLOCK_50,
packet_valid,
ready
);

input reset, byte_en, CLOCK_50, ready;
input [7:0] byte;
output reg [7:0] delta_x, delta_y; 
output reg mid, left, right, x_overflow, y_overflow;

output reg x_sign, y_sign, packet_valid;
parameter BYTE0 = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10;
reg [1:0] state;

always @(posedge CLOCK_50) begin
if (!reset) begin
delta_x <= 8'b0;
delta_y <= 8'b0;
mid <= 1'b0;
right <= 1'b0;
left <= 1'b0;
x_sign <= 1'b0;
y_sign <= 1'b0;
packet_valid <= 1'b0;
x_overflow = 1'b0;
y_overflow = 1'b0;
state <= BYTE0;
end

else if (ready) begin
case (state)
BYTE0: begin
packet_valid <= 1'b0;
if (byte_en & byte[3]) begin // byte[3] is 1 when the info is properly loaded
y_overflow <= byte[7];
x_overflow <= byte[6];
y_sign <= byte[5];
x_sign <= byte[4];
mid <= byte[2];
right <= byte[1];
left <= byte[0];
state <= BYTE1;
	end
	
else 
	state <= BYTE0;

end

BYTE1: begin
if (byte_en) begin
delta_x <= byte;
state <= BYTE2;
	end

	else
state <= BYTE1;
end

BYTE2: begin
if (byte_en) begin
delta_y <= byte;
state <= BYTE0;
packet_valid <= 1'b1;
	end 

	else
state <= BYTE2;
end
endcase

end
end
endmodule
