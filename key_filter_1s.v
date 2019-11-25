`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:19:30 10/19/2019 
// Design Name: 
// Module Name:    key_filter_1
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
module key_filter_1(  //filter  n:过滤器；筛� v:滤过，渗入；
    clk,rst_n,key_in,key_flag,key_state);
    input clk;
	input rst_n;
	input key_in;
	output reg key_flag;      // 确认按键按下或释放的信号（一个时钟）
	output reg key_state;    //按键一直处于的状态（稳定时）
	
	parameter IDEA=4'b0001;     //空闲状�
	parameter FILTER1=4'b0010;   //检测到下降�0ms计数，消抖状�
	parameter DOWN=4'b0100;      // 按下稳定状�
	parameter FILTER2=4'b1000;    // 检测到上升�20ms计数，消抖状�
	
	parameter cnt_figure=20'd480000;    //20ms计数器计满数�
                                         //figure(n:数字、人物、图形、价格、（人的）体形、画像。v：计算、出现、扮演角�
	//parameter cnt_figure=20'd49;    // 仿真测试

	reg key_in_a,key_in_b;       //异步信号进行同步处理寄存�
	reg key_tmp_a,key_tmp_b;       //边沿检测寄存器
	reg[19:0] cnt;   //20ms计数�
	reg en_cnt;    // 20ms计数器使能信�
	reg cnt_full;  //20ms计数器计满信�
	wire nedge,podge;     //边沿检测结�下降沿、上升沿)
	reg [3:0] state;             //状态寄�
	// 亚稳态消�即：对外部输入的异步信号进行同步处理
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		key_in_a<=1'b0;
		key_in_b<=1'b0;
		end
	else
		begin
		key_in_a<=~key_in;
		key_in_b<=key_in_a;
		end
	end
	//边沿检测（判断按键是否按下或释放）
	//使用D触发器存储两个相邻时钟上升沿时外部输入信号（已经同步到系统时钟域中）的电平状�
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		key_tmp_a<=1'b0;
		key_tmp_b<=1'b0;
		end
	else
		begin
		key_tmp_a<=key_in_b;
		key_tmp_b<=key_tmp_a;
		end
	end
	//产生跳变沿信�
	assign nedge=(!key_tmp_a)&key_tmp_b;   //下降沿检�
	assign podge=key_tmp_a&(!key_tmp_b);   //上升沿检�
	// 20ms计数模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		cnt<=20'd0;
	else if(en_cnt)
		cnt<=cnt+1'b1;
	else
		cnt<=20'd0;
	end
	//20ms计数器计满信号产生模�
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		cnt_full<=1'b0;
	else if(cnt==cnt_figure)
		cnt_full<=1'b1;
	else 
		cnt_full<=1'b0;
	end
	
	//状态转移模�
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		state<=IDEA;
		en_cnt<=1'b0;
		key_flag<=1'b0;
		key_state<=1'b1;
		end
	else
		begin
		case(state)
		IDEA :
			begin
			key_flag<=1'b0;
			if(nedge)
				begin
				state<=FILTER1;
				en_cnt<=1'b1;
				end
			else
				state<=IDEA;
			end
		FILTER1 :
			begin
			if(cnt_full)
				begin
				state<=DOWN;
				key_flag<=1'b1;
				key_state<=1'b0;
				en_cnt<=1'b0;
				end
			else if(podge)
				begin
				state<=IDEA;
				en_cnt<=1'b0;
				end
			else
				state<=FILTER1;
			end
		
		DOWN :
			begin
			key_flag<=1'b0;
			if(podge)
				begin
				state<=FILTER2;
				en_cnt<=1'b1;
				end
			else
				state<=DOWN;
			end
		FILTER2 :
			begin
			if(cnt_full)
				begin
				state<=IDEA;
				key_flag<=1'b1;
				key_state<=1'b1;
				en_cnt<=1'b0;
				end
			else if(nedge)
				begin
				state<=DOWN;
				en_cnt<=1'b0;
				end
			else
				state<=FILTER2;
			end
		default:
			begin
			state<=IDEA;
			en_cnt<=1'b0;
			key_flag<=1'b0;
			key_state<=1'b1;
			end
		endcase
		end
	
	end


endmodule
