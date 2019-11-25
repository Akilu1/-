`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:22 11/24/2018 
// Design Name: 
// Module Name:    rx_data_reserve_judge 
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
//接收数据储存判断模块
module rx_data_reserve_judge(
    clk,rst_n,parallel_data_rx,rx_down,yuyin_addr,yuyin_one_en);
	input clk;            //系统时钟信号
	input rst_n;          //复位
	input [7:0]parallel_data_rx;    //接收到的单字节并行数据
	input rx_down;           //一个字节接收完成信号
	output reg [1:0]yuyin_one_en;
	output reg[6:0]yuyin_addr;
	
	reg [4:0]current_state;     //状态机现态与次态定义。
	parameter S0=5'b00000,S1=5'b00001,S2=5'b00010,S3=5'b00011,S4=5'b00100,S5=5'b00101,S6=5'b00110,S7=5'b00111;     //状态机状态定义
	parameter S8=5'b01000,S9=5'b01001,S10=5'b01010,S11=5'b01011,S12=5'b01100,S13=5'b01101,S14=5'b01110,S15=5'b01111,S16=5'b10000;
	parameter S17=5'b10001,S18=5'b10010,S19=5'b10011,S20=5'b10100,S21=5'b10101,S22=5'b10110;
	//状态转移模块
    always@(posedge clk or negedge rst_n )
	begin
	if(!rst_n)
	begin
	current_state<=S0;
	yuyin_one_en<=2'b00;
	yuyin_addr<=7'b000_000_0;
	end
	
	else if(rx_down==1'b1)
	begin
	case(current_state)
	S0:begin
		if(parallel_data_rx=="X")
			begin
			yuyin_one_en<=2'b00;
			yuyin_addr<=yuyin_addr;
		    current_state<=S1;
			end
		else
			begin
			yuyin_one_en<=2'b00;
			yuyin_addr<=yuyin_addr;
			current_state<=S0;
			end
	   end
	S1:begin
		yuyin_one_en<=2'b00;
		if(parallel_data_rx=="P")
			begin
	
		    current_state<=S2;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S2:begin
		yuyin_one_en<=2'b00;
		if(parallel_data_rx=="S")
			begin
			
		    current_state<=S3;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S3:begin
		if(parallel_data_rx=="D")
			begin
			yuyin_one_en<=2'b01;
		    current_state<=S4;
			end
		else
			begin
			yuyin_one_en<=2'b00;
			current_state<=S0;
			end
	   end   
	S4:begin
		yuyin_one_en<=2'b00;
		if(parallel_data_rx=="S")
			begin
			
			yuyin_addr<=7'b000_000_0;
		    current_state<=S5;
			end
		else if(parallel_data_rx=="F")
			begin
			
			yuyin_addr<=7'b000_000_0;
		    current_state<=S14;
			end
		else
			begin
			
			yuyin_addr<=yuyin_addr;
			current_state<=S4;
			end
	   end
	S5:begin
		yuyin_one_en<=2'b00;
		if(parallel_data_rx=="A")
			begin
			
		    current_state<=S6;
			end
		else if(parallel_data_rx=="B")
			begin
			
		    current_state<=S8;
			end
		else if(parallel_data_rx=="C")
			begin
			
		    current_state<=S10;
			end
		else if(parallel_data_rx=="D")
			begin
			
		    current_state<=S12;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S6:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S7;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S7:begin
		if(parallel_data_rx=="1")       //送第一层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b001_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b001_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b001_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b001_100_0;
		    current_state<=S0;
			end
		else
			begin
			yuyin_addr<=yuyin_addr;
			yuyin_one_en<=2'b00;
			current_state<=S0;
			end
	   end
	S8:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S9;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S9:begin
		if(parallel_data_rx=="1")       //送第二层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b011_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b011_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b011_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b011_100_0;
		    current_state<=S0;
			end
		else
			begin
			
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
	S10:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S11;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S11:begin
		if(parallel_data_rx=="1")       //送第三层
			begin
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b101_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b101_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b101_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b101_100_0;
		    current_state<=S0;
			end
		else
			begin
			
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
    S12:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S13;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S13:begin
		if(parallel_data_rx=="1")       //送第四层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b111_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b111_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b111_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b111_100_0;
		    current_state<=S0;
			end
		else
			begin
			
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
	S14:begin
		yuyin_one_en<=2'b00;
		if(parallel_data_rx=="A")
			begin
			
		    current_state<=S15;
			end
		else if(parallel_data_rx=="B")
			begin
			
		    current_state<=S17;
			end
		else if(parallel_data_rx=="C")
			begin
			
		    current_state<=S19;
			end
		else if(parallel_data_rx=="D")
			begin
			
		    current_state<=S21;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S15:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S16;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S16:begin
		if(parallel_data_rx=="1")       //取第一层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b000_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b000_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b000_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b000_100_0;
		    current_state<=S0;
			end
		else
			begin
			
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
	S17:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S18;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S18:begin
		if(parallel_data_rx=="1")       //取第二层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b010_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b010_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b010_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b010_100_0;
		    current_state<=S0;
			end
		else
			begin
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
	S19:begin
		if(parallel_data_rx=="0")
			begin
		    current_state<=S20;
			end
		else
			begin
			current_state<=S0;
			end
	   end
	S20:begin
		if(parallel_data_rx=="1")       //取第三层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b100_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b100_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b100_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b100_100_0;
		    current_state<=S0;
			end
		else
			begin
			
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
    S21:begin
		if(parallel_data_rx=="0")
			begin
			
		    current_state<=S22;
			end
		else
			begin
			
			current_state<=S0;
			end
	   end
	S22:begin
		if(parallel_data_rx=="1")       //取第四层
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b110_001_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="2")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b110_010_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="3")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b110_011_0;
		    current_state<=S0;
			end
		else if(parallel_data_rx=="4")
			begin
			
			yuyin_one_en<=2'b10;
			yuyin_addr<=7'b110_100_0;
		    current_state<=S0;
			end
		else
			begin
			
			yuyin_one_en<=2'b00;
			yuyin_addr<=7'b000_000_0;
			current_state<=S0;
			end
	   end
	default:begin
		    current_state<=current_state;
		    yuyin_addr<=7'b000_000_0;
			yuyin_one_en<=2'b00;
		    end
	endcase
	end
	
	else
		begin
		current_state<=current_state;
		yuyin_addr<=yuyin_addr;
		end
	end



endmodule
