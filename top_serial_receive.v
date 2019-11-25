`timescale 1ns / 1ps
module top_serial_receive(
	input 			clk,		//输入主时钟为50Mhz
	input 			rst_n,		//系统复位
	input 			rs232_rx,	//串口串行接收到数据	
	output	[55:0] 	chepai_data	//存储6个8bit的车牌数据，[47:40]为第一个车牌字符,[39:32]为第二个车牌字符,以此类推
);
	
	
	serial_receive U_1(
		.clk(clk),			//50Mhz
		.rst_n(rst_n),				//复位
		.rs232_rx(rs232_rx),		//串行输入数据
		.chepai_data(chepai_data)
	);
	

endmodule
