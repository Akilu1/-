`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:13 09/21/2019 
// Design Name: 
// Module Name:    con_wen_z 
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
module vga_location(
    in_cnt_x,
	in_cnt_y,
	en_wen_z,
	clk
    );
	input [9:0]in_cnt_x;
	input [9:0]in_cnt_y;
	input clk;
	output reg en_wen_z;
	
	reg [4:0]cnt_x;
	reg [4:0]cnt_y;
	
	
	reg [1:0]now_num;   //确定当前显示哪个孍
	reg [6:0]addr;      //rom的地址
	
	wire [0:31]data;     //rom读出的
	
	reg disp_en;        //有效显示标志
	
	
	always@(*)                    //确定汉字位置的模
	begin
	    if((in_cnt_y>=6'd48)&&(in_cnt_y<=7'd79))
		begin
    		cnt_y=in_cnt_y-6'd48;
	        if((in_cnt_x>=(9'd320+8'd144))&&(in_cnt_x<=(9'd351+8'd144)))
		    begin
    	        now_num=2'd1;
		        cnt_x=in_cnt_x-9'd320-8'd144;
		    end
			else if((in_cnt_x>=(9'd352+8'd144))&&(in_cnt_x<=(9'd383+8'd144)))
		    begin
    	        now_num=2'd3;
		        cnt_x=in_cnt_x-9'd352-8'd144;
		    end
			else
			    now_num=2'd2;
		end
		else if((in_cnt_y>=7'd80)&&(in_cnt_y<=7'd111))
		begin
    		cnt_y=in_cnt_y-7'd80;
	        if((in_cnt_x>=(9'd320+8'd144))&&(in_cnt_x<=(9'd351+8'd144)))
		    begin
    	        now_num=2'd2;
		        cnt_x=in_cnt_x-9'd320-8'd144;
		    end
			else if((in_cnt_x>=(9'd352+8'd144))&&(in_cnt_x<=(9'd383+8'd144)))
		    begin
    	        now_num=2'd3;
		        cnt_x=in_cnt_x-9'd352-8'd144;
		    end
			else
			    now_num=2'd2;
		end
	end
	
	always@(*)
	begin
	    if((in_cnt_y>=6'd48)&&(in_cnt_y<=7'd111)&&(in_cnt_x>=9'd320+8'd144)&&(in_cnt_x<=9'd383+8'd144))
	        disp_en=1'b1;
		else
		    disp_en=1'b0;
	end
	
	always@(*)                    //确定rom地址的模坍
	begin
	    case(now_num)
		2'b1:
		    addr=cnt_y;         //温湿度
		2'd2:
		    addr=cnt_y+6'd32;   //湍
		2'd3:
		    addr=cnt_y+7'd64;   //庍
		default:;
	    endcase
	end
	
	always@(*)
	begin
		if(data[cnt_x]&&disp_en)
		    en_wen_z=1'b1;
		else
		    en_wen_z=1'b0;
	end
	
	rom_iip wenshidu( 
	.doa(data), 
	.addra(addr), 
	.clka(clk), 
	.rsta(1'b0)
	);
		
		
	
	
	

	

endmodule
