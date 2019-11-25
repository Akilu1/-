`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:57 11/24/2018 
// Design Name: 
// Module Name:    uart_byte_rx 
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
//单字节数据接收模块（实际工程）
module uartuart_byte_rx(
    rst_n, clk,uart_data_rx,parallel_data_rx,rx_down);
	input rst_n;               //复位
	input clk;                //系统时钟
	input uart_data_rx;                   //输入的串行数据
	output reg [7:0]parallel_data_rx;     //输出并行数据
	output reg rx_down;         //一个字节接收完成信号
	
	reg s1_uart_data_rx,s2_uart_data_rx;       //异步信号进行同步处理寄存器
	reg tmp_a_uart_data_rx,tmp_b_uart_data_rx;       //边沿检测寄存器
	reg[8:0]bps_count;      //产生波特率的计数器
	reg uart_rx_state;      //接收数据状态
	reg bps_clk;            //波特率（9600/16）时钟信号
	reg[7:0]bps_clk_count;     //波特率时钟计数（159）
	wire nedge;              //下降沿检测（开始接收）       
	
	reg[2:0]temporary_reserve[7:0];                    //暂时储存读取的并行数据，temporary：临时的、暂时的
	reg[3:0]start_receive,end_receive;                 //暂时储存读取的开始接收和接收完成信号
	parameter BPSBPS=9'd156;           //波特率计数最大值
	//parameter BPSBPS=13'd5;
	
	// 亚稳态消除,即：对外部输入的异步信号进行同步处理
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		s1_uart_data_rx<=1'b0;
		s2_uart_data_rx<=1'b0;
		end
	else
		begin
		s1_uart_data_rx<=uart_data_rx;
		s2_uart_data_rx<=s1_uart_data_rx;
		end
	end
	//边沿检测（判断按键是否按下或释放）
	//使用D触发器存储两个相邻时钟上升沿时外部输入信号（已经同步到系统时钟域中）的电平状态
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		tmp_a_uart_data_rx<=1'b0;
		tmp_b_uart_data_rx<=1'b0;
		end
	else
		begin
		tmp_a_uart_data_rx<=s1_uart_data_rx;
		tmp_b_uart_data_rx<=tmp_a_uart_data_rx;
		end
	end
	
	//产生跳变沿信号
	assign nedge=(!tmp_a_uart_data_rx)&tmp_b_uart_data_rx;   //下降沿检测
	//发送状态判断模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
	    uart_rx_state<=1'b0;
	else if(nedge)
		uart_rx_state<=1'b1;
	else if(rx_down|bps_clk_count==8'd159)
		uart_rx_state<=1'b0;
	else
		uart_rx_state<=uart_rx_state;
	end
	
	//分频计数模块（9600/16bps）
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		bps_count<=9'd0;
	else if(uart_rx_state==1'b1)
	begin
		if(bps_count==BPSBPS)
			bps_count<=9'd0;
		else
			bps_count<=bps_count+1'b1;
	end
	else
		bps_count<=9'd0;
	end
	
	// 波特率信号产生模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		bps_clk<=1'b0;
	else if(bps_count==9'd1)
		bps_clk<=1'b1;
	else
		bps_clk<=1'b0;
	end
	
	// 检测次数计数（159）
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		bps_clk_count<=8'd0;
	else if(bps_clk_count==8'd159)       //发送数据8位+起始位+停止位，共10位，去掉0，用1~10
		bps_clk_count<=4'b0;
	else if(bps_clk)
		bps_clk_count<=bps_clk_count+1'b1;
	else
		bps_clk_count<=bps_clk_count;
	end
	
	//接收完成信号产生模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		rx_down<=1'b0;
	else if(bps_clk_count==8'd159)
		rx_down<=1'b1;
	else 
		rx_down<=1'b0;
	end
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
	begin
	start_receive<=3'd0;
	temporary_reserve[0]<=3'b0;
	temporary_reserve[1]<=3'b0;
	temporary_reserve[2]<=3'b0;
	temporary_reserve[3]<=3'b0;
	temporary_reserve[4]<=3'b0;
	temporary_reserve[5]<=3'b0;
	temporary_reserve[6]<=3'b0;
	temporary_reserve[7]<=3'b0;
	end_receive<=3'd0;
	end
	else if(bps_clk)
		case(bps_clk_count)
		8'd0:
		     begin
	         start_receive<=3'd0;
	         temporary_reserve[0]<=3'b0;
	         temporary_reserve[1]<=3'b0;
	         temporary_reserve[2]<=3'b0;
	         temporary_reserve[3]<=3'b0;
	         temporary_reserve[4]<=3'b0;
	         temporary_reserve[5]<=3'b0;
	         temporary_reserve[6]<=3'b0;
	         temporary_reserve[7]<=3'b0;
	         end_receive<=3'd0;
	         end
		8'd6,8'd7,8'd8,8'd9,8'd10,8'd11:start_receive<=start_receive+s2_uart_data_rx;
		8'd22,8'd23,8'd24,8'd25,8'd26,8'd27:temporary_reserve[0]<=temporary_reserve[0]+s2_uart_data_rx;
		8'd38,8'd39,8'd40,8'd41,8'd42,8'd43:temporary_reserve[1]<=temporary_reserve[1]+s2_uart_data_rx;
		8'd54,8'd55,8'd56,8'd57,8'd58,8'd59:temporary_reserve[2]<=temporary_reserve[2]+s2_uart_data_rx;
		8'd70,8'd71,8'd72,8'd73,8'd74,8'd75:temporary_reserve[3]<=temporary_reserve[3]+s2_uart_data_rx;
		8'd86,8'd87,8'd88,8'd89,8'd90,8'd91:temporary_reserve[4]<=temporary_reserve[4]+s2_uart_data_rx;
		8'd102,8'd103,8'd104,8'd105,8'd106,8'd107:temporary_reserve[5]<=temporary_reserve[5]+s2_uart_data_rx;
		8'd118,8'd119,8'd120,8'd121,8'd122,8'd123:temporary_reserve[6]<=temporary_reserve[6]+s2_uart_data_rx;
		8'd134,8'd135,8'd136,8'd137,8'd138,8'd139:temporary_reserve[7]<=temporary_reserve[7]+s2_uart_data_rx;
		8'd150,8'd151,8'd152,8'd153,8'd154,8'd155:end_receive<=end_receive+s2_uart_data_rx;
		default:
			begin
			start_receive<=start_receive;
	        temporary_reserve[0]<=temporary_reserve[0];
	        temporary_reserve[1]<=temporary_reserve[1];
	        temporary_reserve[2]<=temporary_reserve[2];
	        temporary_reserve[3]<=temporary_reserve[3];
	        temporary_reserve[4]<=temporary_reserve[4];
	        temporary_reserve[5]<=temporary_reserve[5];
	        temporary_reserve[6]<=temporary_reserve[6];
	        temporary_reserve[7]<=temporary_reserve[7];
	        end_receive<=end_receive;
	        end
		endcase
	        else
		    begin
		    start_receive<=start_receive;
	        temporary_reserve[0]<=temporary_reserve[0];
	        temporary_reserve[1]<=temporary_reserve[1];
	        temporary_reserve[2]<=temporary_reserve[2];
	        temporary_reserve[3]<=temporary_reserve[3];
	        temporary_reserve[4]<=temporary_reserve[4];
	        temporary_reserve[5]<=temporary_reserve[5];
	        temporary_reserve[6]<=temporary_reserve[6];
	        temporary_reserve[7]<=temporary_reserve[7];
	        end_receive<=end_receive;
	        end
	end
	//数据读取模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
	    parallel_data_rx<=8'd0;
	else if(bps_clk_count==8'd159)
	    begin
	    parallel_data_rx[0]<=temporary_reserve[0][2];
	    parallel_data_rx[1]<=temporary_reserve[1][2];
	    parallel_data_rx[2]<=temporary_reserve[2][2];
	    parallel_data_rx[3]<=temporary_reserve[3][2];
	    parallel_data_rx[4]<=temporary_reserve[4][2];
	    parallel_data_rx[5]<=temporary_reserve[5][2];
	    parallel_data_rx[6]<=temporary_reserve[6][2];
	    parallel_data_rx[7]<=temporary_reserve[7][2];
	    end
	else
	    begin
	    parallel_data_rx[0]<=parallel_data_rx[0];
	    parallel_data_rx[1]<=parallel_data_rx[1];
	    parallel_data_rx[2]<=parallel_data_rx[2];
	    parallel_data_rx[3]<=parallel_data_rx[3];
	    parallel_data_rx[4]<=parallel_data_rx[4];
	    parallel_data_rx[5]<=parallel_data_rx[5];
	    parallel_data_rx[6]<=parallel_data_rx[6];
	    parallel_data_rx[7]<=parallel_data_rx[7];
	    end
	end


endmodule
