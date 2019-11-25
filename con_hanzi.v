`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:13 09/21/2019 
// Design Name: 
// Module Name:    con_wen_z 
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
module con_pic(
    in_cnt_x,
	in_cnt_y,
	en,
	rst_n,
	clk,
	in_lo_data,
	s_shi,
	s_ge,
	yan_en,
	huo_en,
	in_long_data,
	in_addr,
	qi_en,
	sec_hi,
	sec_lo,
	min_hi,
	min_lo,
	hour_hi,
	hour_lo,
	w_shi,
	w_ge
    );
	input [9:0]in_cnt_x;
	input [9:0]in_cnt_y;
	input clk;
	input rst_n;
	input [15:0]in_lo_data;
	input [3:0]s_shi;
	input [3:0]s_ge;
	input [3:0]w_shi;
	input [4:0]in_addr;
	input [55:0]in_long_data;
	input [3:0]w_ge;
	input yan_en;
	input qi_en;
	input huo_en;
	input [3:0]sec_hi;
	input [3:0]sec_lo;
	input [3:0]min_hi;
	input [3:0]min_lo;
	input [3:0]hour_hi;
	input [3:0]hour_lo;
	
	
	output reg [3:0]en;   // çº ç»  è“  ç™
	
	reg [4:0]cnt_x;
	reg [4:0]cnt_y;
	
	
	reg [3:0]now_num;   //ç¡®å®šå½“å‰æ˜¾ç¤ºå“ªä¸ª
	reg [7:0]addr;      //romçš„åœ°å€
	
	wire [0:31]data1,data2,data5,data9,data11;     //romè¯»å‡ºçš„æ•°
	wire [0:15]data3,data4,data6,data7,data8;
	wire [0:7]data10;
	
	
	reg [3:0]disp_en;        //æœ‰æ•ˆæ˜¾ç¤ºæ ‡å¿—
	reg [3:0]now_rom;
	
	
	always@(*)                    //ç¡®å®šæ±‰å­—ä½ç½®çš„æ¨¡
	begin
	    if(rst_n==0)
		begin
		    cnt_x=0;
			cnt_y=0;
			now_num=0;
			now_rom=0;
		end
		else
		begin
	        if((in_cnt_y>='d100)&&(in_cnt_y<='d131))                    //row4
		    begin
    	    	cnt_y=in_cnt_y-'d100;
				if((in_cnt_x>=('d400))&&(in_cnt_x<=('d431)))                     
		        begin
		    		now_num='d2;			         //  Ã— si			                                                       
		    		cnt_x=in_cnt_x-'d400;
					disp_en='b0001;                  //white
					now_rom='d2;                     //    si
		        end
				else if((in_cnt_x>=('d432))&&(in_cnt_x<=('d463)))                     
		        begin
		    		now_num='d6;					 // lou	                                                       
		    		cnt_x=in_cnt_x-'d432;
					disp_en=1;
					now_rom='d1;
		        end
				else if((in_cnt_x>=('d472))&&(in_cnt_x<=('d479)))                     
		        begin
				    cnt_x=in_cnt_x-'d472;		
				    if(in_addr=='d13)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d512))&&(in_cnt_x<=('d519)))                     
		        begin
				    cnt_x=in_cnt_x-'d512;		
				    if(in_addr=='d14)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d552))&&(in_cnt_x<=('d559)))                     
		        begin
				    cnt_x=in_cnt_x-'d552;		
				    if(in_addr=='d15)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d592))&&(in_cnt_x<=('d599)))                     
		        begin
				    cnt_x=in_cnt_x-'d592;		
				    if(in_addr=='d16)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
	            else if((in_cnt_x>=('d480))&&(in_cnt_x<=('d511)))                             //col1
		        begin
		    	    if(in_lo_data[12])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d480;
					now_rom=1;
		        end
				
		    	else if((in_cnt_x>=('d520))&&(in_cnt_x<=('d551)))                        //col2
		        begin
		    	    if(in_lo_data[13])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end            
		    		cnt_x=in_cnt_x-'d520;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d560))&&(in_cnt_x<=('d591)))                        //col3
		        begin
		    	    if(in_lo_data[14])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d560;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d600))&&(in_cnt_x<=('d631)))                        //col4
		        begin
		    	    if(in_lo_data[15])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d600;
					now_rom=1;
		        end
		    	else
		    	begin
				    disp_en=0;
		    	    cnt_x=cnt_x;
		    		now_num=now_num;
					now_rom=0;
		    	end
		    end
		    else if((in_cnt_y>='d150)&&(in_cnt_y<='d181))               //row3
		   	begin
    	    	cnt_y=in_cnt_y-'d150;
				if((in_cnt_x>=('d400))&&(in_cnt_x<=('d431)))                     
		        begin
		    		now_num='d1;			         //  right san		                                                       
		    		cnt_x=in_cnt_x-'d400;
					disp_en='b0001;
					now_rom='d2;                     //    san
		        end
				else if((in_cnt_x>=('d472))&&(in_cnt_x<=('d479)))                     
		        begin
				    cnt_x=in_cnt_x-'d472;		
				    if(in_addr=='d9)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d512))&&(in_cnt_x<=('d519)))                     
		        begin
				    cnt_x=in_cnt_x-'d512;		
				    if(in_addr=='d10)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d552))&&(in_cnt_x<=('d559)))                     
		        begin
				    cnt_x=in_cnt_x-'d552;		
				    if(in_addr=='d11)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d592))&&(in_cnt_x<=('d599)))                     
		        begin
				    cnt_x=in_cnt_x-'d592;		
				    if(in_addr=='d12)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d432))&&(in_cnt_x<=('d463)))                     
		        begin
		    		now_num='d6;						                                                       
		    		cnt_x=in_cnt_x-'d432;            //lou
					disp_en=1;
					now_rom='d1;
		        end
	            else if((in_cnt_x>=('d480))&&(in_cnt_x<=('d511)))                             //col1
		        begin
		    	    if(in_lo_data[8])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d480;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d520))&&(in_cnt_x<=('d551)))                        //col2
		        begin
		    	    if(in_lo_data[9])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d520;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d560))&&(in_cnt_x<=('d591)))                        //col3
		        begin
		    	    if(in_lo_data[10])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d560;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d600))&&(in_cnt_x<=('d631)))                        //col4
		        begin
		    	    if(in_lo_data[11])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d600;
					now_rom=1;
		        end
		    	else
		    	begin
				    disp_en=0;
		    	    cnt_x=cnt_x;
		    		now_num=now_num;
					now_rom=0;
		    	end
		    end
		    else if((in_cnt_y>='d200)&&(in_cnt_y<='d231))               //row2
		    begin
    	    	cnt_y=in_cnt_y-'d200;
				if((in_cnt_x>=('d400))&&(in_cnt_x<=('d431)))                     
		        begin
		    		now_num='d8;			         //  er	                                                       
		    		cnt_x=in_cnt_x-'d400;
					disp_en=1;
					now_rom='d1;                     //  er
		        end
				else if((in_cnt_x>=('d472))&&(in_cnt_x<=('d479)))                     
		        begin
				    cnt_x=in_cnt_x-'d472;		
				    if(in_addr=='d5)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d512))&&(in_cnt_x<=('d519)))                     
		        begin
				    cnt_x=in_cnt_x-'d512;		
				    if(in_addr=='d6)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d552))&&(in_cnt_x<=('d559)))                     
		        begin
				    cnt_x=in_cnt_x-'d552;		
				    if(in_addr=='d7)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d592))&&(in_cnt_x<=('d599)))                     
		        begin
				    cnt_x=in_cnt_x-'d592;		
				    if(in_addr=='d8)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d432))&&(in_cnt_x<=('d463)))                     
		        begin
		    		now_num='d6;						                                                       
		    		cnt_x=in_cnt_x-'d432;
					disp_en=1;
					now_rom='d1;
		        end
	            else if((in_cnt_x>=('d480))&&(in_cnt_x<=('d511)))                             //col1
		        begin
		    	    if(in_lo_data[4])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d480;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d520))&&(in_cnt_x<=('d551)))                        //col2
		        begin
		    	    if(in_lo_data[5])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d520;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d560))&&(in_cnt_x<=('d591)))                        //col3
		        begin
		    	    if(in_lo_data[6])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d560;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d600))&&(in_cnt_x<=('d631)))                        //col4
		        begin
		    	    if(in_lo_data[7])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d600;
					now_rom=1;
		        end
		    	else
		    	begin
				    disp_en=0;
		    	    cnt_x=cnt_x;
		    		now_num=now_num;
					now_rom=0;
		    	end
		    end                                            
		    else if((in_cnt_y>='d250)&&(in_cnt_y<='d281))               //row1
		    begin
    	    	cnt_y=in_cnt_y-'d250;
				if((in_cnt_x>=('d400))&&(in_cnt_x<=('d431)))                     
		        begin
		    		now_num='d7;			         //   yi		                                                       
		    		cnt_x=in_cnt_x-'d400;
					disp_en=1;
					now_rom='d1;                     //   yi
		        end
				else if((in_cnt_x>=('d472))&&(in_cnt_x<=('d479)))                     
		        begin
				    cnt_x=in_cnt_x-'d472;		
				    if(in_addr=='d1)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d512))&&(in_cnt_x<=('d519)))                     
		        begin
				    cnt_x=in_cnt_x-'d512;		
				    if(in_addr=='d2)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d552))&&(in_cnt_x<=('d559)))                     
		        begin
				    cnt_x=in_cnt_x-'d552;		
				    if(in_addr=='d3)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d592))&&(in_cnt_x<=('d599)))                     
		        begin
				    cnt_x=in_cnt_x-'d592;		
				    if(in_addr=='d4)
					begin	                                                       
                    now_num='d1;		 // arror	
					disp_en='d1;
					now_rom='d10;
				    end
					else
				    disp_en='d0;
		        end
				else if((in_cnt_x>=('d432))&&(in_cnt_x<=('d463)))                     
		        begin
		    		now_num='d6;				     //lou                                                 
		    		cnt_x=in_cnt_x-'d432;
					disp_en=1;
					now_rom='d1;
		        end
	            else if((in_cnt_x>=('d480))&&(in_cnt_x<=('d511)))                             //col1
		        begin
		    	    if(in_lo_data[0])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d480;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d520))&&(in_cnt_x<=('d551)))                        //col2
		        begin
		    	    if(in_lo_data[1])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d520;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d560))&&(in_cnt_x<=('d591)))                        //col3
		        begin
		    	    if(in_lo_data[2])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d560;
					now_rom=1;
		        end
		    	else if((in_cnt_x>=('d600))&&(in_cnt_x<=('d631)))                        //col4
		        begin
		    	    if(in_lo_data[3])
		    		begin
					    disp_en='b1000;                      //red
    					now_num='d2;						//Ã—   
                    end						
		            else
					begin
					    disp_en='b0100;                     //green
		    		    now_num='d1;                        //å¯¹å·
					end
		    		cnt_x=in_cnt_x-'d600;
					now_rom=1;
		        end
		    	else
		    	begin
				    disp_en=0;
		    	    cnt_x=cnt_x;
		    		now_num=now_num;
					now_rom=0;
		    	end
		    end                   
	        else if((in_cnt_y>='d299)&&(in_cnt_y<='d330))               //row1
		    begin
			    cnt_y=in_cnt_y-'d299;
				if((in_cnt_x>=('d434+'d30))&&(in_cnt_x<=('d465+'d30)))      //  first of carID            
		        begin
				    cnt_x=in_cnt_x-'d434-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[55:48])
						"~":begin
						now_rom=5;
						now_num=4;
						end
						"!":begin
						now_rom=5;
						now_num=5;
						end
						"@":begin
						now_rom=5;
						now_num=6;
						end
						"#":begin
						now_rom=5;
						now_num=7;
						end
						"$":begin
						now_rom=5;
						now_num=8;
						end
						"%":begin
						now_rom=9;
						now_num=1;
						end
						"^":begin
						now_rom=9;
						now_num=2;
						end
						"&":begin
						now_rom=9;
						now_num=3;
						end
						"*":begin
						now_rom=9;
						now_num=4;
						end
						"(":begin
						now_rom=9;
						now_num=5;
						end
						")":begin
						now_rom=9;
						now_num=6;
						end
						"_":begin
						now_rom=9;
						now_num=7;
						end
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
				else if((in_cnt_x>=('d466+'d30))&&(in_cnt_x<=('d481+'d30)))      //   sec of carID            
		        begin
				    cnt_x=in_cnt_x-'d466-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[47:40])
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
				else if((in_cnt_x>=('d482+'d30))&&(in_cnt_x<=('d497+'d30)))      //   thr of carID            
		        begin
				    cnt_x=in_cnt_x-'d482-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[39:32])
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
				else if((in_cnt_x>=('d498+'d30))&&(in_cnt_x<=('d513+'d30)))      //   fourth of carID            
		        begin
				    cnt_x=in_cnt_x-'d498-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[31:24])
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
				else if((in_cnt_x>=('d514+'d30))&&(in_cnt_x<=('d529+'d30)))      //   fri of carID            
		        begin
				    cnt_x=in_cnt_x-'d514-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[23:16])
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
				else if((in_cnt_x>=('d530+'d30))&&(in_cnt_x<=('d545+'d30)))      //   six of carID            
		        begin
				    cnt_x=in_cnt_x-'d530-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[15:8])
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
				else if((in_cnt_x>=('d546+'d30))&&(in_cnt_x<=('d561+'d30)))      //   last of carID            
		        begin
				    cnt_x=in_cnt_x-'d546-'d30;
				    if(in_lo_data[in_addr-1])
					begin
					disp_en=1;
					    case(in_long_data[7:0])
						"0":begin
						now_rom=4;
						now_num=5;
						end
						"H":begin
						now_rom=3;
						now_num=3;
						end
						"1":begin
						now_rom=3;
						now_num=4;
						end
						"R":begin
						now_rom=3;
						now_num=2;
						end
						"2":begin
						now_rom=3;
						now_num=5;
						end
						"3":begin
						now_rom=3;
						now_num=6;
						end
						"4":begin
						now_rom=3;
						now_num=7;
						end
						"5":begin
						now_rom=3;
						now_num=8;
						end
						"6":begin
						now_rom=4;
						now_num=1;
						end
						"7":begin
						now_rom=4;
						now_num=2;
						end
						"8":begin
						now_rom=4;
						now_num=3;
						end
						"9":begin
						now_rom=4;
						now_num=4;
						end
						"A":begin
						now_rom=4;
						now_num=6;
						end
						"B":begin
						now_rom=4;
						now_num=7;
						end
						"C":begin
						now_rom=4;
						now_num=8;
						end
						"D":begin
						now_rom=6;
						now_num=1;
						end
						"E":begin
						now_rom=6;
						now_num=2;
						end
						"F":begin
						now_rom=6;
						now_num=3;
						end
						"G":begin
						now_rom=6;
						now_num=4;
						end
						"S":begin
						now_rom=6;
						now_num=5;
						end
						"I":begin
						now_rom=6;
						now_num=6;
						end
						"J":begin
						now_rom=6;
						now_num=7;
						end
						"K":begin
						now_rom=6;
						now_num=8;
						end
						"L":begin
						now_rom=7;
						now_num=1;
						end
						"M":begin
						now_rom=7;
						now_num=2;
						end
						"N":begin
						now_rom=7;
						now_num=3;
						end
						"O":begin
						now_rom=7;
						now_num=4;
						end
						"P":begin
						now_rom=7;
						now_num=5;
						end
						"Q":begin
						now_rom=7;
						now_num=6;
						end
						"T":begin
						now_rom=7;
						now_num=7;
						end
						"U":begin
						now_rom=7;
						now_num=8;
						end
						"V":begin
						now_rom=8;
						now_num=1;
						end
						"W":begin
						now_rom=8;
						now_num=2;
						end
						"X":begin
						now_rom=8;
						now_num=3;
						end
						"Y":begin
						now_rom=8;
						now_num=4;
						end
						"Z":begin
						now_rom=8;
						now_num=5;
						end
						default:disp_en=0;
						endcase
					end 
                    else
                        disp_en=0;						
		        end
			    
			end
			else if((in_cnt_y>='d408)&&(in_cnt_y<='d439))
			begin
			    cnt_y=in_cnt_y-'d408;
				if((in_cnt_x>=('d50))&&(in_cnt_x<=('d81)))             //   WEN        
		        begin
		    		now_num='d3;			         //   wen		                                                       
		    		cnt_x=in_cnt_x-'d50;
					disp_en=1;
					now_rom='d1;                     //   wen
		        end
				else if((in_cnt_x>=('d82))&&(in_cnt_x<=('d113)))       //   DU              
		        begin
		    		now_num='d5;			         //   du		                                                       
		    		cnt_x=in_cnt_x-'d82;
					disp_en=1;
					now_rom='d1;                     //   du
		        end
				else if((in_cnt_x>=('d114))&&(in_cnt_x<=('d129)))      //    :              
		        begin
		    		now_num='d1;			         //   :		                                                       
		    		cnt_x=in_cnt_x-'d114;
					disp_en=1;
					now_rom='d3;                     //   :
		        end
				else if((in_cnt_x>=('d130))&&(in_cnt_x<=('d145)))      //   w_shi	                
		        begin
		    		case(w_shi)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d130;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d146))&&(in_cnt_x<=('d161)))      //   w_ge	                
		        begin
		    		case(w_ge)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d146;
					disp_en=1;                    
		        end
			    else if((in_cnt_x>=('d162))&&(in_cnt_x<=('d193)))      //   oC            
		        begin
		    		now_num='d4;			         	                                                       
		    		cnt_x=in_cnt_x-'d162;
					disp_en=1;
					now_rom='d2;                     
		        end
				else if((in_cnt_x>=('d240))&&(in_cnt_x<=('d271)))      //   yan            
		        begin
		    		now_num='d8;			         	                                                       
		    		cnt_x=in_cnt_x-'d240;
					disp_en=1;
					now_rom='d2;                     
		        end
				else if((in_cnt_x>=('d272))&&(in_cnt_x<=('d303)))      //    wu          
		        begin
		    		now_num='d1;			         	                                                       
		    		cnt_x=in_cnt_x-'d272;
					disp_en=1;
					now_rom='d5;                     
		        end
				else if((in_cnt_x>=('d303))&&(in_cnt_x<=('d318)))      //    :              
		        begin
		    		now_num='d1;			         //   :		                                                       
		    		cnt_x=in_cnt_x-'d303;
					disp_en=1;
					now_rom='d3;                     //   :
		        end
				else if((in_cnt_x>=('d319))&&(in_cnt_x<=('d350)))      //    zheng/yi              
		        begin
				 	cnt_x=in_cnt_x-'d319;
					disp_en=1;
				    if(yan_en)
		    		begin
					    now_num='d5;			         		                                                       
					    now_rom='d2;                     //zheng
					end
					else
					begin
					    now_num='d6;			         		                                                       
					    now_rom='d2;                     //yi
					end
		        end
				else if((in_cnt_x>=('d351))&&(in_cnt_x<=('d382)))      //   chang            
		        begin
				 	cnt_x=in_cnt_x-'d351;
					disp_en=1;
					now_num='d7;			         		                                                       
					now_rom='d2;                 
		        end
			    else if((in_cnt_x>=('d420))&&(in_cnt_x<=('d435)))      //   hour	                
		        begin
		    		case(hour_hi)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d420;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d436))&&(in_cnt_x<=('d451)))      //  hour	                
		        begin
		    		case(hour_lo)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d436;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d452))&&(in_cnt_x<=('d467)))      //    :              
		        begin
		    		now_num='d1;			         //   :		                                                       
		    		cnt_x=in_cnt_x-'d452;
					disp_en=1;
					now_rom='d3;                     //   :
		        end
				else if((in_cnt_x>=('d468))&&(in_cnt_x<=('d483)))      //  min	                
		        begin
		    		case(min_hi)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d468;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d484))&&(in_cnt_x<=('d499)))      //  min	                
		        begin
		    		case(min_lo)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d484;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d500))&&(in_cnt_x<=('d515)))      //    :              
		        begin
		    		now_num='d1;			         //   :		                                                       
		    		cnt_x=in_cnt_x-'d500;
					disp_en=1;
					now_rom='d3;                     //   :
		        end
				else if((in_cnt_x>=('d516))&&(in_cnt_x<=('d531)))      //  min	                
		        begin
		    		case(sec_hi)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d516;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d532))&&(in_cnt_x<=('d547)))      //  min	                
		        begin
		    		case(sec_lo)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d532;
					disp_en=1;                    
		        end
				else
		    	begin
				    disp_en=0;
		    	    cnt_x=cnt_x;
		    		now_num=now_num;
					now_rom=0;
		    	end
			end
			else if((in_cnt_y>='d350)&&(in_cnt_y<='d381))
			begin
			    cnt_y=in_cnt_y-'d350;
				if((in_cnt_x>=('d50))&&(in_cnt_x<=('d81)))             //   shi        
		        begin
		    		now_num='d4;			         //  shi		                                                       
		    		cnt_x=in_cnt_x-'d50;
					disp_en=1;
					now_rom='d1;                     //  shi
		        end
				else if((in_cnt_x>=('d82))&&(in_cnt_x<=('d113)))       //   DU              
		        begin
		    		now_num='d5;			         //   du		                                                       
		    		cnt_x=in_cnt_x-'d82;
					disp_en=1;
					now_rom='d1;                     //   du
		        end
				else if((in_cnt_x>=('d114))&&(in_cnt_x<=('d129)))      //    :              
		        begin
		    		now_num='d1;			         //   :		                                                       
		    		cnt_x=in_cnt_x-'d114;
					disp_en=1;
					now_rom='d3;                     //   :
		        end
				else if((in_cnt_x>=('d130))&&(in_cnt_x<=('d145)))      //   s_shi	                
		        begin
		    		case(s_shi)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d130;
					disp_en=1;                    
		        end
				else if((in_cnt_x>=('d146))&&(in_cnt_x<=('d161)))      //   w_ge	                
		        begin
		    		case(s_ge)
					'd1:begin
					now_num='d4;			        
					now_rom='d3;
					end
					'd2:begin
					now_num='d5;			        
					now_rom='d3;
					end
					'd3:begin
					now_num='d6;			        
					now_rom='d3;
					end
					'd4:begin
					now_num='d7;			        
					now_rom='d3;
					end
					'd5:begin
					now_num='d8;			        
					now_rom='d3;
					end
					'd6:begin
					now_num='d1;			        
					now_rom='d4;
					end
					'd7:begin
					now_num='d2;			        
					now_rom='d4;
					end
					'd8:begin
					now_num='d3;			        
					now_rom='d4;
					end
					'd9:begin
					now_num='d4;			        
					now_rom='d4;
					end
					'd0:begin
					now_num='d5;			        
					now_rom='d4;
					end
					default:begin
					now_num='d5;			        
					now_rom='d4;
					end
					endcase
		    		cnt_x=in_cnt_x-'d146;
					disp_en=1;                    
		        end
			    else if((in_cnt_x>=('d162))&&(in_cnt_x<=('d193)))      //   %            
		        begin
		    		now_num='d3;			         	                                                       
		    		cnt_x=in_cnt_x-'d162;
					disp_en=1;
					now_rom='d2;                     
		        end
				else if((in_cnt_x>=('d194))&&(in_cnt_x<=('d209)))      //   R            
		        begin
		    		now_num='d2;			         	                                                       
		    		cnt_x=in_cnt_x-'d194;
					disp_en=1;
					now_rom='d3;                     
		        end
				else if((in_cnt_x>=('d210))&&(in_cnt_x<=('d225)))      //   H            
		        begin
		    		now_num='d3;			         	                                                       
		    		cnt_x=in_cnt_x-'d210;
					disp_en=1;
					now_rom='d3;                     
		        end
				else if((in_cnt_x>=('d240))&&(in_cnt_x<=('d271)))      //   qi            
		        begin
		    		now_num='d2;			         	                                                       
		    		cnt_x=in_cnt_x-'d240;
					disp_en=1;
					now_rom='d5;                     
		        end
				else if((in_cnt_x>=('d272))&&(in_cnt_x<=('d303)))      //    ti          
		        begin
		    		now_num='d3;			         	                                                       
		    		cnt_x=in_cnt_x-'d272;
					disp_en=1;
					now_rom='d5;                     
		        end
				else if((in_cnt_x>=('d303))&&(in_cnt_x<=('d318)))      //    :              
		        begin
		    		now_num='d1;			         //   :		                                                       
		    		cnt_x=in_cnt_x-'d303;
					disp_en=1;
					now_rom='d3;                     //   :
		        end
				else if((in_cnt_x>=('d319))&&(in_cnt_x<=('d350)))      //    zheng/yi              
		        begin
				 	cnt_x=in_cnt_x-'d319;
					disp_en=1;
				    if(qi_en)
		    		begin
					    now_num='d5;			         		                                                       
					    now_rom='d2;                     //zheng
					end
					else
					begin
					    now_num='d6;			         		                                                       
					    now_rom='d2;                     //yi
					end
		        end
				else if((in_cnt_x>=('d351))&&(in_cnt_x<=('d382)))      //   chang            
		        begin
				 	cnt_x=in_cnt_x-'d351;
					disp_en=1;
					now_num='d7;			         		                                                       
					now_rom='d2;                 
		        end
				else if((in_cnt_x>=('d420))&&(in_cnt_x<=('d451)))      //   »ğ            
		        begin
				 	cnt_x=in_cnt_x-'d420;
					disp_en=1;
					now_num='d8;			         		                                                       
					now_rom='d9;                 
		        end
				else if((in_cnt_x>=('d452))&&(in_cnt_x<=('d483)))      //   Ñæ            
		        begin
				 	cnt_x=in_cnt_x-'d452;
					disp_en=1;
					now_num='d1;			         		                                                       
					now_rom='d11;                 
		        end
				else if((in_cnt_x>=('d484))&&(in_cnt_x<=('d499)))      //   £º            
		        begin
				 	cnt_x=in_cnt_x-'d484;
					disp_en=1;
					now_num='d1;			         		                                                       
					now_rom='d3;                 
		        end
				else if((in_cnt_x>=('d500))&&(in_cnt_x<=('d531)))      //    zheng/yi              
		        begin
				 	cnt_x=in_cnt_x-'d500;
					disp_en=1;
				    if(huo_en)
		    		begin
					    now_num='d5;			         		                                                       
					    now_rom='d2;                     //zheng
					end
					else
					begin
					    now_num='d6;			         		                                                       
					    now_rom='d2;                     //yi
					end
		        end
				else if((in_cnt_x>=('d532))&&(in_cnt_x<=('d563)))      //   chang            
		        begin
				 	cnt_x=in_cnt_x-'d532;
					disp_en=1;
					now_num='d7;			         		                                                       
					now_rom='d2;                 
		        end
				else
		    	begin
				    disp_en=0;
		    	    cnt_x=cnt_x;
		    		now_num=now_num;
					now_rom=0;
		    	end
			end
			else
		    begin
		        cnt_x='d0;
		    	cnt_y='d0;
				disp_en='d0;
		    	now_num='d0;
				now_rom=0;
		    end
		end
	end
	

	
	always@(*)                    //ç¡®å®šromåœ°å€çš„æ¨¡
	begin
	    case(now_num)
		'b1:
		   addr=cnt_y;         // right san
		'd2:
		   addr=cnt_y+'d32;   //fault si 
		'd3:
		   addr=cnt_y+'d64;   //wen 
		'd4:
		   addr=cnt_y+'d96;   //shi
		'd5:
           addr=cnt_y+'d128;  //du
		'd6:
		   addr=cnt_y+'d160;  //lou
		'd7:
		   addr=cnt_y+'d192;  //yi
		'd8:
		   addr=cnt_y+'d224;  //er
		default:;
	    endcase
	end
	
	always@(*)
	begin
	    case(now_rom)
		'd1:begin
		if(data1[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd2:begin
		if(data2[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd3:begin
		if(data3[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd4:begin
		if(data4[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd5:begin
		if(data5[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd6:begin
		if(data6[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd7:begin
		if(data7[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd8:begin
		if(data8[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd9:begin
		if(data9[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd10:begin
		if(data10[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		'd11:begin
		if(data11[cnt_x]&&(disp_en[3]|disp_en[2]|disp_en[1]|disp_en[0]))
		    en=disp_en;
		else
		    en='b0;
		end
		
		default:en='d0;
		endcase
	end
	
	/*rom_iip wenshidu( 
	.doa(data), 
	.addra(addr), 
	.clka(clk), 
	.rsta(1'b0)
	);*/

     		
	rom_iip ipp_1(    //right fault  wen   shi   du   yi  er  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data1), 
	.raddr(addr) 
	);	
	
	rom_iip2 ipp_2(    //san   si  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data2), 
	.raddr(addr) 
	);
	
	rom_iip3 ipp_3(    //right fault  wen   shi   du   yi  er  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data3), 
	.raddr(addr) 
	);	
	
	rom_iip4 ipp_4(    // 6 7 8 9 0 A B C 
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data4), 
	.raddr(addr) 
	);	
	
	rom_iip5 ipp_5(    //Îí Æø Ìå ¹ğ »¦ ½ò ½ú ¾© 
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data5), 
	.raddr(addr) 
	);	
	
	rom_iip6 ipp_6(    //D E F G S I J K  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data6), 
	.raddr(addr) 
	);	
	
	rom_iip7 ipp_7(    //L M N O P Q T U  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data7), 
	.raddr(addr) 
	);	
	
	rom_iip8 ipp_8(    //V W X Y Z  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data8), 
	.raddr(addr) 
	);	
	
	rom_iip9 ipp_9(    //ÉÂ ËÕ Íî Ïæ Ô¥ ÔÁ Õã  »ğ
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data9), 
	.raddr(addr) 
	);	
	rom_iip10 ipp_10 (   //¡ú  
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data10), 
	.raddr(addr) 
	);
	
	rom_iip11 ipp_11 (   //Ñæ
	.di('d0), 
	.waddr('d0), 
	.we('d0), 
	.wclk('d0), 
	.do(data11), 
	.raddr(addr) 
	);
	
	
	
	

	

endmodule
