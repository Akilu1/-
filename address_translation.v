`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:39 11/02/2019 
// Design Name: 
// Module Name:    address_translation 
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
module address_translation(
    clk,rst_n,ps2_key1,save_or_fetch_key,ps2_register,location,in_addr
	);
	input clk;
	input rst_n;
	input ps2_key1;          //扫码使能信号（高电平有效）  
	//input ps2_key2;          //车牌识别使能信号（低z电平有效）
	input save_or_fetch_key; //  存取使能信号（0：存  1：取）
	input [103:0]ps2_register;
	output reg [6:0]location;
	input [4:0]in_addr;
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		location<=7'd0;
	else if(!save_or_fetch_key)
		begin
		if(ps2_key1)
			begin
			case(ps2_register)
			104'h39_37_38_37_33_35_38_39_37_35_32_39_30:location<=7'b101_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_31:location<=7'b101_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_32:location<=7'b101_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_33:location<=7'b101_100_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_34:location<=7'b111_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_35:location<=7'b111_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_36:location<=7'b111_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_37:location<=7'b111_100_0;
			
			104'h39_37_38_37_33_35_38_39_37_35_32_38_30:location<=7'b001_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_31:location<=7'b001_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_32:location<=7'b001_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_33:location<=7'b001_100_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_34:location<=7'b011_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_35:location<=7'b011_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_36:location<=7'b011_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_37:location<=7'b011_100_0;
			default:location<=7'D0;
			endcase
			end
		else 
			begin
			case(in_addr)
			'd0:location<=7'D0;
			'd1:location<=7'b001_001_0;
			'd2:location<=7'b001_010_0;
			'd3:location<=7'b001_011_0;
			'd4:location<=7'b001_100_0;
			'd5:location<=7'b011_001_0;
			'd6:location<=7'b011_010_0;
			'd7:location<=7'b011_011_0;
			'd8:location<=7'b011_100_0;
			'd9:location<=7'b101_001_0;
			'd10:location<=7'b101_010_0;
			'd11:location<=7'b101_011_0;
			'd12:location<=7'b101_100_0;
			'd13:location<=7'b111_001_0;
			'd14:location<=7'b111_010_0;
			'd15:location<=7'b111_011_0;
			'd16:location<=7'b111_100_0;
			default:location<=7'D0;
			endcase			
			end
		end
	else
		begin
		if(ps2_key1)
			begin
			case(ps2_register)
			104'h39_37_38_37_33_35_38_39_37_35_32_39_30:location<=7'b100_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_31:location<=7'b100_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_32:location<=7'b100_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_33:location<=7'b100_100_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_34:location<=7'b110_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_35:location<=7'b110_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_36:location<=7'b110_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_39_37:location<=7'b110_100_0;
			
			104'h39_37_38_37_33_35_38_39_37_35_32_38_30:location<=7'b000_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_31:location<=7'b000_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_32:location<=7'b000_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_33:location<=7'b000_100_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_34:location<=7'b010_001_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_35:location<=7'b010_010_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_36:location<=7'b010_011_0;
			104'h39_37_38_37_33_35_38_39_37_35_32_38_37:location<=7'b010_100_0;
			default:location<=7'd0;
			endcase
			end
		else
			begin
			case(in_addr)
			'd0:location<=7'D0;
			'd1:location<=7'b000_001_0;
			'd2:location<=7'b000_010_0;
			'd3:location<=7'b000_011_0;
			'd4:location<=7'b000_100_0;
			'd5:location<=7'b010_001_0;
			'd6:location<=7'b010_010_0;
			'd7:location<=7'b010_011_0;
			'd8:location<=7'b010_100_0;
			'd9:location<=7'b100_001_0;
			'd10:location<=7'b100_010_0;
			'd11:location<=7'b100_011_0;
			'd12:location<=7'b100_100_0;
			'd13:location<=7'b110_001_0;
			'd14:location<=7'b110_010_0;
			'd15:location<=7'b110_011_0;
			'd16:location<=7'b110_100_0;
			default:location<=7'D0;
			endcase			
			end
		end
	end
endmodule
