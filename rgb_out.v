`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:32 12/18/2018 
// Design Name: 
// Module Name:    rgb_out
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
module rgb_out(
        R,
		G,
		B,
		cnt_h,
		cnt_l,
		clk,
		rst_n,
		xs_t_en,
		in_addr,
		in_long_data,
		yan_en,
		qi_en,
		xs_en,
		data_in,
		in_lo_data,
		s_shi,
		huo_en,
		s_ge,
		w_ge,
		w_shi,
		sec_hi,
		sec_lo,
		min_hi,
		min_lo,
		hour_hi,
		hour_lo
		
		);
	output reg [7:0]R,G,B;
	input [9:0]cnt_h,cnt_l;
	input [15:0]data_in;
	input huo_en;
	input clk;
	input rst_n;
	input xs_t_en;
	input xs_en;
	input [15:0]in_lo_data;
	input [3:0]s_shi;
	input [3:0]s_ge;
	input [3:0]w_shi;
    input [3:0]w_ge;
	input [4:0]in_addr;
	input [55:0]in_long_data;
	input yan_en,qi_en;
	input [3:0]sec_hi;
	input [3:0]sec_lo;
	input [3:0]min_hi;
	input [3:0]min_lo;
	input [3:0]hour_hi;
	input [3:0]hour_lo;
	
	
	
	wire [3:0]en;
	
	always@(*)
	begin
	    if(xs_en)
		begin
		    if(xs_t_en)
			begin
		        R={data_in[15:11],3'b000};
			    G={data_in[10:5],2'd0};
			    B={data_in[4:0],3'd0};
			end
			else
			begin
			    case(en)
			    4'b0001:begin
			    R='HFF;
			    G='HFF;
			    B='HFF;
			    end
			    4'b1000:begin
			    R='HFF;
			    G='H00;
			    B='H00;
			    end
			    4'b0100:begin
			    R='H00;
			    G='HFF;
			    B='H00;
			    end
			    default:begin
			    R='H00;
			    B='H00;
			    G='H00;
			    end
			    endcase
			end
		end
		else
		begin
			R='H00;
			B='H00;
			G='H00;
	    end
	end

	
	
	
	wire[9:0] cnt_h_t;
	wire[9:0] cnt_l_t;
	
	assign cnt_h_t=cnt_h-'d144;
	assign cnt_l_t=cnt_l-'d35;
	
	con_pic u_1(
    .in_cnt_x(cnt_h_t),
	.in_cnt_y(cnt_l_t),
	.rst_n(rst_n),
	.in_lo_data(in_lo_data),
	.en(en),
	.yan_en(yan_en),
	.qi_en(qi_en),
	.clk(clk),
	.in_long_data(in_long_data),
	.in_addr(in_addr),
	.huo_en(huo_en),
	.s_ge(s_ge),
	.s_shi(s_shi),
	.w_ge(w_ge),
	.w_shi(w_shi),
	.sec_hi(sec_hi),
	.sec_lo(sec_lo),
	.min_hi(min_hi),
	.min_lo(min_lo),
	.hour_hi(hour_hi),
	.hour_lo(hour_lo)
    );


    



endmodule
