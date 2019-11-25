`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:20 11/24/2018 
// Design Name: 
// Module Name:    rx_top 
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
module rx_top(
    clk,rst_n,uart_data_rx,yuyin_addr,key_yuyin,yuyin_one_en);
	
	input rst_n;      //复位按键
	input clk;        // 系统时钟
	input uart_data_rx;    //接收到的串行数据
	output  [1:0]yuyin_one_en;
	input key_yuyin;
	output [6:0]yuyin_addr;
	

	wire [7:0]parallel_data_rx;
	wire rx_down;
	
	uartuart_byte_rx QQ2(
        .rst_n(key_yuyin),
        .clk(clk),
        .uart_data_rx(uart_data_rx),
        .parallel_data_rx(parallel_data_rx),
        .rx_down(rx_down)
    );
	rx_data_reserve_judge QQ3(
    .clk(clk),
	.rst_n(rst_n),
	.yuyin_addr(yuyin_addr),
	.parallel_data_rx(parallel_data_rx),
	.rx_down(rx_down),
	.yuyin_one_en(yuyin_one_en)
	);

endmodule
