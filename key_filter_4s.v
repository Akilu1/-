`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:38:14 11/19/2018 
// Design Name: 
// Module Name:    key_filter_4s 
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
module key_filter_4s(
    clk,rst_n,key_in1,key_in2,key_in3,key_in4,key_flag1,key_flag2,key_flag3,key_flag4,key_state1,key_state2,key_state3,key_state4 );
   
   input clk;   //系统时钟
   input rst_n;  //复位信号
   input key_in1;  //按键输入
   input key_in2;
   input key_in3;
   input key_in4;
   output key_flag1;   //确认按键按下或释放的信号
   output key_flag2;
   output key_flag3;
   output key_flag4;
   output key_state1;  //按键状态
   output key_state2;
   output key_state3;
   output key_state4;
   key_filter_1s uu1(     
    .clk(clk),
	.rst_n(rst_n),
	.key_in(key_in1),
	.key_flag(key_flag1),
	.key_state(key_state1)
	);
	
	key_filter_1s uu2(     
    .clk(clk),
	.rst_n(rst_n),
	.key_in(key_in2),
	.key_flag(key_flag2),
	.key_state(key_state2)
	);
	
	key_filter_1s uu3(     
    .clk(clk),
	.rst_n(rst_n),
	.key_in(key_in3),
	.key_flag(key_flag3),
	.key_state(key_state3)
	);
	
	key_filter_1s uu4(     
    .clk(clk),
	.rst_n(rst_n),
	.key_in(key_in4),
	.key_flag(key_flag4),
	.key_state(key_state4)
	);

endmodule
