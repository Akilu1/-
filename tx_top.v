`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:39:10 11/24/2018 
// Design Name: 
// Module Name:    tx_top 
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
module tx_top(
   clk,rst_n,serial_data_tx,key_in_save,key_in_fetch,yuyin_one_en,yuyin_end_en,location_end,jingbao);
	input clk;
	input [1:0]yuyin_one_en;
	input rst_n;             //复位
	input key_in_save;
	input key_in_fetch;
	input[1:0]yuyin_end_en;
	input [6:0]location_end;
	input jingbao;
	output serial_data_tx;    //发送的串行数据
	wire tx_down;
	wire [7:0]date_byte;
	wire send_en;
	//提供发送数据模�
	provide_uart_tx_data uu2(
		.clk(clk),
		.rst_n(rst_n),
		.location_end(location_end),
		.yuyin_end_en(yuyin_end_en),
		.yuyin_one_en(yuyin_one_en),
		.key_in_save(key_in_save),
		.key_in_fetch(key_in_fetch),
		.tx_down(tx_down),
		.date_byte(date_byte),
		.send_en(send_en),
		.jingbao(jingbao)
		);
	//单字节（byte：字节）发送模�
	uartuart_byte_tx uu3(
		.clk(clk),      //系统时钟信号
		.rst_n(rst_n),    //复位信号
		.send_en(send_en),     //发送使能信�
		.date_byte(date_byte),    //被发送的单个字节（并行）
		.serial_data_tx(serial_data_tx),     //发送的串行数据
		.tx_down(tx_down)      //一个字节发送完成信�
	);



endmodule
