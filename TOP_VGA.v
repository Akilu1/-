`timescale 1ns/ 1ps
module top_vga
(
	input 	wire 		clk_24m,	
	input 	wire 		rst_n,			
	input 	wire 		IN_PCLK,	
	output 	wire 		O_XCLK,	
	input 	wire 		IN_OV_HS,	
	input 	wire 		IN_OV_VS,	
	output 	wire 		OV_MOD,	
	output 	wire 		OV_RST,	
	output 	wire 		OV_SCL,	
	inout 	wire 		OV_SDA,	
	input 	wire [7:0]	IN_OV_DATA,	
	input   wire  rst_n_ov,
	output 	wire [7:0] 	R,
	output 	wire [7:0] 	G,
	output 	wire [7:0] 	B,
	output 	wire 		vga_clk,
	output 	wire 		htb_en,
	output 	wire 		ltb_en,
	inout   dht11_data,
	output  wire eep_scl,
	inout   eep_sda,
	output wire gsm_tx,
	inout rtc_sda,
	output rtc_scl,
	output extend_shrink_direction,    
	output extend_shrink_pulse,        
	output rise_fall_direction,        
	output rise_fall_pulse,            
	output rotate_direction,           
	output rotate_pulse, 
	input ps2_clk,
	input ps2_data,        
	input chose_en,     		
	input save_or_fetch_key,
	input en,
    input en_u,en_d,en_l,en_r,
	output wire [7:0]flag,
	input yan_en,
	input qi_en,
	input huo_en,
	output [7:0]led,
	input gsm_rst,
	input 	[1:0]	disp,		
	input 	[3:0] 	row_data,	
	output 	[6:0] 	duan,		
	output 	[3:0] 	wei,		
	output 			dp,			
	output 	[3:0] 	col_data,	
	input rs_232_car_id,
	input key_yuyin,
	input yuyin_uart_data_rx,
	output yuyin_serial_data_tx
 );
wire 		clk_25m;
wire 		clk_4m;
wire        wr_en;
wire [15:0] ov_data;
wire [19:0] wr_addr;
wire [15:0] rd_addr;
wire 		ov_ready;
wire 		sda_oe;
wire 		sda;
wire 		sda_in;
wire 		scl;
wire wr_clk;
wire [10:0] hsync_cnt;
wire [10:0] vsync_cnt;
wire [15:0]	rd_data;	
wire [9:0]cnt_h;
wire [9:0]cnt_l;
wire [3:0]w_ge;
wire [3:0]w_shi;
wire [3:0]s_shi;
wire [3:0]s_ge;
wire eep_wr_en;
wire eep_wr_0_en;
wire [16:0]lo_data;
wire clk_50m;
wire [55:0]watch_data;
wire [55:0]long_data;
wire [3:0]sec_lo,sec_hi;
wire [3:0]min_lo,min_hi;
wire [3:0]hour_hi,hour_lo;
wire [4:0]ps2_addr;
wire [4:0]yuyin_out_addr;
wire [4:0]anjian_ps2_addr;
reg eeep_wr_0_en,eeep_wr_en;
wire rrrrr;
wire do_huo;
wire do_qi;
wire do_yan;
wire jingbao;
assign jingbao=do_huo|do_qi|do_yan;                    

reg huo_ena;
reg yan_ena;
reg qi_ena;
always@(posedge clk_24m or negedge rst_n)
begin
if(!rst_n)
	begin
	huo_ena<=1'b0;
	yan_ena<=1'b0;
	qi_ena<=1'b0;
	end
else
	begin
	huo_ena<=huo_en;
	yan_ena<=yan_en;
	qi_ena<=qi_en;
	end
end
assign do_huo=huo_ena&(~huo_en);
assign do_qi=qi_ena&(~qi_en);
assign do_yan=yan_ena&(~yan_en);

always@(*)
begin
    if(rst_n==0)
	    eeep_wr_0_en<=1;
	else
	begin
	    if(key_yuyin)
		    if(rrrrr)
			    eeep_wr_0_en<=en;
			else
			    eeep_wr_0_en<=1;
		else
		    if(save_or_fetch_key)
                eeep_wr_0_en<=en;
			else
			    eeep_wr_0_en<=1;
	end
end

always@(*)
begin
    if(rst_n==0)
	    eeep_wr_en<=1;
	else
	begin
	    if(key_yuyin)
		    if(~rrrrr)
			    eeep_wr_en<=en;
			else
			    eeep_wr_en<=1;
		else
		    if(!save_or_fetch_key)
                eeep_wr_en<=en;
			else
			    eeep_wr_en<=1;
	end
end
assign vga_clk=~clk_25m;
assign OV_SDA = (sda_oe == 1'b1) ? sda : 1'bz;
assign sda_in 	= OV_SDA;
assign OV_SCL = scl;
assign OV_MOD = 1'b0;
assign OV_RST 	= rst_n;
	wire [4:0]eeprom_addr;
	wire [4:0]eep_wr_addr;
	assign eeprom_addr = (key_yuyin=='d1)?yuyin_out_addr:anjian_ps2_addr;
	assign anjian_ps2_addr = (chose_en=='d1)?ps2_addr:eep_wr_addr;
addr_con u_con( 
.in_u(en_u),
.in_d(en_d),
.in_l(en_l),
.in_r(en_r),
.clk_24m(clk_24m),
.rst_n(rst_n),
.addr(eep_wr_addr)
);
wire vga_pwm;	
ip_pll ip_1(
	.refclk(clk_24m),		//24m
	.clk0_out(),		    //120m
	.clk1_out(clk_25m),		//25m
	.clk2_out(clk_4m),    //4m
	.clk3_out(clk_12m),
	.reset(~rst_n)
);
ov2640_set U_OV_SET
(
	.clk(clk_4m),
	.reset_n(rst_n),
	.sda_oe(sda_oe),
	.sda(sda),
	.sda_in(sda_in),
	.scl(scl)
);
VGA_CORE U_VGA_CORE(
    .clk_25mhz(clk_25m),
	.rst_n(rst_n),
	.cnt_h(cnt_h),
	.cnt_l(cnt_l),
	.htb_en(htb_en),
	.ltb_en(ltb_en),
	.xs_en(xs_en),                         
	.xs_t_en(xs_t_en),
	.rd_addr(rd_addr)
    );
rgb_out u_rgb_out(
    .xs_en(xs_en),
    .R(R),
	.G(G),
	.B(B),
	.cnt_h(cnt_h),
	.cnt_l(cnt_l),
	.clk(clk_25m),
	.rst_n(rst_n),
	.in_lo_data(lo_data[16:1]),
	.xs_t_en(xs_t_en),
	.data_in(rd_data),
	.w_ge(w_ge),
	.w_shi(w_shi),
	.s_ge(s_ge),
	.s_shi(s_shi),
	.in_long_data(watch_data),
	.in_addr(eeprom_addr),
	.yan_en(yan_en),
	.qi_en(qi_en),
	.huo_en(huo_en),
	.sec_hi(sec_hi),
	.sec_lo(sec_lo),
	.min_hi(min_hi),
	.min_lo(min_lo),
	.hour_hi(hour_hi),
	.hour_lo(hour_lo)
	);
ov2640_core u_3
(
	.clk		(clk_25m),
	.reset_n	(rst_n),
	.csi_xclk	(O_XCLK),
	.csi_pclk	(IN_PCLK),
	.csi_data	(IN_OV_DATA),
	.csi_vsync	(!IN_OV_VS),
	.csi_hsync	(IN_OV_HS),
	.data_out	(ov_data),
	.wrreq		(wr_en),
	.wrclk		(wr_clk),
	.wraddr		(wr_addr)
);
ram_ov2640 ip_2 
( 
	.dia		(ov_data), 
	.addra		(wr_addr[15:0]), 
	.cea		(wr_en), 
	.clka		(wr_clk	),
	.dob		(rd_data), 
	.addrb		(rd_addr), 
	.ceb		(xs_t_en),
	.clkb		(clk_25m)
);
top_DHT11 u_2(
    .clk_25MHZ(clk_25m),
	.rst_n(rst_n),
	.data(dht11_data),
	.temperature_decade(w_shi),
	.humidity_decade(s_shi),
	.humidity_one(s_ge),
	.temperature_one(w_ge)		
    );
ip_pll2 u_pll2(
        .refclk(clk_24m),
		.reset(~rst_n),
		.clk0_out(),
		.clk1_out(clk_50m)
	);	
key_filter_1s xd(     
    .clk(clk_24m),
	.rst_n(rst_n),
	.key_in(~eeep_wr_en),
	.key_flag(eep_wr_en),
	.key_state()
	);	
key_filter_1s xd1(      
    .clk(clk_24m),
	.rst_n(rst_n),
	.key_in(~eeep_wr_0_en),
	.key_flag(eep_wr_0_en),
	.key_state()
	);	
top_mess u_sent_mess(
    .tx(gsm_tx),
	.clk(clk_50m),
	.rst_n(rst_n&gsm_rst),
	.en(eep_wr_en),
	.qi_en(qi_en),
	.yan_en(yan_en),
	.huo_en(huo_en),
	.in_addr(eeprom_addr),
	.phone_number_buf({phone_number[43:40],phone_number[39:36],phone_number[35:32],phone_number[31:28],phone_number[27:24],phone_number[23:20],phone_number[19:16],phone_number[15:12],phone_number[11:8],phone_number[7:4],phone_number[3:0]})
    );
	wire 	[43:0] 	phone_number;	
	top_Matrix_Key U_top_Matrix_Key(
		.clk(clk_24m),
		.rst_n(rst_n),
		.disp(disp),
		.row_data(row_data),	
		.duan(duan),
		.wei(wei),
		.dp(dp),
		.col_data(col_data),
		.phone_number(phone_number)
    );
	top_serial_receive u_rx_car_id(
	.clk(clk_50m),		
	.rst_n(rst_n),		
	.rs232_rx(rs_232_car_id),	
	.chepai_data(long_data)
);
top_RTC u_rtc(
    .clk(clk_50m),
	.rst_n(rst_n),
	.sda(rtc_sda),
	.scl(rtc_scl),
	.out_hout_lo(hour_lo),
	.out_hout_hi(hour_hi),
	.out_sec_lo(sec_lo),
	.out_sec_hi(sec_hi),
	.out_min_lo(min_lo),
	.out_min_hi(min_hi)
    );
	top_eeprom u_eeprom(
    .clk(clk_24m),
	.rst_n(rst_n),
	.sda(eep_sda),
	.scl(eep_scl),
	.lo_data(lo_data),
	.in_addr(eeprom_addr),
	.watch_data(watch_data),
	.in_wr(eep_wr_en),   
	.in_wr_0(eep_wr_0_en),
	.long_data(long_data),
	.flag(flag)
    );
	main_control u_mot_run(
    .clk(clk_24m),
	.rst_n(rst_n),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.ps2_en(chose_en),
	.ps2_key1(chose_en),
	.save_or_fetch_key(save_or_fetch_key),
	.key_in1(eeep_wr_en),  
	.key_in2(eeep_wr_0_en),
	.extend_shrink_direction(extend_shrink_direction),
	.extend_shrink_pulse(extend_shrink_pulse),
	.rise_fall_direction(rise_fall_direction),
	.rise_fall_pulse(rise_fall_pulse),
	.rotate_direction(rotate_direction),
	.rotate_pulse(rotate_pulse),
	.led(led[6:0]),
	.in_addr(eep_wr_addr),
	.out_addr(ps2_addr),
	.yuyin_out_addr(yuyin_out_addr),
	.key_yuyin(key_yuyin),
	.yuyin_uart_data_rx(yuyin_uart_data_rx),
	.yuyin_serial_data_tx(yuyin_serial_data_tx),
	.rrrrr(rrrrr),
	.jingbao(jingbao)
    );
endmodule
