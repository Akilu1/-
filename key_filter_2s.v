`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:58 10/19/2019 
// Design Name: 
// Module Name:    key_filter_2s 
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
module key_filter_2s(
    clk,rst_n,key_in1,key_in2,key1_en,key2_en);
	input clk;   //系统时钟
    input rst_n;  //复位信号
    input key_in1;  //按键输入
    input key_in2;
	output key1_en;
	output key2_en;
    wire key_flag1;   //确认按键按下或释放的信号
    wire key_flag2;
    wire key_state1;  //按键状态
    wire key_state2;
   key_filter_1 uuu1(     
    .clk(clk),
	.rst_n(rst_n),
	.key_in(key_in1),
	.key_flag(key_flag1),
	.key_state(key_state1)
	);
	
	key_filter_1 uuu2(     
    .clk(clk),
	.rst_n(rst_n),
	.key_in(key_in2),
	.key_flag(key_flag2),
	.key_state(key_state2)
	);
	
	assign key1_en=(key_flag1&(!key_state1));
	assign key2_en=(key_flag2&(!key_state2));
	
endmodule
