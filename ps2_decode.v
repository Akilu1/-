`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/02 19:09:26
// Design Name: 
// Module Name: ps2_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ps2_decode(
	clk,rst_n,ps2_clk,ps2_data,ps2_out_data,ps2_done
    );
	input clk;
	input rst_n;
	input ps2_clk;
	input ps2_data;
	output reg [7:0]ps2_out_data;
	output reg ps2_done;    //读取到的数据标识位
	
	reg temporary_clk,temporary_data,net1,net2;
	wire negedge_signal;
	
	// 亚稳态消除,即：对外部输入的异步信号进行同步处理
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		temporary_clk<=1'b1;
		temporary_data<=1'b1;
		end
	else
		begin
		temporary_clk<=ps2_clk;
		temporary_data<=ps2_data;
		end
	end
	
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
	    net1<=1'b1;
		net2<=1'b1;
		end
	else
		begin
		net1<=temporary_clk;
		net2<=net1;
		end
	end
	assign negedge_signal = ((!net1)&net2)? 1'b1:1'b0;    //ps2_clk 下降沿信号检测
	
	reg[4:0]state;
	reg[7:0]data;
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)begin
			state <= 0;
			data <= 0;
			ps2_done <= 1'b0;
		end
		else 
		case(state)
		//等待第一个时钟下降沿开始
		0:if(negedge_signal)
		     begin 
			 state <= 1'b1;
			 end		
		   else 
		     state <= state;
		//第2·9个时钟下降沿数据
		1,2,3,4,5,6,7,8:			
			if(negedge_signal)
			begin
				data[state - 1'b1] <= temporary_data;
				state <= state + 1'b1;
				
			end
		//第10~11个时钟奇偶校验和停止位
		9,10:if(negedge_signal)
		         begin 
			     state <= state + 1'b1; 
			     end//test
			 else 
			     state <= state;
		//判断读到的数据是否是断码
		11:if(data==8'hf0)
		    state <= state + 2;
			else 
			begin
				ps2_done <= 1'b1;
				ps2_out_data <= data;
				state <= state + 1;
			end
		12:begin
				ps2_done <= 0;
				state <= 0;
			end
		//断码的第二帧开始
		13:if(negedge_signal)
		     state <= state + 1'b1;		
			else 
			 state <= state;
		//断码第二帧的数据
		14,15,16,17,18,19,20,21:
			if(negedge_signal)
			 begin
				data[state - 5'd14] <= ps2_data;
				state <= state + 1'b1;
			end
			else 
			begin
				data <= data;
			end		
		//断码第二帧的奇偶校验位和停止
		22,23:if(negedge_signal)
		      state <= state + 1'b1;
			  else 
			  state <= state;
		//done=1表示本次按键的数据已经得到
		24:begin
				//done <= 1'b1;
				state <= 0;
			end
		//读完一次按键按下的数据后再返回到最起始的位置		
		endcase
	end
endmodule
