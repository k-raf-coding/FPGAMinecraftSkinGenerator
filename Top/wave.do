onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Inputs (pretend controller)}
add wave -noupdate -label CLOCK_50 /testbench/CLOCK_50
add wave -noupdate -label reset /testbench/reset
add wave -noupdate -label ready /testbench/ready
add wave -noupdate -label data -radix hexadecimal /testbench/data
add wave -noupdate -label data_en /testbench/data_en
add wave -noupdate -divider {mouse_packet}
add wave -noupdate -label state -radix unsigned /testbench/U1/state
add wave -noupdate -label packet_valid /testbench/packet_valid
add wave -noupdate -label delta_x -radix hexadecimal /testbench/delta_x
add wave -noupdate -label delta_y -radix hexadecimal /testbench/delta_y
add wave -noupdate -label x_sign /testbench/x_sign
add wave -noupdate -label y_sign /testbench/y_sign
add wave -noupdate -label x_ovf /testbench/x_ovf
add wave -noupdate -label y_ovf /testbench/y_ovf
add wave -noupdate -label left /testbench/left
add wave -noupdate -label right /testbench/right
add wave -noupdate -label mid /testbench/mid
add wave -noupdate -divider {mouse_position}
add wave -noupdate -label lim_x -radix decimal /testbench/U2/lim_x
add wave -noupdate -label x_sum -radix decimal /testbench/U2/x_sum
add wave -noupdate -label x_wrap -radix unsigned /testbench/U2/x_wrap
add wave -noupdate -label x -radix unsigned /testbench/x
add wave -noupdate -label y -radix unsigned /testbench/y
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 120
configure wave -valuecolwidth 60
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1100 ns}
