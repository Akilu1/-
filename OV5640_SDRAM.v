module OV5640_SDRAM(
	clk,
	reset_n,
	
	cmos_sclk,
	cmos_sdat,
	cmos_vsync,
	cmos_href,
	cmos_pclk,
	cmos_xclk,
	cmos_data,
	cmos_rst_n,
	cmos_pwdn,
	
	//sdram control
	//sdram_clk,		
	//sdram_cke,		
	//sdram_cs_n,		
	//sdram_we_n,		
	//sdram_cas_n,
	//sdram_ras_n,	
	//sdram_dqm,
	//sdram_ba,
	//sdram_addr,
	//sdram_dq,		
	
	//VGA port
	TFT_VCLK,			
	TFT_HS,
	TFT_VS,		
	vga_r,vga_g,vga_b,		
	TFT_DE,
	TFT_BL,
	coms33,
	sg_key_1,
	sg_key_2,
	sg_key_3,
	sg_key_4,
	pwm_1,
	pwm_2,
	coms33_2,
	coms33_4,
	coms33_3
	
);
    output coms33_2;
	output coms33_4;
	output coms33_3;
	input		clk;
	input		reset_n;
	output coms33;

	//cmos interface
	output			cmos_sclk;
	inout			cmos_sdat;
	input			cmos_vsync;
	input			cmos_href;
	input			cmos_pclk;
	output		cmos_xclk;
	input	[7:0]	cmos_data;
	output		cmos_rst_n;	
	output		cmos_pwdn;	
	assign coms33_4=1;
	assign coms33_3=1;
	assign coms33_2=1;
	input sg_key_1;
	input sg_key_2;
	input sg_key_3;
	input sg_key_4;
	output pwm_1;
	output pwm_2;
	
	//sdram control
	wire 		sdram_clk;	
	wire 		sdram_cke;		
	wire 		sdram_cs_n;	
	wire 		sdram_we_n;
	wire 		sdram_cas_n;	
	wire 		sdram_ras_n;	
	wire [3:0]	sdram_dqm;		
	wire [1:0]	sdram_ba;		
	wire [10:0]	sdram_addr;
	wire [31:0]	sdram_dq;		
	wire wr_en;
	//lcd port
	output			TFT_VCLK;		
	output			TFT_HS;		 
	output			TFT_VS;	
	output			TFT_DE;
	output [7:0] vga_b,vga_r,vga_g;
	wire	[15:0]	TFT_RGB;	
	assign vga_b=(wr_en)?{TFT_RGB[4:0],3'b000}:'h0;
	assign vga_g=(wr_en)?{TFT_RGB[10:5],2'b00}:'h0;
	assign vga_r=(wr_en)?{TFT_RGB[15:11],3'b000}:'h0;
	
	output TFT_BL;
	assign TFT_BL = 1;
	
	assign coms33=1;
	
	assign cmos_pwdn = 1'b0;
	assign cmos_rst_n = 1'b1;

	wire clk_sdr_ctrl;
	
	wire clk_tft;
	wire vga_data_req;
	wire [31:0]vga_data_in;
	
	wire clk_cmos;

	//cmos video image capture
	wire			cmos_frame_vsync;	//cmos frame data vsync valid signal
	wire			cmos_frame_href;	//cmos frame data href vaild  signal
	wire	[15:0]cmos_frame_data;	//cmos frame data output: {cmos_data[7:0]<<8, cmos_data[7:0]}	
	wire			cmos_frame_clken;	//cmos frame data output/capture enable clock
	wire	[7:0]	cmos_fps_rate;		//cmos image output rate
	
	wire cmos_init_flag;
	wire clk_50mhz;
	pll pll(
	    .reset(~reset_n),
		.refclk(clk),
		.clk0_out(clk_sdr_ctrl),
		.clk1_out(sdram_clk),
		.clk2_out(clk_50mhz),
		.clk3_out(clk_cmos)
	);
	
	
	pll1 u_pll(
	    .refclk(clk),
		.reset(~reset_n),
		.clk0_out(),
		.clk1_out(clk_tft)
		);
	//pll1 u_pll
	
	IIC iic(
          
	.iCLK(clk),		//25MHz
	.iRST_N(reset_n),		//Global Reset
	
	
	.I2C_SCLK(cmos_sclk),	//I2C CLOCK
	.I2C_SDAT(cmos_sdat),	//I2C DATA
	
	.Config_Done(cmos_init_flag),//Config Done
	.LUT_INDEX(),	//LUT Index
	.I2C_RDATA()	//I2C Read Data

);

    PWM u_pwm(
	.clk(clk_50mhz),		//50Mhz
	.rst_n(reset_n),
	.sg_key_1(sg_key_1),	
	.sg_key_2(sg_key_2),
	.sg_key_3(sg_key_3),
	.sg_key_4(sg_key_4),
	.pwm_1(pwm_1),
	.pwm_2(pwm_2)
    );


	
	CMOS_Capture_RGB565	
	#(
		.CMOS_FRAME_WAITCNT		(4'd10)				//Wait n fps for steady(OmniVision need 10 Frame)
	)
	u_CMOS_Capture_RGB565
	(
		//global clock
		.clk_cmos				(clk_cmos),			//24MHz CMOS Driver clock input
		.rst_n					(reset_n & cmos_init_flag),	//global reset

		//CMOS Sensor Interface
		.cmos_pclk				(cmos_pclk),  		//24MHz CMOS Pixel clock input
		.cmos_xclk				(cmos_xclk),		//24MHz drive clock
		.cmos_din				(cmos_data),		//8 bits cmos data input
		.cmos_vsync				(cmos_vsync),		//L: vaild, H: invalid
		.cmos_href				(cmos_href),		//H: vaild, L: invalid
		
		//CMOS SYNC Data output
		.cmos_frame_vsync		(cmos_frame_vsync),	//cmos frame data vsync valid signal
		.cmos_frame_href		(cmos_frame_href),	//cmos frame data href vaild  signal
		.cmos_frame_data		(cmos_frame_data),	//cmos frame RGB output: {{R[4:0],G[5:3]}, {G2:0}, B[4:0]}	
		.cmos_frame_clken		(cmos_frame_clken),	//cmos frame data output/capture enable clock
		
		//user interface
		.cmos_fps_rate			(cmos_fps_rate)		//cmos image output rate
	);

	Sdram_Control_4Port Sdram_Control_4Port(
		//	HOST Side
		.CTRL_CLK(clk_sdr_ctrl),	//输入参考时钟，默认100M，如果为其他频率，请修改sdram_pll核设�
		.RESET_N(reset_n),	//复位输入，低电平复位

		//	FIFO Write Side 1
		.WR1_DATA({16'h0,cmos_frame_data}),			//写入端口1的数据输入端�6bit
		.WR1(cmos_frame_clken),					//写入端口1的写使能端，高电平写�
		.WR1_ADDR(0),			//写入端口1的写起始地址
		.WR1_MAX_ADDR(640*480),		//写入端口1的写入最大地址
		.WR1_LENGTH(16),			//一次性写入数据长�
		.WR1_LOAD((~reset_n) &(~cmos_init_flag)),			//写入端口1清零请求，高电平清零写入地址和fifo
		.WR1_CLK(cmos_pclk),				//写入端口1 fifo写入时钟
		.WR1_FULL(),			//写入端口1 fifo写满信号
		.WR1_USE(),				//写入端口1 fifo已经写入的数据长�

		//	FIFO Write Side 2
		.WR2_DATA(),			//写入端口2的数据输入端�6bit
		.WR2(1'b0),					//写入端口2的写使能端，高电平写�
		.WR2_ADDR(0),			//写入端口2的写起始地址
		.WR2_MAX_ADDR(320*240),		//写入端口2的写入最大地址
		.WR2_LENGTH(16),			//一次性写入数据长�
		.WR2_LOAD(1'b0),			//写入端口2清零请求，高电平清零写入地址和fifo
		.WR2_CLK(1'b0),				//写入端口2 fifo写入时钟
		.WR2_FULL(),			//写入端口2 fifo写满信号
		.WR2_USE(),				//写入端口2 fifo已经写入的数据长�

		//	FIFO Read Side 1
		.RD1_DATA(vga_data_in),			//读出端口1的数据输出端�6bit
		.RD1(vga_data_req),					//读出端口1的读使能端，高电平读�
		.RD1_ADDR(0),			//读出端口1的读起始地址
		.RD1_MAX_ADDR(640*480),		//读出端口1的读出最大地址
		.RD1_LENGTH(16),			//一次性读出数据长�
		.RD1_LOAD((~reset_n) & (~cmos_init_flag)),			//读出端口1 清零请求，高电平清零读出地址和fifo
		.RD1_CLK(clk_tft),				//读出端口1 fifo读取时钟
		.RD1_EMPTY(),			//读出端口1 fifo读空信号
		.RD1_USE(),				//读出端口1 fifo已经还可以读取的数据长度

		//	FIFO Read Side 2
		.RD2_DATA(),			//读出端口2的数据输出端�6bit
		.RD2(1'b0),					//读出端口2的读使能端，高电平读�
		.RD2_ADDR(),			//读出端口2的读起始地址
		.RD2_MAX_ADDR(),		//读出端口2的读出最大地址
		.RD2_LENGTH(),			//一次性读出数据长�
		.RD2_LOAD(),			//读出端口2清零请求，高电平清零读出地址和fifo
		.RD2_CLK(1'b0),				//读出端口2 fifo读取时钟
		.RD2_EMPTY(),			//读出端口2 fifo读空信号
		.RD2_USE(),				//读出端口2 fifo已经还可以读取的数据长度

		//	SDRAM Side
		.SA(sdram_addr),		//SDRAM 地址线，
		.BA(sdram_ba),		//SDRAM bank地址�
		.CS_N(sdram_cs_n),		//SDRAM 片选信�
		.CKE(sdram_cke),		//SDRAM 时钟使能
		.RAS_N(sdram_ras_n),	//SDRAM 行选中信号
		.CAS_N(sdram_cas_n),	//SDRAM 列选中信号
		.WE_N(sdram_we_n),		//SDRAM 写请求信�
		.DQ(sdram_dq),		//SDRAM 双向数据总线
		.DQM(sdram_dqm)		//SDRAM 数据总线高低字节屏蔽信号
	);	
	

	
	SDRAM_32 U_SDRAM ( 
	.clk(sdram_clk), 
	.ras_n(sdram_ras_n), 
	.cas_n(sdram_cas_n), 
	.we_n(sdram_we_n), 
	.addr(sdram_addr), 
	.ba(sdram_ba), 
	.dq(sdram_dq), 
	.cs_n(sdram_cs_n), 
	.dm0(sdram_dqm[0]), 
	.dm1(sdram_dqm[1]),
	.dm2(sdram_dqm[2]), 
	.dm3(sdram_dqm[3]), 
	.cke(sdram_cke) 
	);
	
	TFT_CTRL_800_480_16bit TFT_CTRL_800_480_16bit(
		.Clk33M(clk_tft),	//系统输入时钟33MHZ
		.Rst_n(reset_n & cmos_init_flag),	//复位输入，低电平复位
		.data_in(vga_data_in[15:0]),	//待显示数�
		.hcount(),		//TFT行扫描计数器
		.vcount(),		//TFT场扫描计数器
		.TFT_RGB(TFT_RGB),	//TFT数据输出
		.TFT_HS(TFT_HS),		//TFT行同步信�
		.TFT_VS(TFT_VS),		//TFT场同步信�
		.TFT_BLANK(),
		.TFT_VCLK(TFT_VCLK),
		.TFT_DE(TFT_DE),
		.wr_en(wr_en)
	);
	assign vga_data_req = wr_en;
	
endmodule
