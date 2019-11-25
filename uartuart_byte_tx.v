`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:37:07 11/24/2018 
// Design Name: 
// Module Name:    uart_byte_tx 
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
//单字节（byte：字节）发送模块
module uartuart_byte_tx(
    input clk,      //系统时钟信号
	input rst_n,    //复位信号
	input send_en,     //发送使能信号
	input [7:0] date_byte,    //被发送的单个字节（并行）
	output reg serial_data_tx,     //发送的串行数据
	output reg tx_down      //一个字节发送完成信号
	);
	reg uart_state;    // 发送状态
	reg[12:0]bps_count;  //产生波特率的计数器
	reg bps_clk;     //波特率信号
	reg[3:0] uart_count;  //发送位数计数（10位）
	//reg [7:0] reserve_date_byte;   //储存被发送的并行数据
	parameter BPSBPS=16'd2500;
	//parameter BPSBPS=13'd5;
	//储存被发送的并行数据
	//always@(posedge clk or negedge rst_n)
	//begin
	//if(!rst_n)
		//reserve_date_byte<=8'd0;
	//else if(send_en)
		//reserve_date_byte<=date_byte;
	//else
		//reserve_date_byte<=reserve_date_byte;
	//end
	//发送状态确定
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
	uart_state<=4'b0;
	else if(send_en)
	uart_state<=1'b1;
	else if(tx_down)
	uart_state<=1'b0;
	else
	uart_state<=uart_state;
	end
	//分频计数模块（9600bps）
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		bps_count<=16'd0;
	else if(uart_state==1'b1)
	begin
		if(bps_count==BPSBPS)
			bps_count<=16'd0;
		else
			bps_count<=bps_count+1'b1;
	end
	else
		bps_count<=16'd0;
	end
		
	// 波特率信号产生模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		bps_clk<=1'b0;
	else if(bps_count==16'd1)
		bps_clk<=1'b1;
	else
		bps_clk<=1'b0;
	end
	
	// 发送位数计数与选择
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		uart_count<=4'b0;
	else if(uart_count==4'd11)       //发送数据8位+起始位+停止位，共10位，去掉0，用1~10
		uart_count<=4'b0;
	else if(bps_clk)
		uart_count<=uart_count+1'b1;
	else
		uart_count<=uart_count;
	end
	// 单字节发送完成信号
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		tx_down<=1'b0;
	else if(uart_count==4'd11)
		tx_down<=1'b1;
	else
		tx_down<=1'b0;
	end
	//发送数据
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		serial_data_tx<=1'b0;
	else
	begin
		case(uart_count)
		4'b0000:serial_data_tx<=1'b1;
		4'b0001:serial_data_tx<=1'b0;
		4'b0010:serial_data_tx<=date_byte[0];
		4'b0011:serial_data_tx<=date_byte[1];
		4'b0100:serial_data_tx<=date_byte[2];
		4'b0101:serial_data_tx<=date_byte[3];
		4'b0110:serial_data_tx<=date_byte[4];
		4'b0111:serial_data_tx<=date_byte[5];
		4'b1000:serial_data_tx<=date_byte[6];
		4'b1001:serial_data_tx<=date_byte[7];
		4'b1010:serial_data_tx<=1'b1;
		default:serial_data_tx<=1'b1;
		endcase
	end
	end



endmodule
