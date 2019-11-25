`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:31 11/13/2019 
// Design Name: 
// Module Name:    seg 
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
module seg(
	input clk_50MHZ,
	input rst_n,
	input [3:0] in_1,
	input [3:0] in_2,
	input [3:0] in_3,
	input [3:0] in_4,
	
	output reg [6:0] duan,
	output reg [3:0] wei,
	output dp
    );
	
	
	
	reg [3:0] out_4;       
	reg [1:0] S;
	wire clk_190HZ;
	reg [17:0] cnt;
	
	assign clk_190HZ = cnt[17];
	assign dp = 1;
	
	
	always@(posedge clk_50MHZ or negedge rst_n)begin
		if(!rst_n)
			cnt <= 18'd0;
		else
			cnt <= cnt + 1;
	end

	
	always@(posedge clk_190HZ or negedge rst_n)begin
	   if(!rst_n)
	     S <= 0;
	   else
	     S <= S + 1;
	end
	
	always@(*)
	begin
	   case(S)
		0:wei = 4'b1110;
		1:wei = 4'b1101;
		2:wei = 4'b1011;
		3:wei = 4'b0111;
		default:wei = 4'b1111;
	   endcase
	end
	
	always@(*)
	begin
		case(wei)
			4'b1110:out_4 = in_1;
			4'b1101:out_4 = in_2;
			4'b1011:out_4 = in_3;
			4'b0111:out_4 = in_4;
			default:out_4 = 4'b0;
		endcase
	end
	
	always@(*)
	begin
		case(out_4)
			0:duan = 7'b000_0001;
			1:duan = 7'b100_1111;
			2:duan = 7'b001_0010;
			3:duan = 7'b000_0110;
			4:duan = 7'b100_1100;
			5:duan = 7'b010_0100;
			6:duan = 7'b010_0000;
			7:duan = 7'b000_1111;
			8:duan = 7'b000_0000;
			9:duan = 7'b000_0100;
			default:duan = 7'b000_0001;
		endcase
	end

endmodule