`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:59:44 10/27/2019 
// Design Name: 
// Module Name:    SG_90 
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
module SG_90(
	input clk,			//50Mhz
	input rst_n,
	input [7:0] angle,	//转动角度
	output reg pwm
    );
	
	reg [12:0] cnt1;
	reg [7:0]  cnt2;
	
	always@(posedge clk or negedge rst_n)begin		//cnt1用来计数产生一个周期为 0.1ms 的脉冲
		if(!rst_n)
			cnt1 <= 13'd0;
		else if(cnt1 == 13'd5_000)
			cnt1 <= 13'd0;
		else 
			cnt1 <= cnt1 + 1'b1;
	end
	
	always@(posedge clk or negedge rst_n)begin		//对0.1ms的脉冲计数
		if(!rst_n)
			cnt2 <= 8'd0;
		else if(cnt1 == 13'd5_000)begin
			if(cnt2 == 8'd200)
				cnt2 <= 8'd0;
			else 
				cnt2 <= cnt2 + 1'b1;
		end
		else 
			cnt2 <= cnt2;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			pwm <= 1'b1;
		else if(cnt2 == 8'd0)
			pwm <= 1'b1;
		else if(cnt2 == angle)
			pwm <= 1'b0;
		else if(cnt2 == 8'd200)
			pwm <= 1'b0;
		else 
			pwm <= pwm;
	end

endmodule
