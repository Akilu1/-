`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:34:11 10/15/2019 
// Design Name: 
// Module Name:    B_BCD 
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
module B_BCD(
    input      [7:0] binary,
	output reg [3:0] hundreds,
	output reg [3:0] tens,
	output reg [3:0] ones
    );
	
	integer i;
	
	always @(*)begin
		hundreds = 4'b0;
		tens     = 4'b0;
		ones     = 4'b0;
		for(i=7;i>=0;i=i-1)begin
			if(hundreds >= 5)
				hundreds = hundreds + 3;
			if(tens >= 5)
				tens = tens + 3;
			if(ones >= 5)
				ones = ones + 3;
			//shift left one	
			hundreds = hundreds << 1;
			hundreds[0] = tens[3];
			tens = tens << 1;
			tens[0] = ones[3];
			ones = ones << 1;
			ones[0]	= binary[i];
		end
	end

endmodule
