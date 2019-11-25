`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:30:02 10/27/2019 
// Design Name: 
// Module Name:    PWM 
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
module PWM(
	input clk,		//50Mhz
	input rst_n,
	input sg_key_1,	
	input sg_key_2,
	input sg_key_3,
	input sg_key_4,
	output pwm_1,
	output pwm_2
    );
	
	reg [7:0] angle_1;
	reg [7:0] angle_2;
	wire key_flag1,key_flag2,key_flag3,key_flag4,key_state1,key_state2,key_state3,key_state4;
	
	/* always@(*)begin
		case(select)
			3'b000:angle = 8'd5;		//旋转角度  0  度
			3'b001:angle = 8'd10;		//旋转角度 45  度
			3'b010:angle = 8'd15;		//旋转角度 90  度
			3'b011:angle = 8'd20;		//旋转角度 135 度
			3'b100:angle = 8'd25;		//旋转角度 180 度
			default :angle = 8'd5;		//均不满足时，旋转角度为 0 度
		endcase
	end */
	
	/* always@(*)begin
		case(select)
			3'b000:angle = 8'd5;		//旋转角度  0  度
			3'b001:angle = 8'd6;		//旋转角度 9  度
			3'b010:angle = 8'd7;		//旋转角度 18  度
			3'b011:angle = 8'd8;		//旋转角度 27 度
			3'b100:angle = 8'd9;		//旋转角度 36 度
			3'b101:angle = 8'd10;		//旋转角度 45 度
			3'b110:angle = 8'd11;		//旋转角度 54 度
			3'b111:angle = 8'd12;		//旋转角度 63 度
			default :angle = 8'd5;		//均不满足时，旋转角度为 0 度
		endcase
	end */
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		angle_1<=8'd5;
	else if((angle_1==8'd28)|(angle_1==8'd4))
		angle_1<=8'd5;
	else if(key_flag1&(!key_state1))
		angle_1<=angle_1+1'b1;
	else if(key_flag2&(!key_state2))
		angle_1<=angle_1-1'b1;
	else
		angle_1<=angle_1;
	end
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		angle_2<=8'd5;
	else if((angle_2==8'd28)|(angle_2==8'd4))
		angle_2<=8'd5;
	else if(key_flag3&(!key_state3))
		angle_2<=angle_2+1'b1;
	else if(key_flag4&(!key_state4))
		angle_2<=angle_2-1'b1;
	else
		angle_2<=angle_2;
	end
	key_filter_4s sg1(
    .clk(clk),
	.rst_n(rst_n),
	.key_in1(sg_key_1),
	.key_in2(sg_key_2),
	.key_in3(sg_key_3),
	.key_in4(sg_key_4),
	.key_flag1(key_flag1),
	.key_flag2(key_flag2),
	.key_flag3(key_flag3),
	.key_flag4(key_flag4),
	.key_state1(key_state1),
	.key_state2(key_state2),
	.key_state3(key_state3),
	.key_state4(key_state4)
	);
	
	
	SG_90 U_SG_90_1(
		.clk(clk), 
		.rst_n(rst_n), 
		.angle(angle_1), 
		.pwm(pwm_1)
    );
	
	SG_90 U_SG_90_2(
		.clk(clk), 
		.rst_n(rst_n), 
		.angle(angle_2), 
		.pwm(pwm_2)
    );

endmodule
