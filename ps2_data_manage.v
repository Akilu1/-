`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/02 20:44:05
// Design Name: 
// Module Name: ps2_data_manage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ps2_data_manage(
    clk,rst_n,ps2_done,ps2_out_data,ps2_en,register,ps2_out_en
	);
    input clk;
	input rst_n;
	input ps2_done;
	input [7:0]ps2_out_data;
	input  ps2_en;
	output reg [103:0]register;
	output reg ps2_out_en;
	
    reg [7:0]ascii[12:0];
	reg [3:0]i;
	reg [7:0]register_transition[12:0];
	reg tansmit_data_en;  //传输数据使能信号
	
	 wire rst_na;
	 assign rst_na = rst_n & ps2_en;
	 
    always@(posedge clk or negedge rst_na)
    begin
        if(!rst_na)
	    begin  
		    ascii[0] <= 8'h20;
			ascii[1] <= 8'h20;
			ascii[2] <= 8'h20;
			ascii[3] <= 8'h20;
			ascii[4] <= 8'h20;
			ascii[5] <= 8'h20;
			ascii[6] <= 8'h20;
			ascii[7] <= 8'h20;
			ascii[8] <= 8'h20;
			ascii[9] <= 8'h20;
			ascii[10] <= 8'h20;
			ascii[11] <= 8'h20;
			ascii[12] <= 8'h20; 
	    end
	    else //if(done)
	      begin
	  case (register_transition[0])
	  8'h45 : ascii[0] <= 8'h30 ; //0
	  8'h16 : ascii[0] <= 8'h31 ;
	  8'h1e : ascii[0] <= 8'h32 ;
	  8'h26 : ascii[0] <= 8'h33 ;
	  8'h25 : ascii[0] <= 8'h34 ;
	  8'h2e : ascii[0] <= 8'h35 ;
	  8'h36 : ascii[0] <= 8'h36 ;
	  8'h3d : ascii[0] <= 8'h37 ;
	  8'h3e : ascii[0] <= 8'h38 ;
	  8'h46 : ascii[0] <= 8'h39 ;  //9 
	  
	  8'h70 : ascii[0] <= 8'h30 ;
	  8'h69 : ascii[0] <= 8'h31 ;
	  8'h72 : ascii[0] <= 8'h32 ;
	  8'h7a : ascii[0] <= 8'h33 ;
	  8'h6b : ascii[0] <= 8'h34 ;
	  8'h73 : ascii[0] <= 8'h35 ;
	  8'h74 : ascii[0] <= 8'h36 ;
	  8'h60 : ascii[0] <= 8'h37 ;
	  8'h75 : ascii[0] <= 8'h38 ;
	  8'h7d : ascii[0] <= 8'h39 ;
	  8'h5a : ascii[0] <= 8'h5c ; //反斜杠
	  default :ascii[0] <= 8'h67;  //  g
	  endcase
	  case (register_transition[1])
	  8'h45 : ascii[1] <= 8'h30 ;
	  8'h16 : ascii[1] <= 8'h31 ;
	  8'h1e : ascii[1] <= 8'h32 ;
	  8'h26 : ascii[1] <= 8'h33 ;
	  8'h25 : ascii[1] <= 8'h34 ;
	  8'h2e : ascii[1] <= 8'h35 ;
	  8'h36 : ascii[1] <= 8'h36 ;
	  8'h3d : ascii[1] <= 8'h37 ;
	  8'h3e : ascii[1] <= 8'h38 ;
	  8'h46 : ascii[1] <= 8'h39 ; 
	  
	  8'h70 : ascii[1] <= 8'h30 ;
	  8'h69 : ascii[1] <= 8'h31 ;
	  8'h72 : ascii[1] <= 8'h32 ;
	  8'h7a : ascii[1] <= 8'h33 ;
	  8'h6b : ascii[1] <= 8'h34 ;
	  8'h73 : ascii[1] <= 8'h35 ;
	  8'h74 : ascii[1] <= 8'h36 ;
	  8'h60 : ascii[1] <= 8'h37 ;
	  8'h75 : ascii[1] <= 8'h38 ;
	  8'h7d : ascii[1] <= 8'h39 ;
	  8'h5a : ascii[1] <= 8'h5c ;
	  default :ascii[1] <= 8'h67;
	  endcase
	  case (register_transition[2])
	  8'h45 : ascii[2] <= 8'h30 ;
	  8'h16 : ascii[2] <= 8'h31 ;
	  8'h1e : ascii[2] <= 8'h32 ;
	  8'h26 : ascii[2] <= 8'h33 ;
	  8'h25 : ascii[2] <= 8'h34 ;
	  8'h2e : ascii[2] <= 8'h35 ;
	  8'h36 : ascii[2] <= 8'h36 ;
	  8'h3d : ascii[2] <= 8'h37 ;
	  8'h3e : ascii[2] <= 8'h38 ;
	  8'h46 : ascii[2] <= 8'h39 ; 
	  
	  8'h70 : ascii[2] <= 8'h30 ;
	  8'h69 : ascii[2] <= 8'h31 ;
	  8'h72 : ascii[2] <= 8'h32 ;
	  8'h7a : ascii[2] <= 8'h33 ;
	  8'h6b : ascii[2] <= 8'h34 ;
	  8'h73 : ascii[2] <= 8'h35 ;
	  8'h74 : ascii[2] <= 8'h36 ;
	  8'h60 : ascii[2] <= 8'h37 ;
	  8'h75 : ascii[2] <= 8'h38 ;
	  8'h7d : ascii[2] <= 8'h39 ;
	  8'h5a : ascii[2] <= 8'h5c ;
	  default :ascii[2] <= 8'h67;
	  endcase
	  case (register_transition[3])
	  8'h45 : ascii[3] <= 8'h30 ;
	  8'h16 : ascii[3] <= 8'h31 ;
	  8'h1e : ascii[3] <= 8'h32 ;
	  8'h26 : ascii[3] <= 8'h33 ;
	  8'h25 : ascii[3] <= 8'h34 ;
	  8'h2e : ascii[3] <= 8'h35 ;
	  8'h36 : ascii[3] <= 8'h36 ;
	  8'h3d : ascii[3] <= 8'h37 ;
	  8'h3e : ascii[3] <= 8'h38 ;
	  8'h46 : ascii[3] <= 8'h39 ; 
	  
	  8'h70 : ascii[3] <= 8'h30 ;
	  8'h69 : ascii[3] <= 8'h31 ;
	  8'h72 : ascii[3] <= 8'h32 ;
	  8'h7a : ascii[3] <= 8'h33 ;
	  8'h6b : ascii[3] <= 8'h34 ;
	  8'h73 : ascii[3] <= 8'h35 ;
	  8'h74 : ascii[3] <= 8'h36 ;
	  8'h60 : ascii[3] <= 8'h37 ;
	  8'h75 : ascii[3] <= 8'h38 ;
	  8'h7d : ascii[3] <= 8'h39 ;
	  8'h5a : ascii[3] <= 8'h5c ;
	  default :ascii[3] <= 8'h67;
	  endcase
	  case (register_transition[4])
	  8'h45 : ascii[4] <= 8'h30 ;
	  8'h16 : ascii[4] <= 8'h31 ;
	  8'h1e : ascii[4] <= 8'h32 ;
	  8'h26 : ascii[4] <= 8'h33 ;
	  8'h25 : ascii[4] <= 8'h34 ;
	  8'h2e : ascii[4] <= 8'h35 ;
	  8'h36 : ascii[4] <= 8'h36 ;
	  8'h3d : ascii[4] <= 8'h37 ;
	  8'h3e : ascii[4] <= 8'h38 ;
	  8'h46 : ascii[4] <= 8'h39 ; 
	  
	  8'h70 : ascii[4] <= 8'h30 ;
	  8'h69 : ascii[4] <= 8'h31 ;
	  8'h72 : ascii[4] <= 8'h32 ;
	  8'h7a : ascii[4] <= 8'h33 ;
	  8'h6b : ascii[4] <= 8'h34 ;
	  8'h73 : ascii[4] <= 8'h35 ;
	  8'h74 : ascii[4] <= 8'h36 ;
	  8'h60 : ascii[4] <= 8'h37 ;
	  8'h75 : ascii[4] <= 8'h38 ;
	  8'h7d : ascii[4] <= 8'h39 ;
	  8'h5a : ascii[4] <= 8'h5c ;
	  default :ascii[4] <= 8'h5c;
	  endcase
	  case (register_transition[5])
	  8'h45 : ascii[5] <= 8'h30 ;
	  8'h16 : ascii[5] <= 8'h31 ;
	  8'h1e : ascii[5] <= 8'h32 ;
	  8'h26 : ascii[5] <= 8'h33 ;
	  8'h25 : ascii[5] <= 8'h34 ;
	  8'h2e : ascii[5] <= 8'h35 ;
	  8'h36 : ascii[5] <= 8'h36 ;
	  8'h3d : ascii[5] <= 8'h37 ;
	  8'h3e : ascii[5] <= 8'h38 ;
	  8'h46 : ascii[5] <= 8'h39 ; 
	  
	  8'h70 : ascii[5] <= 8'h30 ;
	  8'h69 : ascii[5] <= 8'h31 ;
	  8'h72 : ascii[5] <= 8'h32 ;
	  8'h7a : ascii[5] <= 8'h33 ;
	  8'h6b : ascii[5] <= 8'h34 ;
	  8'h73 : ascii[5] <= 8'h35 ;
	  8'h74 : ascii[5] <= 8'h36 ;
	  8'h60 : ascii[5] <= 8'h37 ;
	  8'h75 : ascii[5] <= 8'h38 ;
	  8'h7d : ascii[5] <= 8'h39 ;
	  8'h5a : ascii[5] <= 8'h5c ;
	  default :ascii[5] <= 8'h5c;
	  endcase
	  case (register_transition[6])
	  8'h45 : ascii[6] <= 8'h30 ;
	  8'h16 : ascii[6] <= 8'h31 ;
	  8'h1e : ascii[6] <= 8'h32 ;
	  8'h26 : ascii[6] <= 8'h33 ;
	  8'h25 : ascii[6] <= 8'h34 ;
	  8'h2e : ascii[6] <= 8'h35 ;
	  8'h36 : ascii[6] <= 8'h36 ;
	  8'h3d : ascii[6] <= 8'h37 ;
	  8'h3e : ascii[6] <= 8'h38 ;
	  8'h46 : ascii[6] <= 8'h39 ; 
	  
	  8'h70 : ascii[6] <= 8'h30 ;
	  8'h69 : ascii[6] <= 8'h31 ;
	  8'h72 : ascii[6] <= 8'h32 ;
	  8'h7a : ascii[6] <= 8'h33 ;
	  8'h6b : ascii[6] <= 8'h34 ;
	  8'h73 : ascii[6] <= 8'h35 ;
	  8'h74 : ascii[6] <= 8'h36 ;
	  8'h60 : ascii[6] <= 8'h37 ;
	  8'h75 : ascii[6] <= 8'h38 ;
	  8'h7d : ascii[6] <= 8'h39 ;
	  8'h5a : ascii[6] <= 8'h5c ;
	  default :ascii[6] <= 8'h68;
	  endcase
	  case (register_transition[7])
	  8'h45 : ascii[7] <= 8'h30 ;
	  8'h16 : ascii[7] <= 8'h31 ;
	  8'h1e : ascii[7] <= 8'h32 ;
	  8'h26 : ascii[7] <= 8'h33 ;
	  8'h25 : ascii[7] <= 8'h34 ;
	  8'h2e : ascii[7] <= 8'h35 ;
	  8'h36 : ascii[7] <= 8'h36 ;
	  8'h3d : ascii[7] <= 8'h37 ;
	  8'h3e : ascii[7] <= 8'h38 ;
	  8'h46 : ascii[7] <= 8'h39 ; 
	  
	  8'h70 : ascii[7] <= 8'h30 ;
	  8'h69 : ascii[7] <= 8'h31 ;
	  8'h72 : ascii[7] <= 8'h32 ;
	  8'h7a : ascii[7] <= 8'h33 ;
	  8'h6b : ascii[7] <= 8'h34 ;
	  8'h73 : ascii[7] <= 8'h35 ;
	  8'h74 : ascii[7] <= 8'h36 ;
	  8'h60 : ascii[7] <= 8'h37 ;
	  8'h75 : ascii[7] <= 8'h38 ;
	  8'h7d : ascii[7] <= 8'h39 ;
	  8'h5a : ascii[7] <= 8'h5c ;
	  default :ascii[7] <= 8'h68;
	  endcase
	  case (register_transition[8])
	  8'h45 : ascii[8] <= 8'h30 ;
	  8'h16 : ascii[8] <= 8'h31 ;
	  8'h1e : ascii[8] <= 8'h32 ;
	  8'h26 : ascii[8] <= 8'h33 ;
	  8'h25 : ascii[8] <= 8'h34 ;
	  8'h2e : ascii[8] <= 8'h35 ;
	  8'h36 : ascii[8] <= 8'h36 ;
	  8'h3d : ascii[8] <= 8'h37 ;
	  8'h3e : ascii[8] <= 8'h38 ;
	  8'h46 : ascii[8] <= 8'h39 ; 
	  
	  8'h70 : ascii[8] <= 8'h30 ;
	  8'h69 : ascii[8] <= 8'h31 ;
	  8'h72 : ascii[8] <= 8'h32 ;
	  8'h7a : ascii[8] <= 8'h33 ;
	  8'h6b : ascii[8] <= 8'h34 ;
	  8'h73 : ascii[8] <= 8'h35 ;
	  8'h74 : ascii[8] <= 8'h36 ;
	  8'h60 : ascii[8] <= 8'h37 ;
	  8'h75 : ascii[8] <= 8'h38 ;
	  8'h7d : ascii[8] <= 8'h39 ;
	  8'h5a : ascii[8] <= 8'h5c ;
	  default :ascii[8] <= 8'h5c;
	  endcase
	  case (register_transition[9])
	  8'h45 : ascii[9] <= 8'h30 ;
	  8'h16 : ascii[9] <= 8'h31 ;
	  8'h1e : ascii[9] <= 8'h32 ;
	  8'h26 : ascii[9] <= 8'h33 ;
	  8'h25 : ascii[9] <= 8'h34 ;
	  8'h2e : ascii[9] <= 8'h35 ;
	  8'h36 : ascii[9] <= 8'h36 ;
	  8'h3d : ascii[9] <= 8'h37 ;
	  8'h3e : ascii[9] <= 8'h38 ;
	  8'h46 : ascii[9] <= 8'h39 ; 
	  
	  8'h70 : ascii[9] <= 8'h30 ;
	  8'h69 : ascii[9] <= 8'h31 ;
	  8'h72 : ascii[9] <= 8'h32 ;
	  8'h7a : ascii[9] <= 8'h33 ;
	  8'h6b : ascii[9] <= 8'h34 ;
	  8'h73 : ascii[9] <= 8'h35 ;
	  8'h74 : ascii[9] <= 8'h36 ;
	  8'h60 : ascii[9] <= 8'h37 ;
	  8'h75 : ascii[9] <= 8'h38 ;
	  8'h7d : ascii[9] <= 8'h39 ;
	  8'h5a : ascii[9] <= 8'h5c ;
	  default :ascii[9] <= 8'h67;
	  endcase
	  case (register_transition[10])
	  8'h45 : ascii[10] <= 8'h30 ;
	  8'h16 : ascii[10] <= 8'h31 ;
	  8'h1e : ascii[10] <= 8'h32 ;
	  8'h26 : ascii[10] <= 8'h33 ;
	  8'h25 : ascii[10] <= 8'h34 ;
	  8'h2e : ascii[10] <= 8'h35 ;
	  8'h36 : ascii[10] <= 8'h36 ;
	  8'h3d : ascii[10] <= 8'h37 ;
	  8'h3e : ascii[10] <= 8'h38 ;
	  8'h46 : ascii[10] <= 8'h39 ; 
	  
	  8'h70 : ascii[10] <= 8'h30 ;
	  8'h69 : ascii[10] <= 8'h31 ;
	  8'h72 : ascii[10] <= 8'h32 ;
	  8'h7a : ascii[10] <= 8'h33 ;
	  8'h6b : ascii[10] <= 8'h34 ;
	  8'h73 : ascii[10] <= 8'h35 ;
	  8'h74 : ascii[10] <= 8'h36 ;
	  8'h60 : ascii[10] <= 8'h37 ;
	  8'h75 : ascii[10] <= 8'h38 ;
	  8'h7d : ascii[10] <= 8'h39 ;
	  8'h5a : ascii[10] <= 8'h5c ;
	  default :ascii[10] <= 8'h67;
	  endcase
	  case (register_transition[11])
	  8'h45 : ascii[11] <= 8'h30 ;
	  8'h16 : ascii[11] <= 8'h31 ;
	  8'h1e : ascii[11] <= 8'h32 ;
	  8'h26 : ascii[11] <= 8'h33 ;
	  8'h25 : ascii[11] <= 8'h34 ;
	  8'h2e : ascii[11] <= 8'h35 ;
	  8'h36 : ascii[11] <= 8'h36 ;
	  8'h3d : ascii[11] <= 8'h37 ;
	  8'h3e : ascii[11] <= 8'h38 ;
	  8'h46 : ascii[11] <= 8'h39 ; 
	  
	  8'h70 : ascii[11] <= 8'h30 ;
	  8'h69 : ascii[11] <= 8'h31 ;
	  8'h72 : ascii[11] <= 8'h32 ;
	  8'h7a : ascii[11] <= 8'h33 ;
	  8'h6b : ascii[11] <= 8'h34 ;
	  8'h73 : ascii[11] <= 8'h35 ;
	  8'h74 : ascii[11] <= 8'h36 ;
	  8'h60 : ascii[11] <= 8'h37 ;
	  8'h75 : ascii[11] <= 8'h38 ;
	  8'h7d : ascii[11] <= 8'h39 ;
	  8'h5a : ascii[11] <= 8'h5c ;
	  default :ascii[11] <= 8'h5c;
	  endcase
	  case (register_transition[12])
	  8'h45 : ascii[12] <= 8'h30 ;
	  8'h16 : ascii[12] <= 8'h31 ;
	  8'h1e : ascii[12] <= 8'h32 ;
	  8'h26 : ascii[12] <= 8'h33 ;
	  8'h25 : ascii[12] <= 8'h34 ;
	  8'h2e : ascii[12] <= 8'h35 ;
	  8'h36 : ascii[12] <= 8'h36 ;
	  8'h3d : ascii[12] <= 8'h37 ;
	  8'h3e : ascii[12] <= 8'h38 ;
	  8'h46 : ascii[12] <= 8'h39 ; 
	  
	  8'h70 : ascii[12] <= 8'h30 ;
	  8'h69 : ascii[12] <= 8'h31 ;
	  8'h72 : ascii[12] <= 8'h32 ;
	  8'h7a : ascii[12] <= 8'h33 ;
	  8'h6b : ascii[12] <= 8'h34 ;
	  8'h73 : ascii[12] <= 8'h35 ;
	  8'h74 : ascii[12] <= 8'h36 ;
	  8'h60 : ascii[12] <= 8'h37 ;
	  8'h75 : ascii[12] <= 8'h38 ;
	  8'h7d : ascii[12] <= 8'h39 ;
	  8'h5a : ascii[12] <= 8'h5c ;
	  default :ascii[12] <= 8'h67;
	  endcase
	  
    end	 
  end 
  
	  always@(posedge clk or negedge rst_na)
	  begin
		if(!rst_na)
		begin
			//register <= 88'h2020202020202020202020;
			register_transition[0] <= 8'h20;
			register_transition[1] <= 8'h20;
			register_transition[2] <= 8'h20;
			register_transition[3] <= 8'h20;
			register_transition[4] <= 8'h20;
			register_transition[5] <= 8'h20;
			register_transition[6] <= 8'h20;
			register_transition[7] <= 8'h20;
			register_transition[8] <= 8'h20;
			register_transition[9] <= 8'h20;
			register_transition[10] <= 8'h20;
			register_transition[11] <= 8'h20;
			register_transition[12] <= 8'h20; 
			tansmit_data_en<=1'b0;
			i <= 0;
		end
		else if(ps2_done == 1)
		 begin
			case(i)
				4'd0:begin
					register_transition[0] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd1:begin
					register_transition[1] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd2:begin
					register_transition[2] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd3:begin
					register_transition[3] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd4:begin
					register_transition[4] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd5:begin
					register_transition[5] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd6:begin
					register_transition[6] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd7:begin
					register_transition[7] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd8:begin
					register_transition[8] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd9:begin
					register_transition[9] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd10:begin
					register_transition[10] <= ps2_out_data;
					i <= i + 1'b1;
					tansmit_data_en<=1'b0;
				  end
				4'd11:begin
						register_transition[11] <= ps2_out_data;
						i <= i + 1'b1;
						tansmit_data_en<=1'b0;
				  end
				4'd12:begin
					    register_transition[12] <= ps2_out_data;
						i <= i + 1'b1;
                        tansmit_data_en<=1'b0;						
				  end
				4'd13:begin
						i <= 0;
                        tansmit_data_en<=1'b1;						
				  end
				default : begin
				           i<=0;
						   tansmit_data_en<=1'b0;
						  end
			endcase
			end	
	else 
	  tansmit_data_en<=1'b0;
	  end
	 
 
	   // reg [25:0]cnt;
	  // always@(posedge clk or negedge rst_na )
	  // begin
	
		// if(rst_na==0 && queding_reg == 0)begin
			// cnt <= 0;
			// reg_rst <= 1;
		// end
		// else if (queding_reg ==1)begin 
	    // if(cnt <100000000 )begin
		    // cnt <= cnt + 1;
			// reg_rst <=1;
		// end 
		// else if(cnt ==100000000)begin 	
			// reg_rst <=0;
			// cnt <= 0   ;
		// end
		// end 
	// end 
	  							
	always@(posedge clk or negedge rst_na )
    begin 
	if(!rst_na)
	   begin
	   register <= 104'h2020_2020_2020_2020_2020_2020_20;
	   ps2_out_en<=1'b0;
	    end 
	else if(tansmit_data_en==1'b1) //如果�?????????后一位为回车键，那么输入的为手机号�?�否则的话输入为单号
			begin	
			 register <= {	ascii[0],
							ascii[1],
							ascii[2],
							ascii[3],
							ascii[4],
							ascii[5],
							ascii[6],
							ascii[7],
							ascii[8],
							ascii[9],
							ascii[10],
							ascii[11],
							ascii[12]
							};
			ps2_out_en<=1'b1;					  
			end
	else   
	   begin
	   register <= register;
	   ps2_out_en<=1'b0;
	   end
    end
	// assign register_dh =(select==4'd6) ?  register_dhout : 96'h2020_2020_2020_2020_2020_2020;
	// assign register =(select==4'd1) ?  registerout : 88'h2020_2020_2020_2020_2020_20;
	 // assign reg_rst = ((registerout[87:48]==registerout[39:0]&&registerout!=88'h2020_2020_2020_2020_2020_20) || 
					   // (register_dhout[87:48]==register_dhout[39:0]&&register_dhout!=96'h2020_2020_2020_2020_2020_2020)) ? 1'b1 :1'b0 ;
endmodule
