`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:17 10/15/2019 
// Design Name: 
// Module Name:    DHT11_mod 
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
module DHT11_mod(
	input 				clk,
	input 				rst_n,
	inout 				data,
	output 	reg 		data_rdy,			//ready??
	output 		[7:0] 	humidity_int,		//湿度整数
	output 		[7:0] 	humidity_float,		//湿度小数
	output 		[7:0] 	temperature_int,	//温度整数
	output 		[7:0] 	temperature_float	//温度小数
	
    ); 

	parameter 	DELAY_1S	=	25'd25_000_000;	//延迟 1s

		
	//-----------------------------------------
	//sample_en采样使能
	reg 	[24:0]	cnt_delay1s;
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_delay1s <= 25'd0;
		else if(cnt_delay1s == DELAY_1S - 1'b1)
			cnt_delay1s <= 25'd0;
		else 
			cnt_delay1s <= cnt_delay1s + 1'b1;
	end
	
	wire 	sample_en = (cnt_delay1s == DELAY_1S - 1'b1)? 1'b1: 1'b0;//温湿度采样使能
		
	//-----------------------------------------
	reg sample_en_tmp1,sample_en_tmp2;                             
	always @(posedge clk)                                      
	begin                                                                         
	sample_en_tmp1 <=  sample_en;                               
	sample_en_tmp2 <=  sample_en_tmp1;                          
	end                                                        
	
	wire sample_pulse = (~sample_en_tmp2) & sample_en_tmp1;//温湿度采样使能脉冲（上升沿检测）
	
	//---------------------------------------------------
	//数据上升沿检测
	reg data_tmp1,data_tmp2;                                    
	always @(posedge clk)                                     
	begin                                                     
	data_tmp1 <=  data;                                      
	data_tmp2 <=  data_tmp1;                                 
	end                                                       
															
	wire data_pulse = (~data_tmp2) & data_tmp1;//rising edge     
	
	
	
	////////////////////////////////////////////////////////////
	reg [3:0] state = 0;
	reg [25:0] power_up_cnt = 0;  //2^26 > 50e6，故大于1s
	
	reg [19:0] wait_18ms_cnt = 0;//2^20*20e-9 = 21ms > 18ms
	reg [10:0] wait_40us_cnt = 0;
	
	reg [39:0] get_data;
	reg [5:0] num = 0;//大于5*8
	reg data_reg = 1;
	reg link = 0;
	
	////////////////////////////////////////////////////
	//
	//	产生内部的一个DHT11的复位信号
	//
	////////////////////////////////////////////////////
	reg rst_n_inside;	//定义一个内部的复位信号
	
	reg [27:0] cnt;
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 28'd0;
		else if(cnt == 28'd90_000_000)
			cnt <= 28'd0;
		else 
			cnt <= cnt + 1'b1;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rst_n_inside <= 1'b0;
		else if(cnt <= 28'd45_000_000)
			rst_n_inside <= 1'b1;
		else 
			rst_n_inside <= 1'b0;			
	end
	
	////////////////////////////////////////////////////
	////////////////////////////////////////////////////
	
	always @(posedge clk or negedge rst_n_inside)               
	begin
		if(!rst_n_inside)
			state <= 0;
		else begin
			case(state)                      
				0  :      begin//上电后等待1s越过不稳定期
							link <= 0;
							data_reg <= 1;//总线空闲时为高电平
							power_up_cnt <= power_up_cnt + 1;
							if(power_up_cnt[25])      //等待1s左右时间
									//if(power_up_cnt[10]) //just for test
								begin
								power_up_cnt <= 0;
								state <= 1;
								end
						end                   
				1  :      begin               
							data_rdy <= 0;
							if(sample_pulse) //启动转换命令    
								begin
								wait_18ms_cnt <= 0;
								link <= 1;
								data_reg <= 0; //主机拉低总线18ms以上
								state <= 2; 
								end
						end
				2  :      begin                                                             
							wait_18ms_cnt <= wait_18ms_cnt + 1;
							if(wait_18ms_cnt[19])
								begin
								wait_18ms_cnt <= 0;
								wait_40us_cnt <= 0;
								link <= 0;      //高阻，然后等待应答信号
								data_reg <= 1;
								state <= 3; 
								end 
						end      
				3  :      begin                                           
							wait_40us_cnt <= wait_40us_cnt + 1;  
							if(wait_40us_cnt[10]) //延时等待40us  
								begin                 
								wait_40us_cnt <= 0; 
								state <= 4; 
								end
						end  
				4  :      begin                                                           
							if(data_pulse) //响应结束       
								begin                                    
								get_data <= 40'd0;
								num <= 0;
								state <= 5;                           
								end                                      
						end                                           
				5  :      begin                                    
							if(data_pulse)   //第一位数据中的上升沿，延时40us，如果为低则为0，否则为1                   
								begin          //因为0对应的高电平时间26us，1对应的高电平时间70us                     
								wait_40us_cnt <= 0;
								state <= 6;                      
								end                                 
						end
				6  :      begin                                                                          
							wait_40us_cnt <= wait_40us_cnt + 1;     
							if(wait_40us_cnt[10]) //延时等待40us    
								begin
								wait_40us_cnt <= 0;
								num <= num + 1;
								if(data)
									get_data <= {get_data[38:0],1'b1};                          
								else
											get_data <= {get_data[38:0],1'b0}; 
										if(num == 39)
											begin
												num <= 0;
												data_rdy <= 1;
												state <= 1;  
											end
										else
											state <= 5;  								 
								end      
						end
				default:  state <= 0; 
			endcase
		end
	end 
	//--------------------------------------------
	reg 	[7:0]	humidity_float_r = 8'd0;
	always @(posedge clk)begin	
		if(humidity_float_r == 0 && humidity_float_r == 8'h0a)
			humidity_float_r <= 8'h05;
		else 
			humidity_float_r <= temperature_float + 2; 
	end
	
	assign data  = link ? data_reg : 1'bz;//link 为1时，data作为输出，data作为输入为高阻态
	assign humidity_int    = get_data[39:32];

	assign 	humidity_float   = humidity_float_r;
	assign temperature_int = get_data[23:16];
	assign 	temperature_float = get_data[15:8];
				
	
endmodule
