`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:38:15 11/24/2018 
// Design Name: 
// Module Name:    provide_uart_tx_data 
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
//提供数据模块
 module provide_uart_tx_data(
    clk,rst_n,tx_down,date_byte,send_en,key_in_save,key_in_fetch,yuyin_one_en,yuyin_end_en,location_end,jingbao);
	input clk;         //系统时钟
	input rst_n;       //系统复位
	input[1:0]yuyin_one_en;
	input[1:0]yuyin_end_en;
	input [6:0]location_end;
	input tx_down;   //一个字节发送完成信�
	input key_in_save;
	input key_in_fetch;
	input jingbao;
	output reg [7:0] date_byte;        //输出�位数�
	output send_en;          //发送使能信�
	reg send_en_a;          //按键按下时开始发送第一位的使能信号
	reg send_en_b;          //一个字节发送完成，发送下一位的使能信号
	reg send_en_c;
	wire send_en_one;
	reg [5:0]state;   //发送状�
	reg [3:0]cnt1,cnt2,cnt3,cnt4,cnt5,cnt6,cnt7,cnt8,cnt9,cnt10,cnt11,cnt12,cnt13,cnt14,cnt15,cnt16,cnt17,cnt18,cnt19,cnt20,cnt21,
				cnt22,cnt23,cnt24,cnt25,cnt26,cnt27,cnt28,cnt29,cnt30,cnt31,cnt32,cnt33,cnt34,cnt35,cnt36,cnt37;
	reg [7:0] data_byte1,data_byte2,data_byte3,data_byte4,data_byte5,data_byte6,data_byte7,data_byte8,data_byte9,data_byte10,data_byte11,
				data_byte12,data_byte13,data_byte14,data_byte15,data_bytea16,data_bytea17,data_bytea18,data_bytea19,data_bytea20,data_bytea21,data_bytea22,
				data_bytea23,data_bytea24,data_bytea25,data_bytea26,data_bytea27,data_bytea28,data_bytea29,data_bytea30,data_bytea31,data_bytea32,data_bytea33,
				data_bytea34,data_bytea35,data_bytea36,data_bytea37;
	
	//发送状态确�
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		state<=6'd0;
		send_en_a<=1'b0;
		end
	else if(yuyin_one_en==2'b10)
		begin
		state<= 6'd36;
		send_en_a<=1'b1;
		end
	else if(yuyin_one_en==2'b01)
		begin
		state<= 6'd33;
		send_en_a<=1'b1;
		end
	else if(yuyin_end_en==2'b01)
		begin
		state<= 6'd35;
		send_en_a<=1'b1;
		end
	else if(yuyin_end_en==2'b10)
		begin
		state<= 6'd34;
		send_en_a<=1'b1;
		end
	else if(jingbao)
		begin
		state<= 6'd37;
		send_en_a<=1'b1;
		end
	else if(key_in_fetch|key_in_save)
        begin
		send_en_a<=1'b0;
		case(location_end)
		7'b001_001_0:begin state<=6'd1;send_en_c<=1'b1;end
		7'b001_010_0:begin state<=6'd2;send_en_c<=1'b1;end
		7'b001_011_0:begin state<=6'd3;send_en_c<=1'b1;end
		7'b001_100_0:begin state<=6'd4;send_en_c<=1'b1;end
		7'b011_001_0:begin state<=6'd5;send_en_c<=1'b1;end
		7'b011_010_0:begin state<=6'd6;send_en_c<=1'b1;end
		7'b011_011_0:begin state<=6'd7;send_en_c<=1'b1;end
		7'b011_100_0:begin state<=6'd8;send_en_c<=1'b1;end
		7'b101_001_0:begin state<=6'd9;send_en_c<=1'b1;end
		7'b101_010_0:begin state<=6'd10;send_en_c<=1'b1;end
		7'b101_011_0:begin state<=6'd11;send_en_c<=1'b1;end
		7'b101_100_0:begin state<=6'd12;send_en_c<=1'b1;end
		7'b111_001_0:begin state<=6'd13;send_en_c<=1'b1;end
		7'b111_010_0:begin state<=6'd14;send_en_c<=1'b1;end
		7'b111_011_0:begin state<=6'd15;send_en_c<=1'b1;end
		7'b111_100_0:begin state<=6'd16;send_en_c<=1'b1;end
		7'b000_001_0:begin state<=6'd17;send_en_c<=1'b1;end
		7'b000_010_0:begin state<=6'd18;send_en_c<=1'b1;end
		7'b000_011_0:begin state<=6'd19;send_en_c<=1'b1;end
		7'b000_100_0:begin state<=6'd20;send_en_c<=1'b1;end
		7'b010_001_0:begin state<=6'd21;send_en_c<=1'b1;end
		7'b010_010_0:begin state<=6'd22;send_en_c<=1'b1;end
		7'b010_011_0:begin state<=6'd23;send_en_c<=1'b1;end
		7'b010_100_0:begin state<=6'd24;send_en_c<=1'b1;end
		7'b100_001_0:begin state<=6'd25;send_en_c<=1'b1;end
		7'b100_010_0:begin state<=6'd26;send_en_c<=1'b1;end
		7'b100_011_0:begin state<=6'd27;send_en_c<=1'b1;end
		7'b100_100_0:begin state<=6'd28;send_en_c<=1'b1;end
		7'b110_001_0:begin state<=6'd29;send_en_c<=1'b1;end
		7'b110_010_0:begin state<=6'd30;send_en_c<=1'b1;end
		7'b110_011_0:begin state<=6'd31;send_en_c<=1'b1;end
		7'b110_100_0:begin state<=6'd32;send_en_c<=1'b1;end
		default:begin state<=state;send_en_c<=1'b0;end
		endcase
        end		
	else
			begin
			state<=state;
			send_en_c<=1'b0;
			send_en_a<=1'b0;
			end
	end
	
	//确定发送信�
	assign send_en_one=send_en_a|send_en_c;
	assign send_en=send_en_one|send_en_b;

	//发送选择模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
	begin
	    send_en_b<=1'b0;
		cnt1<=5'd0;cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
		cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
		cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
		cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
		cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
	end
	else
	    begin
		case(state)
		6'd1:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt1<=4'd0;
				end
			else if(tx_down&(cnt1<5'd6))
				begin
				cnt1<=cnt1+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt1<=cnt1;
				end
			end
		6'd2:
			begin
			cnt1<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt2<=4'd0;
				end
			else if(tx_down&(cnt2<5'd6))
				begin
				cnt2<=cnt2+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt2<=cnt2;
				end
			end
			
		6'd3:
			begin
			cnt2<=5'd0;cnt1<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt3<=4'd0;
				end
			else if(tx_down&(cnt3<5'd6))
				begin
				cnt3<=cnt3+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt3<=cnt3;
				end
			end
		6'd4:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt1<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt4<=4'd0;
				end
			else if(tx_down&(cnt4<5'd6))
				begin
				cnt4<=cnt4+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt4<=cnt4;
				end
			end
		6'd5:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt1<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt5<=4'd0;
				end
			else if(tx_down&(cnt5<5'd6))
				begin
				cnt5<=cnt5+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt5<=cnt5;
				end
			end
		6'd6:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt1<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt6<=4'd0;
				end
			else if(tx_down&(cnt6<5'd6))
				begin
				cnt6<=cnt6+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt6<=cnt6;
				end
			end
		6'd7:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt1<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt7<=4'd0;
				end
			else if(tx_down&(cnt7<5'd6))
				begin
				cnt7<=cnt7+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt7<=cnt7;
				end
			end
		6'd8:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt1<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt8<=4'd0;
				end
			else if(tx_down&(cnt8<5'd6))
				begin
				cnt8<=cnt8+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt8<=cnt8;
				end
			end
		6'd9:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt1<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt9<=4'd0;
				end
			else if(tx_down&(cnt9<5'd6))
				begin
				cnt9<=cnt9+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt9<=cnt9;
				end
			end
		6'd10:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt1<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt10<=4'd0;
				end
			else if(tx_down&(cnt10<5'd6))
				begin
				cnt10<=cnt10+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt10<=cnt10;
				end
			end
		6'd11:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt1<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt11<=4'd0;
				end
			else if(tx_down&(cnt11<5'd6))
				begin
				cnt11<=cnt11+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt11<=cnt11;
				end
			end
		6'd12:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt1<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt12<=4'd0;
				end
			else if(tx_down&(cnt12<5'd6))
				begin
				cnt12<=cnt12+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt12<=cnt12;
				end
			end
		6'd13:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt1<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt13<=4'd0;
				end
			else if(tx_down&(cnt13<5'd6))
				begin
				cnt13<=cnt13+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt13<=cnt13;
				end
			end
		6'd14:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt1<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt14<=4'd0;
				end
			else if(tx_down&(cnt14<5'd6))
				begin
				cnt14<=cnt14+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt14<=cnt14;
				end
			end
		6'd15:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt1<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt15<=4'd0;
				end
			else if(tx_down&(cnt15<5'd6))
				begin
				cnt15<=cnt15+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt15<=cnt15;
				end
			end
		6'd16:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt1<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt16<=4'd0;
				end
			else if(tx_down&(cnt16<5'd6))
				begin
				cnt16<=cnt16+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt16<=cnt16;
				end
			end
		6'd17:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt1<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt17<=4'd0;
				end
			else if(tx_down&(cnt17<5'd6))
				begin
				cnt17<=cnt17+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt17<=cnt17;
				end
			end
		6'd18:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt1<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt18<=4'd0;
				end
			else if(tx_down&(cnt18<5'd6))
				begin
				cnt18<=cnt18+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt18<=cnt18;
				end
			end
		6'd19:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt1<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt19<=4'd0;
				end
			else if(tx_down&(cnt19<5'd6))
				begin
				cnt19<=cnt19+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt19<=cnt19;
				end
			end
		6'd20:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt1<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt20<=4'd0;
				end
			else if(tx_down&(cnt20<5'd6))
				begin
				cnt20<=cnt20+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt20<=cnt20;
				end
			end
		6'd21:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt1<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt21<=4'd0;
				end
			else if(tx_down&(cnt21<5'd6))
				begin
				cnt21<=cnt21+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt21<=cnt21;
				end
			end
		6'd22:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt1<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt22<=4'd0;
				end
			else if(tx_down&(cnt22<5'd6))
				begin
				cnt22<=cnt22+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt22<=cnt22;
				end
			end
		6'd23:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt1<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt23<=4'd0;
				end
			else if(tx_down&(cnt23<5'd6))
				begin
				cnt23<=cnt23+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt23<=cnt23;
				end
			end
		6'd24:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt1<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt24<=4'd0;
				end
			else if(tx_down&(cnt24<5'd6))
				begin
				cnt24<=cnt24+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt24<=cnt24;
				end
			end
		6'd25:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt1<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt25<=4'd0;
				end
			else if(tx_down&(cnt25<5'd6))
				begin
				cnt25<=cnt25+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt25<=cnt25;
				end
			end
		6'd26:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt1<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt26<=4'd0;
				end
			else if(tx_down&(cnt26<5'd6))
				begin
				cnt26<=cnt26+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt26<=cnt26;
				end
			end
		6'd27:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt1<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt27<=4'd0;
				end
			else if(tx_down&(cnt27<5'd6))
				begin
				cnt27<=cnt27+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt27<=cnt27;
				end
			end
		6'd28:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt1<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt28<=4'd0;
				end
			else if(tx_down&(cnt28<5'd6))
				begin
				cnt28<=cnt28+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt28<=cnt28;
				end
			end
		6'd29:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt1<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt29<=4'd0;
				end
			else if(tx_down&(cnt29<5'd6))
				begin
				cnt29<=cnt29+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt29<=cnt29;
				end
			end
		6'd30:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt1<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt30<=4'd0;
				end
			else if(tx_down&(cnt30<5'd6))
				begin
				cnt30<=cnt30+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt30<=cnt30;
				end
			end
		6'd31:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt1<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt31<=4'd0;
				end
			else if(tx_down&(cnt31<5'd6))
				begin
				cnt31<=cnt31+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt31<=cnt31;
				end
			end
		6'd32:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt1<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt32<=4'd0;
				end
			else if(tx_down&(cnt32<5'd6))
				begin
				cnt32<=cnt32+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt32<=cnt32;
				end
			end
		6'd33:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt1<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt33<=4'd0;
				end
			else if(tx_down&(cnt33<5'd6))
				begin
				cnt33<=cnt33+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt33<=cnt33;
				end
			end
		6'd34:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt1<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt34<=4'd0;
				end
			else if(tx_down&(cnt34<5'd6))
				begin
				cnt34<=cnt34+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt34<=cnt34;
				end
			end
		6'd35:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt1<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt35<=4'd0;
				end
			else if(tx_down&(cnt35<5'd6))
				begin
				cnt35<=cnt35+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt35<=cnt35;
				end
			end
		6'd36:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt1<=5'd0;cnt37<=5'd0;
			if(send_en_one)
				begin
				cnt36<=4'd0;
				end
			else if(tx_down&(cnt36<5'd6))
				begin
				cnt36<=cnt36+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt36<=cnt36;
				end
			end
		6'd37:
			begin
			cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt1<=5'd0;
			if(send_en_one)
				begin
				cnt37<=4'd0;
				end
			else if(tx_down&(cnt37<5'd6))
				begin
				cnt37<=cnt37+1'b1;
				send_en_b<=1'b1;
				end
			else
				begin
				send_en_b<=1'b0;
				cnt37<=cnt37;
				end
			end
		default:
		    begin
	        send_en_b<=1'b0;
		    cnt1<=5'd0;cnt2<=5'd0;cnt3<=5'd0;cnt4<=5'd0;cnt5<=5'd0;cnt6<=5'd0;cnt7<=5'd0;cnt8<=5'd0;
			cnt9<=5'd0;cnt10<=5'd0;cnt11<=5'd0;cnt12<=5'd0;cnt13<=5'd0;cnt14<=5'd0;cnt15<=5'd0;
			cnt16<=5'd0;cnt17<=5'd0;cnt18<=5'd0;cnt19<=5'd0;cnt20<=5'd0;cnt21<=5'd0;cnt22<=5'd0;
			cnt23<=5'd0;cnt24<=5'd0;cnt25<=5'd0;cnt26<=5'd0;cnt27<=5'd0;cnt28<=5'd0;cnt29<=5'd0;
			cnt30<=5'd0;cnt31<=5'd0;cnt32<=5'd0;cnt33<=5'd0;cnt34<=5'd0;cnt35<=5'd0;cnt36<=5'd0;cnt37<=5'd0;
	        end
		endcase
	    end
	end
	
	//数据提供模块
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte1<=8'b0;
	else
		case(cnt1)
			4'd0:data_byte1<=8'hAA;
			4'd1:data_byte1<=8'h07;
			4'd2:data_byte1<=8'h02;
			4'd3:data_byte1<=8'h00;
			4'd4:data_byte1<=8'h01;
			4'd5:data_byte1<=8'hB4;
			default:data_byte1 <=8'b0;
		endcase
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte2<=8'b0;
	else
		case(cnt2)
			4'd0:data_byte2<=8'hAA;
			4'd1:data_byte2<=8'h07;
			4'd2:data_byte2<=8'h02;
			4'd3:data_byte2<=8'h00;
			4'd4:data_byte2<=8'h02;
			4'd5:data_byte2<=8'hB5;
			default:data_byte2 <=8'b0;
		endcase
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte3<=8'b0;
	else
		case(cnt3)
			4'd0:data_byte3<=8'hAA;
			4'd1:data_byte3<=8'h07;
			4'd2:data_byte3<=8'h02;
			4'd3:data_byte3<=8'h00;
			4'd4:data_byte3<=8'h03;
			4'd5:data_byte3<=8'hB6;
			default:data_byte3 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte4<=8'b0;
	else
		case(cnt4)
			4'd0:data_byte4<=8'hAA;
			4'd1:data_byte4<=8'h07;
			4'd2:data_byte4<=8'h02;
			4'd3:data_byte4<=8'h00;
			4'd4:data_byte4<=8'h04;
			4'd5:data_byte4<=8'hB7;
			default:data_byte4 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte5<=8'b0;
	else
		case(cnt5)
			4'd0:data_byte5<=8'hAA;
			4'd1:data_byte5<=8'h07;
			4'd2:data_byte5<=8'h02;
			4'd3:data_byte5<=8'h00;
			4'd4:data_byte5<=8'h05;
			4'd5:data_byte5<=8'hB8;
			default:data_byte5<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte6<=8'b0;
	else
		case(cnt6)
			4'd0:data_byte6<=8'hAA;
			4'd1:data_byte6<=8'h07;
			4'd2:data_byte6<=8'h02;
			4'd3:data_byte6<=8'h00;
			4'd4:data_byte6<=8'h06;
			4'd5:data_byte6<=8'hB9;
			default:data_byte6 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte7<=8'b0;
	else
		case(cnt7)
			4'd0:data_byte7<=8'hAA;
			4'd1:data_byte7<=8'h07;
			4'd2:data_byte7<=8'h02;
			4'd3:data_byte7<=8'h00;
			4'd4:data_byte7<=8'h07;
			4'd5:data_byte7<=8'hBA;
			default:data_byte7 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte8<=8'b0;
	else
		case(cnt8)
			4'd0:data_byte8<=8'hAA;
			4'd1:data_byte8<=8'h07;
			4'd2:data_byte8<=8'h02;
			4'd3:data_byte8<=8'h00;
			4'd4:data_byte8<=8'h08;
			4'd5:data_byte8<=8'hBB;
			default:data_byte8 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte9<=8'b0;
	else
		case(cnt9)
			4'd0:data_byte9<=8'hAA;
			4'd1:data_byte9<=8'h07;
			4'd2:data_byte9<=8'h02;
			4'd3:data_byte9<=8'h00;
			4'd4:data_byte9<=8'h09;
			4'd5:data_byte9<=8'hBC;
			default:data_byte9 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte10<=8'b0;
	else
		case(cnt10)
			4'd0:data_byte10<=8'hAA;
			4'd1:data_byte10<=8'h07;
			4'd2:data_byte10<=8'h02;
			4'd3:data_byte10<=8'h00;
			4'd4:data_byte10<=8'h0A;
			4'd5:data_byte10<=8'hBD;
			default:data_byte10 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte11<=8'b0;
	else
		case(cnt11)
			4'd0:data_byte11<=8'hAA;
			4'd1:data_byte11<=8'h07;
			4'd2:data_byte11<=8'h02;
			4'd3:data_byte11<=8'h00;
			4'd4:data_byte11<=8'h0B;
			4'd5:data_byte11<=8'hBE;
			default:data_byte11 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte12<=8'b0;
	else
		case(cnt12)
			4'd0:data_byte12<=8'hAA;
			4'd1:data_byte12<=8'h07;
			4'd2:data_byte12<=8'h02;
			4'd3:data_byte12<=8'h00;
			4'd4:data_byte12<=8'h0C;
			4'd5:data_byte12<=8'hBF;
			default:data_byte12 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte13<=8'b0;
	else
		case(cnt13)
			4'd0:data_byte13<=8'hAA;
			4'd1:data_byte13<=8'h07;
			4'd2:data_byte13<=8'h02;
			4'd3:data_byte13<=8'h00;
			4'd4:data_byte13<=8'h0D;
			4'd5:data_byte13<=8'hC0;
			default:data_byte13 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte14<=8'b0;
	else
		case(cnt14)
			4'd0:data_byte14<=8'hAA;
			4'd1:data_byte14<=8'h07;
			4'd2:data_byte14<=8'h02;
			4'd3:data_byte14<=8'h00;
			4'd4:data_byte14<=8'h0E;
			4'd5:data_byte14<=8'hC1;
			default:data_byte14 <=8'b0;
		endcase
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_byte15<=8'b0;
	else
		case(cnt15)
			4'd0:data_byte15<=8'hAA;
			4'd1:data_byte15<=8'h07;
			4'd2:data_byte15<=8'h02;
			4'd3:data_byte15<=8'h00;
			4'd4:data_byte15<=8'h0F;
			4'd5:data_byte15<=8'hC2;
			default:data_byte15 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea16<=8'b0;
	else
		case(cnt16)
			4'd0:data_bytea16<=8'hAA;
			4'd1:data_bytea16<=8'h07;
			4'd2:data_bytea16<=8'h02;
			4'd3:data_bytea16<=8'h00;
			4'd4:data_bytea16<=8'h10;
			4'd5:data_bytea16<=8'hC3;
			default:data_bytea16 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea17<=8'b0;
	else
		case(cnt17)
			4'd0:data_bytea17<=8'hAA;
			4'd1:data_bytea17<=8'h07;
			4'd2:data_bytea17<=8'h02;
			4'd3:data_bytea17<=8'h00;
			4'd4:data_bytea17<=8'h11;
			4'd5:data_bytea17<=8'hC4;
			default:data_bytea17 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea18<=8'b0;
	else
		case(cnt18)
			4'd0:data_bytea18<=8'hAA;
			4'd1:data_bytea18<=8'h07;
			4'd2:data_bytea18<=8'h02;
			4'd3:data_bytea18<=8'h00;
			4'd4:data_bytea18<=8'h12;
			4'd5:data_bytea18<=8'hC5;
			default:data_bytea18<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea19<=8'b0;
	else
		case(cnt19)
			4'd0:data_bytea19<=8'hAA;
			4'd1:data_bytea19<=8'h07;
			4'd2:data_bytea19<=8'h02;
			4'd3:data_bytea19<=8'h00;
			4'd4:data_bytea19<=8'h13;
			4'd5:data_bytea19<=8'hC6;
			default:data_bytea19 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea20<=8'b0;
	else
		case(cnt20)
			4'd0:data_bytea20<=8'hAA;
			4'd1:data_bytea20<=8'h07;
			4'd2:data_bytea20<=8'h02;
			4'd3:data_bytea20<=8'h00;
			4'd4:data_bytea20<=8'h14;
			4'd5:data_bytea20<=8'hC7;
			default:data_bytea20 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea21<=8'b0;
	else
		case(cnt21)
			4'd0:data_bytea21<=8'hAA;
			4'd1:data_bytea21<=8'h07;
			4'd2:data_bytea21<=8'h02;
			4'd3:data_bytea21<=8'h00;
			4'd4:data_bytea21<=8'h15;
			4'd5:data_bytea21<=8'hC8;
			default:data_bytea21 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea22<=8'b0;
	else
		case(cnt22)
			4'd0:data_bytea22<=8'hAA;
			4'd1:data_bytea22<=8'h07;
			4'd2:data_bytea22<=8'h02;
			4'd3:data_bytea22<=8'h00;
			4'd4:data_bytea22<=8'h16;
			4'd5:data_bytea22<=8'hC9;
			default:data_bytea22<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea23<=8'b0;
	else
		case(cnt23)
			4'd0:data_bytea23<=8'hAA;
			4'd1:data_bytea23<=8'h07;
			4'd2:data_bytea23<=8'h02;
			4'd3:data_bytea23<=8'h00;
			4'd4:data_bytea23<=8'h17;
			4'd5:data_bytea23<=8'hCA;
			default:data_bytea23<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea24<=8'b0;
	else
		case(cnt24)
			4'd0:data_bytea24<=8'hAA;
			4'd1:data_bytea24<=8'h07;
			4'd2:data_bytea24<=8'h02;
			4'd3:data_bytea24<=8'h00;
			4'd4:data_bytea24<=8'h18;
			4'd5:data_bytea24<=8'hCB;
			default:data_bytea24 <=8'b0;
		endcase
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea25<=8'b0;
	else
		case(cnt25)
			4'd0:data_bytea25<=8'hAA;
			4'd1:data_bytea25<=8'h07;
			4'd2:data_bytea25<=8'h02;
			4'd3:data_bytea25<=8'h00;
			4'd4:data_bytea25<=8'h19;
			4'd5:data_bytea25<=8'hCC;
			default:data_bytea25<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea26<=8'b0;
	else
		case(cnt26)
			4'd0:data_bytea26<=8'hAA;
			4'd1:data_bytea26<=8'h07;
			4'd2:data_bytea26<=8'h02;
			4'd3:data_bytea26<=8'h00;
			4'd4:data_bytea26<=8'h1A;
			4'd5:data_bytea26<=8'hCD;
			default:data_bytea26 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea27<=8'b0;
	else
		case(cnt27)
			4'd0:data_bytea27<=8'hAA;
			4'd1:data_bytea27<=8'h07;
			4'd2:data_bytea27<=8'h02;
			4'd3:data_bytea27<=8'h00;
			4'd4:data_bytea27<=8'h1B;
			4'd5:data_bytea27<=8'hCE;
			default:data_bytea27<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea28<=8'b0;
	else
		case(cnt28)
			4'd0:data_bytea28<=8'hAA;
			4'd1:data_bytea28<=8'h07;
			4'd2:data_bytea28<=8'h02;
			4'd3:data_bytea28<=8'h00;
			4'd4:data_bytea28<=8'h1C;
			4'd5:data_bytea28<=8'hCF;
			default:data_bytea28 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea29<=8'b0;
	else
		case(cnt29)
			4'd0:data_bytea29<=8'hAA;
			4'd1:data_bytea29<=8'h07;
			4'd2:data_bytea29<=8'h02;
			4'd3:data_bytea29<=8'h00;
			4'd4:data_bytea29<=8'h1D;
			4'd5:data_bytea29<=8'hD0;
			default:data_bytea29 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea30<=8'b0;
	else
		case(cnt30)
			4'd0:data_bytea30<=8'hAA;
			4'd1:data_bytea30<=8'h07;
			4'd2:data_bytea30<=8'h02;
			4'd3:data_bytea30<=8'h00;
			4'd4:data_bytea30<=8'h1E;
			4'd5:data_bytea30<=8'hD1;
			default:data_bytea30 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea31<=8'b0;
	else
		case(cnt31)
			4'd0:data_bytea31<=8'hAA;
			4'd1:data_bytea31<=8'h07;
			4'd2:data_bytea31<=8'h02;
			4'd3:data_bytea31<=8'h00;
			4'd4:data_bytea31<=8'h1F;
			4'd5:data_bytea31<=8'hD2;
			default:data_bytea31 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea32<=8'b0;
	else
		case(cnt32)
			4'd0:data_bytea32<=8'hAA;
			4'd1:data_bytea32<=8'h07;
			4'd2:data_bytea32<=8'h02;
			4'd3:data_bytea32<=8'h00;
			4'd4:data_bytea32<=8'h20;
			4'd5:data_bytea32<=8'hD3;
			default:data_bytea32 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea33<=8'b0;
	else
		case(cnt33)
			4'd0:data_bytea33<=8'hAA;
			4'd1:data_bytea33<=8'h07;
			4'd2:data_bytea33<=8'h02;
			4'd3:data_bytea33<=8'h00;
			4'd4:data_bytea33<=8'h21;
			4'd5:data_bytea33<=8'hD4;
			default:data_bytea33 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea34<=8'b0;
	else
		case(cnt34)
			4'd0:data_bytea34<=8'hAA;
			4'd1:data_bytea34<=8'h07;
			4'd2:data_bytea34<=8'h02;
			4'd3:data_bytea34<=8'h00;
			4'd4:data_bytea34<=8'h22;
			4'd5:data_bytea34<=8'hD5;
			default:data_bytea34 <=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea35<=8'b0;
	else
		case(cnt35)
			4'd0:data_bytea35<=8'hAA;
			4'd1:data_bytea35<=8'h07;
			4'd2:data_bytea35<=8'h02;
			4'd3:data_bytea35<=8'h00;
			4'd4:data_bytea35<=8'h23;
			4'd5:data_bytea35<=8'hD6;
			default:data_bytea35<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea36<=8'b0;
	else
		case(cnt36)
			4'd0:data_bytea36<=8'hAA;
			4'd1:data_bytea36<=8'h07;
			4'd2:data_bytea36<=8'h02;
			4'd3:data_bytea36<=8'h00;
			4'd4:data_bytea36<=8'h24;
			4'd5:data_bytea36<=8'hD7;
			default:data_bytea36<=8'b0;
		endcase
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_bytea37<=8'b0;
	else
		case(cnt37)
			4'd0:data_bytea37<=8'hAA;
			4'd1:data_bytea37<=8'h07;
			4'd2:data_bytea37<=8'h02;
			4'd3:data_bytea37<=8'h00;
			4'd4:data_bytea37<=8'h25;
			4'd5:data_bytea37<=8'hD8;
			default:data_bytea37<=8'b0;
		endcase
	//数据选择模块
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
	date_byte<=8'd0;
	else
		case(state)
		6'd1:date_byte<=data_byte1;
		6'd2:date_byte<=data_byte2;
		6'd3:date_byte<=data_byte3;
		6'd4:date_byte<=data_byte4;
		6'd5:date_byte<=data_byte5;
		6'd6:date_byte<=data_byte6;
		6'd7:date_byte<=data_byte7;
		6'd8:date_byte<=data_byte8;
		6'd9:date_byte<=data_byte9;
		6'd10:date_byte<=data_byte10;
		6'd11:date_byte<=data_byte11;
		6'd12:date_byte<=data_byte12;
		6'd13:date_byte<=data_byte13;
		6'd14:date_byte<=data_byte14;
		6'd15:date_byte<=data_byte15;
		6'd16:date_byte<=data_bytea16;
		6'd17:date_byte<=data_bytea17;
		6'd18:date_byte<=data_bytea18;
		6'd19:date_byte<=data_bytea19;
		6'd20:date_byte<=data_bytea20;
		6'd21:date_byte<=data_bytea21;
		6'd22:date_byte<=data_bytea22;
		6'd23:date_byte<=data_bytea23;
		6'd24:date_byte<=data_bytea24;
		6'd25:date_byte<=data_bytea25;
		6'd26:date_byte<=data_bytea26;
		6'd27:date_byte<=data_bytea27;
		6'd28:date_byte<=data_bytea28;
		6'd29:date_byte<=data_bytea29;
		6'd30:date_byte<=data_bytea30;
		6'd31:date_byte<=data_bytea31;
		6'd32:date_byte<=data_bytea32;
		6'd33:date_byte<=data_bytea33;
		6'd34:date_byte<=data_bytea34;
		6'd35:date_byte<=data_bytea35;
		6'd36:date_byte<=data_bytea36;
		6'd37:date_byte<=data_bytea37;
		default:date_byte<=8'd0;
		endcase
	end


endmodule
