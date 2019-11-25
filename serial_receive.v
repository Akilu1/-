`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:14 11/01/2019 
// Design Name: 
// Module Name:    serial_receive 
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
module serial_receive(
	input 				clk,		//50Mhz
	input 				rst_n,		//复位
	input 				rs232_rx,	//串行输入数据
	
/* 	input 				select_en,
	input		[2:0]	select, */
	output	reg [55:0] 	chepai_data
);
	
	wire 	[7:0]	data_byte;	//串口接收，并行输出的数据
	wire 			rx_done;	//接收完成标志
	
	
	uart_receive U_uart_receive(
		.mclk			(clk),		//系统时钟50Mhz
		.rst_n			(rst_n),
		.baud_set		(3'd4), 	//默认波特率115200
		.rs232_rx		(rs232_rx),
		.rx_done		(rx_done),
		.uart_state		(),
		.data_byte		(data_byte)
	);
	
	//reg [47:0] chepai_data;
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			chepai_data <= 'd0;
		else if(rx_done)
			chepai_data <= {chepai_data[47:0],data_byte};
		else 
			chepai_data <= chepai_data;
	end
	
	
	//下面的always块仅用于测试，用于测试接收到的6位车牌数据是否正确
	
	/* always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			led <= 8'b0;
		else if(select_en == 1'b1)begin
			case(select)
				3'b000: led <= chepai_data[47:40];
				3'b001: led <= chepai_data[39:32];
				3'b010: led <= chepai_data[31:24];
				3'b011: led <= chepai_data[23:16];
				3'b100: led <= chepai_data[15:8];
				3'b101: led <= chepai_data[7:0];
				default:led <= 8'b0;
			endcase
		end
		else 
			led <= 8'b0;
	end */
		
endmodule
