`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:37 03/05/2019 
// Design Name: 
// Module Name:    top_tb_iic 
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
module top_eeprom(
    clk,
	rst_n,
	sda,
	scl,
	lo_data,
	in_addr,
	in_wr,
	in_wr_0,
	flag,
	long_data,
	watch_data
    );
	input clk;
	input in_wr;
	input in_wr_0;
	input rst_n;
	input [7:0]in_addr;
	input [55:0]long_data;

	output reg [55:0]watch_data;

	
	
    output reg [16:0]lo_data;
	output scl;
	
	inout sda;	

	wire [7:0]o_data;
    wire done;
	wire sda_out;
	wire sda_in;
	wire con_sda;
	
	output  [7:0]flag;

	assign flag=watch_data[7:0];
	

	
	reg [63:0]reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16;
	
	reg [63:0]reg_mid_data;
	
	
	
	reg [4:0]reg_addr_wr;
	reg [3:0]now_addr_wr;
	reg lay_in_wr;
	reg [12:0]re_addr;
    reg wr_en,re_en;
	reg [7:0]wr_data;
	reg [12:0]wr_addr,addr;
	reg [31:0]count;
	reg start_count;	
	reg wait_en;
	
	reg [3:0]now_addr;     //表示正在读第几个车牌�
	reg [4:0]reg_addr;     //最终送到eeprom的地址
	reg [5:0]state;  
	
	parameter IDLE=18,
	          WR=19,
			  RE=20,
			  READY=21,
			  INIT=22;
			  
			  
	assign sda=con_sda?sda_out:1'bz;
	assign sda_in=con_sda?1'b1:sda;
	
	
	always@(*)
	begin
	    case(in_addr)
		'd1:watch_data=reg1[63:8];
		'd2:watch_data=reg2[63:8];
		'd3:watch_data=reg3[63:8];
		'd4:watch_data=reg4[63:8];
		'd5:watch_data=reg5[63:8];
		'd6:watch_data=reg6[63:8];
		'd7:watch_data=reg7[63:8];
		'd8:watch_data=reg8[63:8];
		'd9:watch_data=reg9[63:8];
		'd10:watch_data=reg10[63:8];
		'd11:watch_data=reg11[63:8];
		'd12:watch_data=reg12[63:8];
		'd13:watch_data=reg13[63:8];
		'd14:watch_data=reg14[63:8];
		'd15:watch_data=reg15[63:8];
		'd16:watch_data=reg16[63:8];
		default:watch_data=reg1[63:8];
		endcase
	end
	
	

	
	always@(posedge clk or negedge rst_n)
	begin
	    if(rst_n==0)
		begin
    		count<=0;
			wait_en<=0;
		end
		else if(start_count)
		begin
		    if(count=='d200_000)
			begin
    			count<=0;
				wait_en<=1;
			end
			else
			begin
			count<=count+'d1;
			wait_en<=0;
		    end
		end
		else
		begin
		    wait_en<=0;
            count<=0;
		end
    end			
	
	
	reg done_r,done_rr;
	always@(posedge clk or negedge rst_n)
	begin
	    if(rst_n==0)
		begin
		    done_r<=0;
			done_rr<=0;
		end
		else
		begin
		    done_r<=done;
			done_rr<=done_r;
		end
	end
	


	always@(posedge clk or negedge rst_n)
	begin
	    if(rst_n==0)
		begin
		    state<=IDLE;
			wr_addr<='hff;
			wr_data<=8'd01;
			re_addr<=13'd1;
			reg_addr_wr<=1;
			start_count<=0;
			lo_data<=0;
			wr_en<=0;
		    reg_addr<=1;    //正在操作第几个库的车牌�
			re_en<=0;
			now_addr<=0;
			now_addr_wr<=0;
			reg1<=0;
			reg2<=0;
			reg3<=0;
			reg4<=0;
			reg5<=0;
			reg6<=0;
			reg7<=0;
			reg8<=0;
			reg9<=0;
			reg10<=0;
			reg11<=0;
			reg12<=0;
			reg13<=0;
			reg14<=0;
			reg15<=0;
			reg16<=0;
		end
		else
		begin
		    case(state)
			IDLE:begin
			    state<=INIT;
                re_addr<='d1;
				reg_addr<='d1;
				wr_en<=0;
				now_addr<='d0;
				re_en<=1;
				lo_data<=lo_data;
			end
			INIT:begin
			    if(done_rr)
			    begin
				    start_count<=1;
					case(reg_addr)
					'd1:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg1<={reg1[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg1<={reg1[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
							now_addr<=now_addr+'d1;
						end
                    end
					'd2:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;
							

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg2<={reg2[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg2<={reg2[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd3:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg3<={reg3[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg3<={reg3[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd4:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg4<={reg4[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg4<={reg4[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd5:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg5<={reg5[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg5<={reg5[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd6:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg6<={reg6[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg6<={reg6[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd7:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg7<={reg7[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg7<={reg7[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd8:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg8<={reg8[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg8<={reg8[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd9:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg9<={reg9[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg9<={reg9[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd10:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg10<={reg10[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg10<={reg10[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd11:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					   else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg11<={reg11[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg11<={reg11[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd12:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg12<={reg12[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg12<={reg12[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd13:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg13<={reg13[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg13<={reg13[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd14:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg14<={reg14[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg14<={reg14[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd15:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg15<={reg15[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg15<={reg15[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
					'd16:begin
					    if(now_addr==0)
					    begin
					        lo_data[reg_addr]<=o_data[7];
							re_addr<=reg_addr*'d10+now_addr+'d20;
					        now_addr<=now_addr+1;

					    end
					    else if(now_addr==8)
					    begin
				            now_addr<=0;
							reg16<={reg16[55:0],o_data};
					        reg_addr<=reg_addr+'d1;
							re_addr<=reg_addr+'d1;
					    end
					    else
					    begin
							reg16<={reg16[55:0],o_data};
							re_addr<=reg_addr*'d10+now_addr+'d20;
						    now_addr<=now_addr+'d1;
						end
                    end
				    default:;
					endcase
				end
				else if(wait_en)
				begin
				    if(reg_addr=='d17)         //INIT DONE
					begin
						state<=READY;
					end
				    else
			        begin
				        re_en<=1;
					    start_count<=0;
				    end
                end				
			    else
			    begin
				    wr_en<=0;
					now_addr<=now_addr;
					reg_addr<=reg_addr;
			        re_addr<=re_addr;
					start_count<=start_count;
				    re_en<=0;
					state<=INIT;
			    end
			end
			WR:begin
			    if(done_rr)
			    begin
				    start_count<=1;
					now_addr_wr<=now_addr_wr+1;
					wr_addr<=reg_addr_wr*'d10+now_addr_wr+'d20;
					wr_data<=reg_mid_data[63:56];
					reg_mid_data<={reg_mid_data[55:0],8'd0};			
				end
				else if(wait_en)
				begin
				    if(now_addr_wr==8)
				    begin
					    re_addr<='d1;
						reg_addr<='d1;
						now_addr<='d0;
					    re_en<=1;
				        wr_en<=0;
					    state<=INIT;
					    start_count<=0;
					end
					else
					begin
					    wr_en<=1;
						start_count<=0;
					end
				end
				else
				begin
				    state<=WR;
					re_en<=0;
					wr_en<=0;
				end
			end
		    READY:begin
			    if(in_wr)
				begin
				    reg_mid_data<={long_data,8'd0};
				    wr_en<=1;
					now_addr_wr<=0;
					wr_data<='h80;
					wr_addr<=in_addr;
					reg_addr_wr<=in_addr;
					state<=WR;
				end
				else if(in_wr_0)
				begin
				    reg_mid_data<='d0;
				    wr_en<=1;
					now_addr_wr<=0;
					wr_data<='h00;
					wr_addr<=in_addr;
					reg_addr_wr<=in_addr;
					state<=WR;
				end
				else
				begin
				    re_en<=0;
					wr_en<=0;
					wr_addr<='hff;
					re_addr<='d1;
					wr_data<=0;
			        state<=READY;
					start_count<=0;
                end
			end
			default:state<=IDLE;
			endcase
		end
	end
	
	
    always@(*)
	begin
	    case(state)
		    IDLE:addr=13'd1;
			INIT:addr=re_addr;
		    WR:addr=wr_addr;
		    RE:addr=re_addr;
		    READY:addr=13'd1;
		default:;
		endcase
	end
	
	
	IIC_CORE u0(
	.clk(clk),
	.rst_n(rst_n),
	.scl(scl),
	.addr_se_reg(addr),
	.addr_se_me(7'b1010000),
	.wr_en(wr_en),
	.re_en(re_en),
	.num_reg_add('b1),
	.num_sent_data('b1),
	.num_rece_data('b1),
	.sda_data_out(wr_data),
	.data_out(o_data),
	.sda_o(sda_out),
	.sda_i(sda_in),
	.con_sda(con_sda),
	.done(done)
    );


endmodule
