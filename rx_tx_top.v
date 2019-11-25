`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:06:17 11/25/2018 
// Design Name: 
// Module Name:    rx_tx_top 
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
module rx_tx_top(clk,rst_n,serial_data_tx,uart_data_rx,yuyin_end_en,yuyin_addr,
		key_in_save,key_in_fetch,key_yuyin,location_end,jingbao
    );
	input clk;
	input rst_n;
	input key_yuyin;
	input [1:0]yuyin_end_en;
	input uart_data_rx;
	input key_in_save;
	input key_in_fetch;
	input [6:0]location_end;
	input jingbao;
	output serial_data_tx;
	output [6:0]yuyin_addr;
	wire [1:0]yuyin_one_en;
    rx_top  ff1(
         .clk(clk),
	     .rst_n(rst_n),
		 .key_yuyin(key_yuyin),
		 .yuyin_addr(yuyin_addr),
	     .uart_data_rx(uart_data_rx),
		 .yuyin_one_en(yuyin_one_en)
	     );
	tx_top ff2(
         .clk(clk),
		 .yuyin_one_en(yuyin_one_en),
		 .yuyin_end_en(yuyin_end_en),
		 .location_end(location_end),
		 .key_in_save(key_in_save),
		 .key_in_fetch(key_in_fetch),
         .rst_n(rst_n),
		 .jingbao(jingbao),
         .serial_data_tx(serial_data_tx)
		 );

endmodule
