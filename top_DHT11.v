`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:57:38 10/14/2019 
// Design Name: 
// Module Name:    top_DHT11 
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
module top_DHT11(
    clk_25MHZ,
	rst_n,
	data,
	temperature_decade,
	humidity_decade,
	humidity_one,
	temperature_one
    );
	
	
	/////////////////////////////////////////////
	wire [7:0] humidity_int;
	wire [7:0] humidity_float;
	wire [7:0] temperature_int;
	wire [7:0] temperature_float;
	input clk_25MHZ,rst_n;
	inout data;
	/////////////////////////////////////////////
	output wire [3:0] humidity_decade;
	output wire [3:0] humidity_one;

	
	/////////////////////////////////////////////
	output wire [3:0] temperature_decade;
	output wire [3:0] temperature_one;

	
	Hex_BCD U_Hex_BCD (
		.humidity_int(humidity_int), 
		.humidity_float(humidity_float), 
		.temperature_int(temperature_int), 
		.temperature_float(temperature_float), 
		.humidity_decade(humidity_decade), 
		.humidity_one(humidity_one), 
		.humidity_decimal(), 
		.temperature_decade(temperature_decade),    //humidity_decade,	//10   RH
		.temperature_one(temperature_one),          //humidity_one,		//1
		.temperature_decimal()                      //humidity_decimal,	//0.1
		);                                          //temperature_decade,	//10 oc
		                                            //temperature_one,	//1
	DHT11_mod U_DHT11_mod (                         //temperature_decimal //0.1
		.clk(clk_25MHZ), 
		.rst_n(rst_n), 
		.data(data), 
		.data_rdy(), 
		.humidity_int(humidity_int), 
		.humidity_float(humidity_float), 
		.temperature_int(temperature_int), 
		.temperature_float(temperature_float)
		);
		
	
			
	
	
endmodule


