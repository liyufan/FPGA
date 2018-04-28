`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    22:24:30 04/24/2018
// Design Name:
// Module Name:    lab
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module seg7ment_sub(
input [1:0] num,
output reg [6:0] a_to_g);

always @(*)
case(num)
0: a_to_g=7'b0000001;
1: a_to_g=7'b1001111;
2: a_to_g=7'b0110000;  // show 'E'
endcase
endmodule

module seg7ment_top(
input wire [3:0] num1,
input wire [3:0] num2,
input wire clr,
input wire calculate,
input wire clk,
output wire[6:0]a_to_g,
output wire[4:0]led,
output wire[3:0]an);
wire[4:0]tmp;
reg[4:0]tmp1;
wire[4:0]a;
wire[4:0]b;
reg[1:0]num;
reg[4:0]led_reg;

assign a[0] = num1[0];
assign a[1] = num1[1];
assign a[2] = num1[2];
assign a[3] = num1[3];
assign a[4] = 0;
assign b[0] = num2[0];
assign b[1] = num2[1];
assign b[2] = num2[2];
assign b[3] = num2[3];
assign b[4] = 0;

always @(*)
begin
	if(calculate)
		begin
			tmp1 = a + b;
		end
end

assign tmp = tmp1;

reg[32:0] clk_cnt;
reg[3:0] an_reg;
reg reset_flag;

initial
	begin
		reset_flag = 0;
	end

always @(posedge clk)
clk_cnt = clk_cnt + 1;

always @(*)
begin
	led_reg = tmp;
	if(tmp > 5'b01111)
		begin
			num = 2'b10;
			an_reg = 4'b1110;
		end
	if(tmp <= 5'b01111)
		begin
			case(clk_cnt[15:14])
				0:
					begin
						an_reg = 4'b1110;
						num = tmp[0];
					end
				1:
					begin
						an_reg = 4'b1101;
						num = tmp[1];
					end
				2:
					begin
						an_reg = 4'b1011;
						num = tmp[2];
					end
				default:
					begin
						an_reg = 4'b0111;
						num = tmp[3];
					end
			endcase
		end
	if(reset_flag)
		begin
			num = 2'b00;
			an_reg = 4'b0000;
			led_reg = 4'b0000;
		end
end

always @(*)
begin
	if(calculate)
		begin
			reset_flag = 0;
		end
	if(clr)
		begin
			reset_flag = 1;
		end
end

assign an = an_reg;
assign led = led_reg;

seg7ment_sub A1(.num(num),
		.a_to_g(a_to_g)
);
endmodule
