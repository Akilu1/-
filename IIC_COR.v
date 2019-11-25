`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:52 02/17/2019 
// Design Name: 
// Module Name:    iic_ziji 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: inout
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IIC_COR(clk,rst_n,scl,addr_se_reg,addr_se_me,wr_en,re_en,num_reg_add,num_sent_data,num_rece_data,sda_data_out,data_out,con_sda,sda_i,sda_o,done
    );
	input clk,rst_n;                                   //50MHZ
	input [6:0]addr_se_me;                             //写目标器件地址
	input [12:0]addr_se_reg;                           //目标寄存器地址              
	input re_en;                                       //读使能
	input wr_en;                                       //写使能
	input [1:0]num_reg_add;                            //发送去的寄存器地址的长度（1或2）
	input [7:0]num_sent_data;                          //需要发送数据的数量
	input [7:0]num_rece_data;                          //需要接受数据的数量
	input sda_i;                                         //sda总线
	output sda_o;
	input [7:0]sda_data_out;                           //需要发送的8位数据
	output reg scl;                                        //scl输出
	output reg [7:0]data_out;                              //接受到的8位数据
    output reg con_sda;

	reg [9:0]cnt_scl;                                  //产生scl的计数器
	reg high_scl;                                      //作为scl高期间的点信号
	reg low_scl;                                       //作为scl低期间的点信号
	
	reg scl_en;                                        //表示scl产生中的信号
	output reg done;                                          //表示一次任务完全结束时的信号
	reg [7:0]now_num_sent_data;                        //当前正在发送第几个数据
	
	reg [1:0]now_num_add;                              //当前正在发送第几段寄存器数据
	reg [7:0]now_num_rece_data;                        //当前正在接受第几个数据
	reg ack;                                           //回应信号，内部，同时表示一个字节的数据发送完毕
	
	reg [4:0]cnt_ack;                                  //产生回应信号的计数器
	reg [3:0]state;                                    //储存当前状态的变量
	reg sda_out;                                       //输出的sda信号

	reg flag;                                          //标识当前是是否在发送/接受数据
	reg re_flag;                                       //标识是否处在读的状态中
	reg wr_flag;                                       //标识是否处在写的状态中
	
	reg [7:0]sda_sent_out;                             //发送的数据


	
	
	parameter IDLE=4'd0,                               //空闲
	          WR_START=4'B1,                           //产生起始状态
	          WR_ADDR_ME=4'd2,                         //写目标器件地址状态
			  WR_ADDR_REG=4'd3,                        //写目标器件寄存器地址状态
			  WR_DATA=4'd4,                            //写数据状态
			  RE_START=4'd5,                           //读时产生起始状态
			  RE_WR_ADDR=4'd6,                         //读时写目标期间状态
			  RE_DATA=4'd7,                            //读数据状态
			  STOP=4'd8;                               //结束状态
			  
			  
	always@(posedge clk or negedge rst_n)              //控制scl_en的模块
	begin
	    if(rst_n==0)
		begin
    		scl_en<=0;
		end
		else if(re_en|wr_en)
		begin
    		scl_en<=1;
		end
		else if(done)
		begin
    		scl_en<=0;
		end
		else
		    scl_en<=scl_en;
	end
		
	
    always@(posedge clk or negedge rst_n)              //scl产生计数器计数模块
    begin                                              
	    if(rst_n==0)                                   
		    cnt_scl<=0;                                
		else if(scl_en)
        begin
		    if(cnt_scl=='d1000)
			    cnt_scl<=0;
		    else
                cnt_scl<=cnt_scl+1'b1;  
		end
        else
            cnt_scl<=0;			
	end                                                
	
	always@(posedge clk or negedge rst_n)              //scl产生模块
	begin                                              
	    if(rst_n==0)                                   
		    scl<=1'b1;                                 
		else if(cnt_scl=='d500)                       
		    scl<=0;                                    
		else if(cnt_scl==1'b0)                         
		    scl<=1;                                    
		else                                           
		    scl<=scl;                                  
	end                                                

	always@(posedge clk or negedge rst_n)              //产生high_scl与low_scl的块
	begin
	    if(rst_n==0)
		begin
		    high_scl<=0;
		    low_scl<=0;
		end
		else if(cnt_scl=='d250)
		    high_scl<=1;
		else if(cnt_scl=='d750)
		    low_scl<=1;
		else
		begin
		    high_scl<=0;
			low_scl<=0;
		end
	end
	
	always@(posedge clk or negedge rst_n)              //cnt_ack的控制模块，只在需要有反应时才会产生反应计数 
	begin
	    if(rst_n==0)                                        
		    cnt_ack<=0;
		else if((state==WR_ADDR_ME)||
		        (state==WR_ADDR_REG)||
				(state==WR_DATA)||
				(state==RE_DATA)||
				(state==RE_WR_ADDR))
			begin
			    if(high_scl|low_scl)
				    begin
					    if(cnt_ack==5'd17)
						    cnt_ack<=0;
						else
						    cnt_ack<=cnt_ack+1'b1;
					end
				else
				    cnt_ack<=cnt_ack;
			end
		else
		    cnt_ack<=0;
	end

	always@(posedge clk or negedge rst_n)              //控制ack信号的模块
	begin
	    if(rst_n==0)
		    ack<=0;
		else if((high_scl)&&(cnt_ack==5'd16)&&(sda_i==0))  //最后一个sda==0才是确认收到回应信号的判定条件，其余为内部控制条件
	        ack<=1;
		else if((low_scl)&&(cnt_ack==5'd17))
	        ack<=0;
		else
		    ack<=ack;
	end
	
	always@(posedge clk or negedge rst_n)              //主机状态机
	begin
	    if(rst_n==0)
	    begin
		    state<=IDLE;
		    now_num_rece_data<=1;
			now_num_sent_data<=1;
			now_num_add<=1;
			done<=0;
			sda_out<=1;
			re_flag<=0;
			wr_flag<=0;
		end
		else
		begin
		    case(state)
			IDLE:
			    begin
		            state<=IDLE;
		            now_num_rece_data<=1;
			        now_num_sent_data<=1;
			        now_num_add<=1;
			        done<=0;
			        sda_out<=1;
					re_flag<=0;
					wr_flag<=0;
					flag<=0;
				    if(re_en)
					begin
    					state<=WR_START;
						re_flag<=1;
					end
					else if(wr_en)
					begin
					    state<=WR_START;
						wr_flag<=1;
				    end
					else
					    state<=IDLE;
				end
			WR_START:
			    begin
				    if(high_scl)
				    begin
					    sda_out<=0;
						state<=WR_START;
			        end
					else if(low_scl)
					begin
    					state<=WR_ADDR_ME;
						flag<=1;
						sda_sent_out<={addr_se_me,1'b0};
											
					end
					else 
                        state<=WR_START;		
                end						
			WR_ADDR_ME:
                begin
                if(flag==1)
	            begin
	                if((cnt_ack==16)&&high_scl)
	                begin  
    					flag<=0;
					end
	                else if(cnt_ack<8'd17)
					begin
				    sda_out<=sda_sent_out[7];
					    if(low_scl)
	                        sda_sent_out<={sda_sent_out[6:0],1'b0};
	                    else
	                        sda_sent_out<=sda_sent_out;
				     end
			    end
				else
			    begin
				    if(ack==1)
					begin

					    if(low_scl)
						begin
						    state<=WR_ADDR_REG;
							flag<=1;
							if(num_reg_add==2'b01)
							    sda_sent_out<=addr_se_reg[7:0];
							else
							    sda_sent_out<={3'b000,addr_se_reg[12:8]};
	                    end
					    else
						begin
						    state<=WR_ADDR_ME;
							
						end
					end
					else
					    state<=IDLE;
				end
				end
	        WR_ADDR_REG:
			    begin
				if(flag==1)
	            begin
	                if((cnt_ack==16)&&high_scl)
	                    flag<=0;
	                else if(cnt_ack<8'd17)
					begin

				    sda_out<=sda_sent_out[7];
					    if(low_scl)
	                        sda_sent_out<={sda_sent_out[6:0],1'b0};
	                    else
	                        sda_sent_out<=sda_sent_out;
				     end
			    end
				else
				begin
				    if(ack==1)
					begin
					    if(num_reg_add==now_num_add)
						begin
						    if(low_scl&&re_flag)                                
    								begin
									state<=RE_START;
									sda_out<=1;
								    end
						    else if(wr_flag&&low_scl)
								begin
    								state<=WR_DATA;
									sda_sent_out<=sda_data_out;
								    flag<=1;
									now_num_add<=1;
								end
							else
							    state<=WR_ADDR_REG;
						end
						else
						begin
						    if(low_scl)
							begin
     							sda_sent_out<=addr_se_reg[7:0];
								flag<=1;
								state<=WR_ADDR_REG;
								now_num_add<=now_num_add+1;
							end
							else
							    state<=WR_ADDR_REG;
						end
					end
					else
					    state<=IDLE;
				end
				end
			RE_START:
			    begin
				    if(high_scl)
					begin
					    sda_out<=0;
					    state<=RE_START;
					end
					else if(low_scl)
					begin
						state<=RE_WR_ADDR;
						flag<=1;
						sda_sent_out<={addr_se_me,1'b1};
					end
					else
					    state<=RE_START;
				end
			RE_WR_ADDR:
                begin
				if(flag==1)
	            begin
	                if((cnt_ack==16)&&high_scl)
	                    flag<=0;
	                else if(cnt_ack<8'd17)
					begin
				    sda_out<=sda_sent_out[7];
					    if(low_scl)
	                        sda_sent_out<={sda_sent_out[6:0],1'b0};
	                    else
	                        sda_sent_out<=sda_sent_out;
				     end
			    end
				else
				begin
				    if(ack==1)
					begin
					    if(low_scl)
						begin
						    state<=RE_DATA;
							flag<=1;
						end
						else
						    state<=RE_WR_ADDR;
                    end
					else
					    state<=IDLE;
			    end
			end
			RE_DATA:
			    begin
				if(flag==1)
				begin
					if((cnt_ack==15)&&low_scl)
				        flag<=0;
					else if((cnt_ack<8'd15))
					begin
					    if(high_scl)
						    data_out<={data_out[6:0],sda_i};
					    else 
					        data_out<=data_out;
				    end
				end
				else
			    begin
				    if(now_num_rece_data==num_rece_data)
					begin
					sda_out<=1;
					    if(low_scl)
						begin
    						state<=STOP;
						    sda_out<=0;
						end
						else
						    state<=RE_DATA;
					end
				    else
					begin
					sda_out<=0;
					    if(low_scl)
						begin
							now_num_rece_data<=now_num_rece_data+1;
							flag<=1;
							state<=RE_DATA;
					    end
						else
						begin
							state<=RE_DATA;
						end
					end
				end
			end
			WR_DATA:
			    begin
				if(flag==1)
	            begin
	                if((cnt_ack==16)&&high_scl)
	                    flag<=0;
	                else if(cnt_ack<8'd17)
					begin
				    sda_out<=sda_sent_out[7];
					    if(low_scl)
	                        sda_sent_out<={sda_sent_out[6:0],1'b0};
	                    else
	                        sda_sent_out<=sda_sent_out;
				     end
			    end
				else
				begin
				    if(ack==1)
				    begin
                        if(num_sent_data==now_num_sent_data)
                            begin
							    if(low_scl==1)
								begin
                            	    state<=STOP;
                                    sda_out<=0;
									now_num_sent_data<=1;
                                end
                                else
                                    state<=WR_DATA;
                            end
                        else
                        begin
                            if(low_scl)
                            begin							
							    now_num_sent_data<=now_num_sent_data+1;
							    sda_sent_out<=sda_data_out;
								state<=WR_DATA;
								flag<=1;
							end
							else
							    state<=WR_DATA;
						end
					end
					else
					    state<=IDLE;
				end
			end
		    STOP:
			    begin
				    if(high_scl)
					begin
					    sda_out<=1;
					    state<=IDLE;
					    done<=1;
					end
					else
					    state<=STOP;
				end
		    default:state<=IDLE;
			endcase
		end
	end

	assign sda_o=sda_out;
	
	always@(posedge clk or negedge rst_n)
	begin
	    if(rst_n==0)
		    con_sda<=0;
		else
		begin
     		if(state==IDLE)
			    con_sda<=0;
			else if(state==WR_START||state==STOP||state==RE_START)
                con_sda<=1;
            else if((state==WR_ADDR_ME)||(state==WR_ADDR_REG)||(state==WR_DATA)||(state==RE_WR_ADDR))
            begin
                if(cnt_ack>15)
                    con_sda<=0;
				else
				    con_sda<=1;
			end
			else if(state==RE_DATA)
			begin
			    if(cnt_ack<16)
				    con_sda<=0;
				else
				    con_sda<=1;
			end
			else
			    con_sda<=0;
		end
	end

	
endmodule
