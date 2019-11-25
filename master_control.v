`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:28:44 10/19/2019 
// Design Name: 
// Module Name:    master_control 
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
module master_control(
    clk,rst_n,key_in1,key_in2,location,extend_shrink_direction,extend_shrink_pulse,rise_fall_direction,
	rise_fall_pulse,rotate_direction,rotate_pulse,yuyin_end_en,key1_en,key2_en
	);
	input clk;
	input rst_n;
	input key_in1;
	input key_in2;
	input [6:0]location;   //位置编码(seven)
	
	output extend_shrink_direction;  //伸缩方向信号（0：伸长；1：缩回）
	output extend_shrink_pulse;      //伸缩脉冲
	output rise_fall_direction;      //升降方向信号（0：上升；1：下降）
	output reg rise_fall_pulse;      //升降脉冲
	output rotate_direction;         //旋转方向信号（0：顺时针；1：逆时针）
	output rotate_pulse;             //旋转脉冲
	output [1:0]yuyin_end_en;
	
	output key1_en;
	output key2_en;
	
	reg [6:0]location_coding;
	reg key1_en_temporary;   //用于临时储存使能信号
	reg key2_en_temporary;
	
	reg clk_a;
	reg clk_b;
	reg clk_c;
	reg clk_d;
	reg [31:0]cnt_a;
	reg [31:0]cnt_b;
	reg [31:0]cnt_c;
	reg [31:0]cnt_d;
	
	reg save_en;
	reg fetch_en;
	wire rotate_en;
	wire rise_fall_en;
	wire rise_fall_en_main;
	wire extend_shrink_en;
	wire empty_location_en;
	wire occupy_en;
	wire accomplish_en;
	
	key_filter_2s BB1(
    .clk(clk),
	.rst_n(rst_n),
	.key_in1(key_in1),
	.key_in2(key_in2),
	.key1_en(key1_en),
	.key2_en(key2_en)
	);
	
	
	
	location_judge AA1(
    .clk(clk),
	.rst_n(rst_n),
	.save_en(save_en),  //存储信号
	.fetch_en(fetch_en),   //取物信号
	.location_coding(location_coding),   //位置编码(seven)
	.yuyin_end_en(yuyin_end_en),
	.rotate_direction(rotate_direction),   //旋转方向信号（0：顺时针；1：逆时针）
	.rotate_en(rotate_en),            //旋转使能信号
	.rise_fall_direction(rise_fall_direction),    //升降方向信号（0：上升；1：下降）
	.rise_fall_en(rise_fall_en),           //升降使能信号
	.rise_fall_en_main(rise_fall_en_main),
	.extend_shrink_direction(extend_shrink_direction),    //伸缩方向信号（0：伸长；1：缩回）
	.extend_shrink_en(extend_shrink_en),           //伸缩使能信号
	.occupy_en(occupy_en),        //工作信号（高电平表示正在工作）   occupy（vi占据，占领，居住，使忙碌）
	.empty_location_en(empty_location_en),     //清空地址，使能信号（高电平时对地址进行清零）
	.accomplish_en(accomplish_en)    //完成信号
	);

	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		save_en<=1'b0;
		fetch_en<=1'b0;
		location_coding<=7'd0;
		end
	else if(empty_location_en)
		begin
		save_en<=save_en;
		fetch_en<=fetch_en;
		location_coding<=7'd0;
		end
	else if(accomplish_en)
		begin
		save_en<=1'b0;
		fetch_en<=1'b0;
		location_coding<=7'd0;
		end
	else if(!occupy_en)
		begin
		if(key1_en|key1_en_temporary)
			begin
			save_en<=1'b1;
			fetch_en<=1'b0;
			location_coding<=location;
			key2_en_temporary<=1'b0;
			key1_en_temporary<=1'b0;
			end
		else if(key2_en|key2_en_temporary)
			begin
			save_en<=1'b0;
			fetch_en<=1'b1;
			location_coding<=location;
			key2_en_temporary<=1'b0;
			key1_en_temporary<=1'b0;
			end
		end
	else if(occupy_en)
		begin
		if(key1_en)
			begin
			key1_en_temporary<=1'b1;
			end
		else if(key2_en)
			begin
			key2_en_temporary<=1'b1;
			end

		end
	
	end
	//伸缩脉冲产生
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		clk_a<=1'b0;
		cnt_a<=32'd0;
		end
	else if(cnt_a==32'd12000)  //12000   1000hz
		begin
		clk_a<=~clk_a;
		cnt_a<=32'd0;
		end
	else
		begin
		cnt_a<=cnt_a+1'b1;
		end
	end
	//升降脉冲产生
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		clk_b<=1'b0;
		cnt_b<=32'd0;
		end
	else if(cnt_b==32'd24000)  //24000   500hz
		begin
		clk_b<=~clk_b;
		cnt_b<=32'd0;
		end
	else
		begin
		cnt_b<=cnt_b+1'b1;
		end
	end
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		clk_d<=1'b0;
		cnt_d<=32'd0;
		end
	else if(cnt_d==32'd4615)  //4615  2600hz
		begin
		clk_d<=~clk_d;
		cnt_d<=32'd0;
		end
	else
		begin
		cnt_d<=cnt_d+1'b1;
		end
	end
	//旋转脉冲产生
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		clk_c<=1'b0;
		cnt_c<=32'd0;
		end
	else if(cnt_c==32'd4800) //4800    2500hz
		begin
		clk_c<=~clk_c;
		cnt_c<=32'd0;
		end
	else
		begin
		cnt_c<=cnt_c+1'b1;
		end
	end
	
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		rise_fall_pulse<=1'b0;
	else if(rise_fall_en)
		rise_fall_pulse<=clk_b;
	else if(rise_fall_en_main)
		rise_fall_pulse<=clk_d;
	else
		rise_fall_pulse<=1'b0;
	end
	
	assign extend_shrink_pulse=(extend_shrink_en)? clk_a:1'b0;
	assign rotate_pulse=(rotate_en)? clk_c:1'b0;
endmodule
