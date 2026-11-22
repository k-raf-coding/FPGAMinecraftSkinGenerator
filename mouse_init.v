module mouse_init(
cmd_timeout,
clk,
reset,
command_sent,
mouse_response,
ready_to_read,
mouse_response_en,
send_command
);

input cmd_timeout, clk, reset, command_sent, mouse_response_en;
input [7:0] mouse_response;
output reg send_command, ready_to_read;

parameter SEND = 2'b00, RETRY = 2'b10, WAIT_ACK = 2'b01, READY = 2'b11;
reg [1:0] state;

always @(posedge clk) begin
if (!reset) begin
state <= SEND;
ready_to_read <= 1'b0;
send_command <= 1'b0;
end

else 
case (state) 

SEND: begin
send_command <= 1'b1;

if (command_sent)
state <= WAIT_ACK;

else if (cmd_timeout)
state <= RETRY;
		end

RETRY: begin
send_command <= 1'b0;
state <= SEND;
		end

WAIT_ACK: begin
send_command <= 1'b0;
if (mouse_response_en && mouse_response == 8'hFA)
state <= READY;

else 
state <= WAIT_ACK;
		end

READY: begin
ready_to_read <= 1'b1;
send_command <= 1'b0;
state <= READY;
		end
	endcase
end
endmodule