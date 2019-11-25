`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/03 16:25:07
// Design Name: 
// Module Name: ps2_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//ps2_data由13位条形码的高位向低位依次读取
//register 按由高到低排列
module ps2_top(
     clk,rst_n,ps2_clk,ps2_en,ps2_data,ps2_register//,ps2_out_en
    );
	input clk;
	input rst_n;
	input ps2_en;   //使能信号，高电平有效
	input ps2_clk;
	input ps2_data;     
	output [103:0]ps2_register;
	//output ps2_out_en;
	
	wire ps2_done;
	wire [7:0]ps2_out_data;
	ps2_decode  ps1(
	.clk(clk),
	.rst_n(rst_n),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.ps2_out_data(ps2_out_data),
	.ps2_done(ps2_done)
    );
	ps2_data_manage ps2(
    .clk(clk),
	.rst_n(rst_n),
	.ps2_done(ps2_done),
	.ps2_out_data(ps2_out_data),
	.ps2_en(ps2_en),
	.register(ps2_register),
	.ps2_out_en()
	);
endmodule
