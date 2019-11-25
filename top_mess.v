`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:28 10/30/2019 
// Design Name: 
// Module Name:    top 
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
module top_mess(
    tx,
	clk,
	rst_n,
	en,
	qi_en,
	yan_en,
	huo_en,
	in_addr,
	phone_number_buf
    );
	input clk,rst_n,en,yan_en,huo_en,qi_en;
	input [4:0]in_addr;
	input [43:0]phone_number_buf;
	output tx;
	wire do_yan,do_huo,do_qi;
	
	reg [383:0]TEXT_buf;
	wire [87:0]Adm_phone,cus_phone;
	reg [87:0]phone_number;
	wire [383:0]TEXT_save;
	wire [0:383]TEXT_fire,TEXT_gas,TEXT_smoke;
	wire [7:0]wr_data;
	wire up_en;
	wire wr_en;
	wire tx_done;
	reg [7:0]f_num,r_num;
	reg en_r;
	reg lay_en,lay_huo,lay_qi,lay_yan;

	assign up_en=~lay_en&en;
	
	assign do_huo=~huo_en&lay_huo;
	
	assign do_yan=~yan_en&lay_yan;
	
	assign do_qi=~qi_en&lay_qi;
	       //                  num       f     e  h  t     n  o    num            m  o  o  r     n  i     d  e  r  o  t  s  // n  e  e  b  // s  a  h  // t  c  e  j  b  o  // r  u  o  Y
	assign TEXT_save  ={8'h20,f_num,72'h66_20_65_68_74_20_6e_6f_20,r_num,288'h20_6d_6f_6f_72_20_6e_69_20_64_65_72_6f_74_73_20_6e_65_65_62_20_73_61_68_20_74_63_65_6a_62_6f_20_72_75_6f_59};
	//                   // Warning: fire detected ,please have a check
	assign TEXT_fire =  384'h20_20_20_20_20_6B_63_65_68_63_20_61_20_65_76_61_68_20_65_73_61_65_6C_70_2C_20_64_65_74_63_65_74_65_64_20_65_72_69_66_20_3A_67_6E_69_6E_72_61_57   ;
	                     // Warning: toxic gas detected ,please check
	assign TEXT_gas =   384'h20_20_20_20_20_20_20_6B_63_65_68_63_20_65_73_61_65_6C_70_2C_20_64_65_74_63_65_74_65_64_20_73_61_67_20_63_69_78_6F_74_20_3A_67_6E_69_6E_72_61_57  ;
	                     // Warning: smoke detected,please have a check
	assign TEXT_smoke = 384'h20_20_20_20_6B_63_65_68_63_20_61_20_65_76_61_68_20_65_73_61_65_6C_70_2C_20_64_65_74_63_65_74_65_64_20_65_6B_6F_6D_73_20_3A_67_6E_69_6E_72_61_57  ;
	
	assign Adm_phone=88'h32_39_35_34_35_39_32_30_38_35_31;
	
	assign cus_phone={4'h3,phone_number_buf[43:40],4'h3,phone_number_buf[39:36],4'h3,phone_number_buf[35:32],4'h3,phone_number_buf[31:28],4'h3,phone_number_buf[27:24],4'h3,phone_number_buf[23:20],4'h3,phone_number_buf[19:16],4'h3,phone_number_buf[15:12],4'h3,phone_number_buf[11:8],4'h3,phone_number_buf[7:4],4'h3,phone_number_buf[3:0]};
	
	always@(*)
	begin
	    case(in_addr)
		0:begin
		    f_num=0;
			r_num=0;
		end
		1:begin
		    f_num='h31;
			r_num='h31;
		end
		2:begin
		    f_num='h31;
			r_num='h32;
		end
		3:begin
		    f_num='h31;
			r_num='h33;
		end       
		4:begin   
		    f_num='h31;
			r_num='h34;
		end
		5:begin
		    f_num='h32;
			r_num='h31;
		end       
		6:begin   
		    f_num='h32;
			r_num='h32;
		end
		7:begin
		    f_num='h32;
			r_num='h33;
		end       
		8:begin   
		    f_num='h32;
			r_num='h34;
		end
		9:begin
		    f_num='h33;
			r_num='h31;
		end       
		10:begin  
		    f_num='h33;
			r_num='h32;
		end
		11:begin
		    f_num='h33;
			r_num='h33;
		end       
		12:begin  
		    f_num='h33;
			r_num='h34;
		end
		13:begin
		    f_num='h34;
			r_num='h31;
		end       
		14:begin  
		    f_num='h34;
			r_num='h32;
		end
		15:begin
		    f_num='h34;
			r_num='h33;
		end       
		16:begin  
		    f_num='h34;
			r_num='h34;
		end
		default:begin
		    f_num=0;
			r_num=0;
		end
		endcase
	end
		
	
	
	
	always@(posedge clk)
	begin
	    if(up_en)
		begin
    		TEXT_buf<=TEXT_save;
			phone_number<=cus_phone;
		end
		else if(do_huo)
		begin
		    TEXT_buf<=TEXT_fire;
			phone_number<=Adm_phone;
		end
		else if(do_qi)
		begin
    		TEXT_buf<=TEXT_gas;
		    phone_number<=Adm_phone;
		end
		else if(do_yan)
		begin
    		TEXT_buf<=TEXT_smoke;
			phone_number<=Adm_phone;
		end
		else
		    TEXT_buf<=TEXT_buf;
	end
	
	always@(posedge clk or negedge rst_n)
	begin
	    if(rst_n==0)
		begin
    		lay_en<=0;
			lay_huo<=0;
			lay_yan<=0;
			lay_qi<=0;
		end
		else
		begin
    		lay_en<=en;
			lay_huo<=huo_en;
			lay_qi<=qi_en;
			lay_yan<=yan_en;
		end
	end
	
	always@(posedge clk)
	begin
	    en_r<=(up_en|do_huo|do_qi|do_yan);
	end
	
	uart_tx_mess u_uart_tx(
	.Clk(clk),       //50M时钟输入
	.Rst_n(rst_n),     //模块复位
	.data_byte(wr_data), //待传�bit数据
	.send_en(wr_en),   //发送使�
	.baud_set('d4),  //波特率设�
	
	.Rs232_Tx(tx),  //Rs232输出信号
	.Tx_Done(tx_done),   //一次发送数据完成标�
	.uart_state() //发送数据状�
);
    gsm u_gsm(
	.tx_enable(wr_en),
	.tx_data(wr_data),   
	.clk(clk),
	.phone_number_buf(phone_number),
	.rst(rst_n),
	.TEXT_buf(TEXT_buf),
	.tx_done(tx_done),		//该输入只维持一个时钟周�
	.mess_phone_number_prepared_enable(en_r)  //一个段时间的高电平（源自点击确认键�
	);
	





endmodule
