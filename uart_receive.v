`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:15 11/01/2019 
// Design Name: 
// Module Name:    uart_receive 
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
module uart_receive(
		mclk,
		rst_n,
		baud_set,
		rs232_rx,
		
		data_byte,
		uart_state,
		rx_done
    );
	input mclk;
	input rst_n;
	input rs232_rx;
	input [2:0] baud_set;
	
	output reg rx_done;
	output reg uart_state;
	output reg [7:0]data_byte;
	
	reg [8:0] bps_cntmax;  //分频计数最大值
	
	reg s0_rs232_rx,s1_rs232_rx;      //同步寄存器
	reg tmp0_rs232_rx,tmp1_rs232_rx;  //数据寄存器
	
	wire nedege;
	reg [2:0] start_wei,stop_wei;
	
	reg [3:0] r_data_byte [7:0];
	
	reg [8:0] bps_cnt;
	reg bps_mclk;
	
	reg [7:0] bps_cnt1;  //采样时钟计数器
	
	//对输入的数据进行同步处理
	
	always@(posedge mclk or negedge rst_n)   //同步寄存器，消除亚稳态
	begin
		if(~rst_n)
		begin
			s0_rs232_rx <= 1'b0;
			s1_rs232_rx <= 1'b0;
		end
		else 
		begin
			s0_rs232_rx <= rs232_rx;
			s1_rs232_rx <= s0_rs232_rx;
		end
	end
	
	always@(posedge mclk or negedge rst_n)   //数据寄存器
	begin
		if(~rst_n)
		begin
			tmp0_rs232_rx <= 1'b0;
			tmp1_rs232_rx <= 1'b0;
		end
		else 
		begin
			tmp0_rs232_rx <= s1_rs232_rx;
			tmp1_rs232_rx <= tmp0_rs232_rx;
		end
	end
	
	assign nedege = ~tmp0_rs232_rx && tmp1_rs232_rx;
	
	
	//波特率选择模块
	always@(posedge mclk or negedge rst_n)
	begin
		if(~rst_n)
			bps_cntmax <= 9'd325-1'b1;
		else 
		begin
			case(baud_set)
				0:bps_cntmax <= 9'd325-1'b1;   //9600
				1:bps_cntmax <= 9'd163-1'b1;   //19200
				2:bps_cntmax <= 9'd81-1'b1;   //38400
				3:bps_cntmax <= 9'd54-1'b1;    //57600
				4:bps_cntmax <= 9'd27-1'b1;    //115200
				default:bps_cntmax <= 9'd325-1'b1;
			endcase
		end
		
	end
	
	//采样时钟，频率为波特率时钟的16倍
	
	
	always@(posedge mclk or negedge rst_n)    
	begin
		if(~rst_n)
			bps_cnt <= 9'd0;
		else if(uart_state)
			begin
				if(bps_cnt==bps_cntmax)
					bps_cnt <= 9'd0;
				else 
					bps_cnt <= bps_cnt+1'b1;
			end
		else
			bps_cnt <= 9'd0;
	end
	
	always@(posedge mclk or negedge rst_n)  
	begin
		if(~rst_n)
			bps_mclk <= 1'b0;
		else if(bps_cnt==9'd1)
			bps_mclk <= 1'b1;
		else
			bps_mclk <= 1'b0;
	end
	
	
	
	always@(posedge mclk or negedge rst_n)
	begin
		if(~rst_n)
			bps_cnt1 <= 8'd0;
		else if(bps_cnt1==8'd159||(bps_cnt1==8'd12&&(start_wei>2))) //采样时钟计时器清零条件：1、计数器计满一个字节;2、起始位出错。 
			bps_cnt1 <= 8'd0;
		else if(bps_mclk==1)
			bps_cnt1 <= bps_cnt1+1'b1;
		else
			bps_cnt1 <= bps_cnt1;
			
	end
	
	//rx_done表示一次接收是否完成，rx_done为1，则表示接收完成
	always@(posedge mclk or negedge rst_n)
	begin
		if(~rst_n)
			rx_done <= 1'b0;
		else if(bps_cnt1==8'd159)
			rx_done <= 1'b1;
		else
			rx_done <=1'b0;
	end
	
	//接收模块的状态，uare_state为1，表示处于接收状态，反之处于空闲状态
	always@(posedge mclk or negedge rst_n)
	begin
		if(~rst_n)
			uart_state <= 1'b0;
		else if(nedege)
			uart_state <= 1'b1;
		else if(rx_done||(bps_cnt1==8'd12 && (start_wei>2)))
			uart_state <= 1'b0;
		else
			uart_state <= uart_state;
	end
	
	//对每一位的数据进行中间六次的采样，做和，若和大于3，则证明6次采样中1出现的次数大于3，既可以认为，此阶段为高电平，反之为低电平。
	always@(posedge mclk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			start_wei <= 3'd0;
			r_data_byte[0] <= 3'd0;
			r_data_byte[1] <= 3'd0;
			r_data_byte[2] <= 3'd0;
			r_data_byte[3] <= 3'd0;
			r_data_byte[4] <= 3'd0;
			r_data_byte[5] <= 3'd0;
			r_data_byte[6] <= 3'd0;
			r_data_byte[7] <= 3'd0;
			stop_wei  <= 3'd0;
		end
		else if(bps_mclk)
		begin
			case(bps_cnt1)
				0:	begin
						start_wei <= 3'd0;
						r_data_byte[0] <= 3'd0;
						r_data_byte[1] <= 3'd0;
						r_data_byte[2] <= 3'd0;
						r_data_byte[3] <= 3'd0;
						r_data_byte[4] <= 3'd0;
						r_data_byte[5] <= 3'd0;
						r_data_byte[6] <= 3'd0;
						r_data_byte[7] <= 3'd0;
						stop_wei  <= 3'd0;
					end
				6,7,8,9,10,11:start_wei <= start_wei + s1_rs232_rx;
				22,23,24,25,26,27:r_data_byte[0] <= r_data_byte[0] + s1_rs232_rx;
				38,39,40,41,42,43:r_data_byte[1] <= r_data_byte[1] + s1_rs232_rx;
				54,55,56,57,58,59:r_data_byte[2] <= r_data_byte[2] + s1_rs232_rx;
				70,71,72,73,74,75:r_data_byte[3] <= r_data_byte[3] + s1_rs232_rx;
				86,87,88,89,90,91:r_data_byte[4] <= r_data_byte[4] + s1_rs232_rx;
				102,103,104,105,106,107:r_data_byte[5] <= r_data_byte[5] + s1_rs232_rx;
				118,119,120,121,122,123:r_data_byte[6] <= r_data_byte[6] + s1_rs232_rx;
				134,135,136,137,138,139:r_data_byte[7] <= r_data_byte[7] + s1_rs232_rx;
				150,151,152,153,154,155:stop_wei <= stop_wei + s1_rs232_rx;
				default:	begin
								start_wei <= start_wei;
								r_data_byte[0] <= r_data_byte[0];
								r_data_byte[1] <= r_data_byte[1];
								r_data_byte[2] <= r_data_byte[2];
								r_data_byte[3] <= r_data_byte[3];
								r_data_byte[4] <= r_data_byte[4];
								r_data_byte[5] <= r_data_byte[5];
								r_data_byte[6] <= r_data_byte[6];
								r_data_byte[7] <= r_data_byte[7];
								stop_wei  <= stop_wei;
							end
			endcase
		end
	end
	
	
	//数据输出
	always@(posedge mclk or negedge rst_n)
	begin
		if(~rst_n)
			data_byte <= 8'd0;
		else if(bps_cnt1==8'd159)
		begin
			data_byte[0] <= (r_data_byte[0]>3'd3)? 1 : 0 ;
			data_byte[1] <= (r_data_byte[1]>3'd3)? 1 : 0 ;
			data_byte[2] <= (r_data_byte[2]>3'd3)? 1 : 0 ;
			data_byte[3] <= (r_data_byte[3]>3'd3)? 1 : 0 ;
			data_byte[4] <= (r_data_byte[4]>3'd3)? 1 : 0 ;
			data_byte[5] <= (r_data_byte[5]>3'd3)? 1 : 0 ;
			data_byte[6] <= (r_data_byte[6]>3'd3)? 1 : 0 ;
			data_byte[7] <= (r_data_byte[7]>3'd3)? 1 : 0 ;
		end
	end

endmodule