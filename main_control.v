`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:21:56 11/02/2019 
// Design Name: 
// Module Name:    main_control 
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
module main_control(
    clk,rst_n,ps2_clk,ps2_data,ps2_en,ps2_key1,save_or_fetch_key,key_in1,key_in2,extend_shrink_direction,
	extend_shrink_pulse,rise_fall_direction,rise_fall_pulse,rotate_direction,rotate_pulse,led,in_addr,out_addr,
	key_yuyin,yuyin_uart_data_rx,yuyin_serial_data_tx,yuyin_out_addr,rrrrr,jingbao
    );
	input clk;
	input rst_n;
	input ps2_clk;
	input ps2_data;
	input ps2_en;               //扫码开关
	input ps2_key1;     		//扫码使能信号（高电平有效）  
	input save_or_fetch_key;    //  存取使能信号（0：存  1：取）
	input [4:0]in_addr;
	input key_in1;    //按键，开始存
	input key_in2;	  //按键，开始取
	input key_yuyin;
	input jingbao;
	
	input yuyin_uart_data_rx;
	output yuyin_serial_data_tx;
	
	output extend_shrink_direction;    //伸缩方向信号（0：伸长；1：缩回）
	output extend_shrink_pulse;        //伸缩脉冲
	output rise_fall_direction;        //升降方向信号（0：上升；1：下降）
	output rise_fall_pulse;            //升降脉冲
	output rotate_direction;           //旋转方向信号（0：顺时针；1：逆时针）
	output rotate_pulse;               //旋转脉冲
	output reg [4:0]out_addr;
	output reg [4:0]yuyin_out_addr;
	output [6:0]led;
	output rrrrr;
	
	
	wire [6:0]location;
	wire [6:0]location_end;
	wire [103:0]ps2_register;
	wire [6:0]yuyin_addr;
	wire [1:0]yuyin_end_en;
	
	wire key2_en;
	wire key1_en;
	assign rrrrr=~yuyin_addr[4];
	//wire ps2_out_en;
	assign location_end=(key_yuyin)?yuyin_addr:location;
	
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		yuyin_out_addr<=5'd0;
		out_addr<=5'd0;
		end
	else if (key_yuyin)
		begin
		out_addr<=out_addr;
		case(yuyin_addr)
		7'b101_001_0,7'b100_001_0:yuyin_out_addr<=5'd9;
		7'b101_010_0,7'b100_010_0:yuyin_out_addr<=5'd10;
		7'b101_011_0,7'b100_011_0:yuyin_out_addr<=5'd11;
		7'b101_100_0,7'b100_100_0:yuyin_out_addr<=5'd12;
		7'b111_001_0,7'b110_001_0:yuyin_out_addr<=5'd13;
		7'b111_010_0,7'b110_010_0:yuyin_out_addr<=5'd14;
		7'b111_011_0,7'b110_011_0:yuyin_out_addr<=5'd15;
		7'b111_100_0,7'b110_100_0:yuyin_out_addr<=5'd16;
		                                                    
		7'b001_001_0,7'b000_001_0:yuyin_out_addr<=5'd1;
		7'b001_010_0,7'b000_010_0:yuyin_out_addr<=5'd2;
		7'b001_011_0,7'b000_011_0:yuyin_out_addr<=5'd3;
		7'b001_100_0,7'b000_100_0:yuyin_out_addr<=5'd4;
		7'b011_001_0,7'b010_001_0:yuyin_out_addr<=5'd5;
		7'b011_010_0,7'b010_010_0:yuyin_out_addr<=5'd6;
		7'b011_011_0,7'b010_011_0:yuyin_out_addr<=5'd7;
		7'b011_100_0,7'b010_100_0:yuyin_out_addr<=5'd8;
		default:yuyin_out_addr<=5'd0;
		endcase
		end
	else
		begin
		yuyin_out_addr<=yuyin_out_addr;
		case(ps2_register)
		104'h39_37_38_37_33_35_38_39_37_35_32_39_30:out_addr<=5'd9;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_31:out_addr<=5'd10;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_32:out_addr<=5'd11;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_33:out_addr<=5'd12;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_34:out_addr<=5'd13;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_35:out_addr<=5'd14;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_36:out_addr<=5'd15;
		104'h39_37_38_37_33_35_38_39_37_35_32_39_37:out_addr<=5'd16;
		                                                      
		104'h39_37_38_37_33_35_38_39_37_35_32_38_30:out_addr<=5'd1;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_31:out_addr<=5'd2;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_32:out_addr<=5'd3;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_33:out_addr<=5'd4;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_34:out_addr<=5'd5;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_35:out_addr<=5'd6;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_36:out_addr<=5'd7;
		104'h39_37_38_37_33_35_38_39_37_35_32_38_37:out_addr<=5'd8;
		default:out_addr<=5'd0;
		endcase
		end
	end
	rx_tx_top q4(
	.clk(clk),
	.rst_n(rst_n),
	.key_yuyin(key_yuyin),
	.location_end(location_end),
	.serial_data_tx(yuyin_serial_data_tx),
	.uart_data_rx(yuyin_uart_data_rx),
	.yuyin_end_en(yuyin_end_en),
	.yuyin_addr(yuyin_addr),
	.key_in_save(key1_en),
	.key_in_fetch(key2_en),
	.jingbao(jingbao)
    );
	
	address_translation q1(
    .clk(clk),
	.rst_n(rst_n),
	.ps2_key1(ps2_key1),
	.save_or_fetch_key(save_or_fetch_key),
	.ps2_register(ps2_register),
	//.ps2_out_en(ps2_out_en),
	.location(location),
	.in_addr(in_addr)
	);
	
	master_control q2(
    .clk(clk),
	.rst_n(rst_n),
	.key_in1(key_in1),
	.key_in2(key_in2),
	.key1_en(key1_en),
	.key2_en(key2_en),
	.location(location_end),
	.yuyin_end_en(yuyin_end_en),
	.extend_shrink_direction(extend_shrink_direction),
	.extend_shrink_pulse(extend_shrink_pulse),
	.rise_fall_direction(rise_fall_direction),
	.rise_fall_pulse(rise_fall_pulse),
	.rotate_direction(rotate_direction),
	.rotate_pulse(rotate_pulse)
	);
	
	ps2_top q3(
     .clk(clk),
	 .rst_n(rst_n),
	 .ps2_clk(ps2_clk),
	 .ps2_en(ps2_en),
	 .ps2_data(ps2_data),
	 .ps2_register(ps2_register)//,
	 //.ps2_out_en()
    );
	assign led=~location_end;
endmodule
