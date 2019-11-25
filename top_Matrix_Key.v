`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:19:26 11/13/2019 
// Design Name: 
// Module Name:    top_Matrix_Key 
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
module top_Matrix_Key(
	input 			clk,		//24Mhz
	input 			rst_n,
	input 	[1:0]	disp,		//显示手机号
	input			delete,		//删除键
	input 	[3:0] 	row_data,	//行输入
	output 	[6:0] 	duan,
	output 	[3:0] 	wei,
	output 			dp,
	output 	[3:0] 	col_data,
	output 	[43:0] 	phone_number	//输出的44位手机号码，最低位为手机号的最高位
    );

	
    wire	[3:0]	key_value;	//数据
	wire 			key_flag;	//消除抖动标志
	wire 	[43:0] 	phone_number;
	wire 			clk_50mhz;
	
	reg [4:0] in_4_r;
	reg [4:0] in_3_r;
	reg [4:0] in_2_r;
	reg [4:0] in_1_r;
	
	Matrix_Key_Scan U_1_Matrix_Key_Scan (
		.clk(clk_50mhz), 
		.rst_n(rst_n),
		.row_data(row_data), 
		.key_flag(key_flag), 
		.phone_number_r(phone_number), 
		.col_data(col_data)
    );

	seg U_2_seg (
		.clk_50MHZ(clk_50mhz), 
		.rst_n(rst_n), 
		.in_4(in_4_r), 
		.in_3(in_3_r), 
		.in_2(in_2_r), 
		.in_1(in_1_r), 
		.duan(duan), 
		.wei(wei), 
		.dp(dp)
    );
	
	clk_50Mhz U_3_clk_50Mhz(
		.refclk(clk),
		.reset(~rst_n),
		.clk0_out(),
		.clk1_out(clk_50mhz)
	);
	
	always@(*)begin
		case(disp)
			2'b00:
				begin
					in_4_r = phone_number[43:40];
					in_3_r = phone_number[39:36];
					in_2_r = phone_number[35:32];
					in_1_r = phone_number[31:28];
				end
			2'b01:
				begin
					in_4_r = phone_number[27:24];
					in_3_r = phone_number[23:20];
					in_2_r = phone_number[19:16];
					in_1_r = phone_number[15:12]; 
				end
			2'b10:
				begin
					in_4_r = phone_number[11:8];
					in_3_r = phone_number[7:4];
					in_2_r = phone_number[3:0];
					in_1_r = 4'b0;
				end
			default:
				begin
					in_4_r = phone_number[43:40];
					in_3_r = phone_number[39:36];
					in_2_r = phone_number[35:32];
					in_1_r = phone_number[31:28];
				end
		endcase
	end

endmodule
