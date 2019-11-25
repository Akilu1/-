`timescale 1ns / 1ps
module addr_con( 
in_u,
in_d,
in_l,
in_r,
clk_24m,
rst_n,
addr
);
input in_d,in_l,in_r,in_u,clk_24m,rst_n;
output [4:0]addr;

wire en_u,en_d,en_l,en_r;
wire up_u,up_d,up_l,up_r;
reg lay_u,lay_d,lay_l,lay_r;
reg [3:0]addr_r;

assign up_d=en_d&(~lay_d);
assign up_l=en_l&(~lay_l);
assign up_r=en_r&(~lay_r);
assign up_u=en_u&(~lay_u);

always@(posedge clk_24m or negedge rst_n)
begin
    if(rst_n==0)
	begin 
	    lay_d<=0;
		lay_l<=0;
		lay_r<=0;
		lay_u<=0;
	end
	else
	begin
	    lay_d<=en_d;
		lay_l<=en_l;
		lay_r<=en_r;
		lay_u<=en_u;
	end
end
	
key_filter_1s up(  //filter  n:过滤器；筛造v:滤过，渗入；
    .clk(clk_24m),
	.rst_n(rst_n),
	.key_in(~in_u),
	.key_flag(en_u),
	.key_state()
	);
key_filter_1s down(  //filter  n:过滤器；筛造v:滤过，渗入；
    .clk(clk_24m),
	.rst_n(rst_n),
	.key_in(~in_d),
	.key_flag(en_d),
	.key_state()
	);

key_filter_1s left(  //filter  n:过滤器；筛造v:滤过，渗入；
    .clk(clk_24m),
	.rst_n(rst_n),
	.key_in(~in_l),
	.key_flag(en_l),
	.key_state()
	);

key_filter_1s right(  //filter  n:过滤器；筛造v:滤过，渗入；
    .clk(clk_24m),
	.rst_n(rst_n),
	.key_in(~in_r),
	.key_flag(en_r),
	.key_state()
	);
	
	always@(posedge clk_24m or negedge rst_n)
	begin
	    if(rst_n==0)
		    addr_r<=0;
		else
		begin
		    if(up_d)
		    	addr_r<=addr_r-'d4;
		    else if(up_l)
                addr_r<=addr_r-'d1;
			else if(up_r)
			    addr_r<=addr_r+'d1;
			else if(up_u)
			    addr_r<=addr_r+'d4;
		    else
			    addr_r<=addr_r;
		end
	end
	
	assign addr=addr_r+1;
	



endmodule
