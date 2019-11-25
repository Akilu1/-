`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:32 12/18/2018 
// Design Name: 
// Module Name:    VGA 
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
module VGA_CORE(clk_25mhz,rst_n,cnt_h,cnt_l,htb_en,ltb_en,xs_en,xs_t_en,rd_addr                                //640*480/60fps VGA驱动
    );
	input rst_n;
	output reg xs_t_en;
	output reg htb_en;       //行同步信�
	output reg ltb_en;       //列同步信�
	output reg xs_en;        //在有效区域内的使能信号，在为1
	output [15:0]rd_addr;
	
	reg [1:0]cnt_25mhz;
	input clk_25mhz;
	
    output reg [9:0]cnt_h;      //像素计数�
	output reg [9:0]cnt_l;      //行计数器
	
	parameter width = 'd400;
	parameter lenth = 'd328;
	
	parameter h_a=7'd96,h_b=6'd48,h_c=10'd640,h_d=5'd16,h_totlly=10'd800;
	parameter l_o=2'd2,l_p=6'd33,l_q=9'd480,l_r=4'd10,l_totlly=10'd525;
	
	
    assign rd_addr=(cnt_h-h_a-h_b+2)/2+((cnt_l-l_o-l_p)/2)*'d200;
	
	always@(posedge clk_25mhz or negedge rst_n)      //cnt_h的描述块
	begin
	    if(rst_n==0)
		    cnt_h<=0;
		else if(cnt_h==10'd800-1'd1)
		    cnt_h<=0;
		else
		    cnt_h<=cnt_h+1;
	end
	
	always@(posedge clk_25mhz or negedge rst_n)      //cnt_l描述�
	begin
	    if(rst_n==0)
		    cnt_l<=0;
		else if(cnt_l==10'd525-1'd1)
		    cnt_l<=0;
		else if(cnt_h==10'd800-1'd1)
            cnt_l<=cnt_l+1'd1;
    end
	
	always@(*)      //htb_en描述�
	begin
	    if(rst_n==0)
		    htb_en=1'b1;
		else if(cnt_h<h_a)
	        htb_en=0;
		else
		    htb_en=1;
	end
	
	always@(*)      //ltb_en描述块，低电平进入同步状�
	begin
	    if(rst_n==0)
		    ltb_en=1'd1;
		else if(cnt_l<l_o)
		    ltb_en=0;
		else
		    ltb_en=1;
	end
	
	always@(posedge clk_25mhz or negedge rst_n)
	begin
	    if(rst_n==0)
		    xs_en<=0;
		else if((cnt_h>(h_a+h_b))&&(cnt_h<(h_a+h_b+h_c))&&(cnt_l>(l_o+l_p))&&(cnt_l<(l_o+l_p+l_q)))
	        xs_en<=1;
		else 
		    xs_en<=0;
	end
	
	always@(posedge clk_25mhz or negedge rst_n)
	begin
	    if(rst_n==0)
		    xs_t_en<=0;
		else if((cnt_h>(h_a+h_b))&&(cnt_h<(h_a+h_b+width))&&(cnt_l>(l_o+l_p))&&(cnt_l<(l_o+l_p+lenth)))
	        xs_t_en<=1;
		else 
		    xs_t_en<=0;
	end
	
endmodule
