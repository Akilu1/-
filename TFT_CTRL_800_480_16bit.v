/*============================================================================
*
*  LOGIC CORE:          TFT驱动模块		
*  MODULE NAME:         TFT_CTRL()
*  COMPANY:             芯航线电子工作室
*                       http://xiaomeige.taobao.com
*	author:					小梅�
*	author QQ Group�72607506
*  REVISION HISTORY:  
*
*    Revision 1.0  01/01/2016     Description: Initial Release.
*
*  FUNCTIONAL DESCRIPTION:
===========================================================================*/
module TFT_CTRL_800_480_16bit(
	Clk33M,	//系统输入时钟25MHZ
	Rst_n,	//复位输入，低电平复位
	data_in,	//待显示数�
	hcount,		//TFT行扫描计数器
	vcount,		//TFT场扫描计数器
	TFT_RGB,	//TFT数据输出
	TFT_HS,		//TFT行同步信�
	TFT_VS,		//TFT场同步信�
	TFT_BLANK,
	TFT_VCLK,
	TFT_DE,
	wr_en
);
			
	//----------------模块输入端口----------------
	input  Clk33M;          //系统输入时钟33MHZ
	input  Rst_n;
	input  [15:0]data_in;     //待显示数�
	output wr_en;

	//----------------模块输出端口----------------
	output [11:0]hcount;
	output [11:0]vcount;
	output [15:0]TFT_RGB;  //TFT数据输出
	output TFT_HS;           //TFT行同步信�
	output TFT_VS;           //TFT场同步信�
	output TFT_BLANK;
	output TFT_DE;
	output TFT_VCLK;
	wire wr_en;

	//----------------内部寄存器定�---------------
	reg [11:0] hcount_r;     //TFT行扫描计数器
	reg [11:0] vcount_r;     //TFT场扫描计数器
	//----------------内部连线定义----------------
	wire hcount_ov;
	wire vcount_ov;
	wire TFT_DE;//有效显示区标�

	//TFT行、场扫描时序参数�
	parameter TFT_HS_end=10'd96,
				 hdat_begin=10'd144,
				 hdat_end=10'd144+'d640,
				 hpixel_end=12'd800,
				 TFT_VS_end=10'd2,
				 vdat_begin=10'd35,
				 vdat_end=10'd35+'d480,
				 vline_end=10'd525;

	assign hcount=TFT_DE?(hcount_r-hdat_begin):12'd0;
	assign vcount=TFT_DE?(vcount_r-vdat_begin):12'd0;
	
	assign TFT_BLANK = TFT_DE;
	assign TFT_VCLK = Clk33M;

	//**********************TFT驱动部分**********************
	//行扫�
	always@(posedge Clk33M or negedge Rst_n)
	if(!Rst_n)
		hcount_r<=12'd0;
	else if(hcount_ov)
		hcount_r<=12'd0;
	else
		hcount_r<=hcount_r+12'd1;

	assign hcount_ov=(hcount_r==hpixel_end-1);

	//场扫�
	always@(posedge Clk33M or negedge Rst_n)
	if(!Rst_n)
		vcount_r<=12'd0;
	else if(hcount_ov) begin
		if(vcount_ov)
			vcount_r<=12'd0;
		else
			vcount_r<=vcount_r+12'd1;
	end
	else 
		vcount_r<=vcount_r;
		
	assign 	vcount_ov=(vcount_r==vline_end-1);

	//数据、同步信号输�
	assign TFT_DE=((hcount_r>=hdat_begin)&&(hcount_r<hdat_end))
					&&((vcount_r>=vdat_begin)&&(vcount_r<vdat_end));
					
	assign wr_en=((hcount_r>=hdat_begin)&&(hcount_r<hdat_begin+'d640))
					&&((vcount_r>=vdat_begin)&&(vcount_r<vdat_begin+'d480));
					
	assign TFT_HS=(hcount_r>TFT_HS_end);
	assign TFT_VS=(vcount_r>TFT_VS_end);
	assign TFT_RGB=(wr_en)?data_in:16'h000000;
		
endmodule 
