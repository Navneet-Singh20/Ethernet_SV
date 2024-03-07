// Code your design here
module ethernet_packet_switch(
  	input clk,
  	input reset,
  	input logic[1:0]       rx_bv_0,
	input logic[31:0]      rx_data_0,
	input logic            rx_valid_0,
	input logic            rx_eop_0,
	input logic            rx_sop_0,
	output logic[1:0]       tx_bv_0,
	output logic[31:0]      tx_data_0,
	output logic            tx_valid_0,
	output logic            tx_eop_0,
	output logic            tx_sop_0);
  
  always@(posedge clk) begin
    if(reset) begin
      tx_bv_0 <= 0;
	  tx_data_0 <= 0;
	  tx_valid_0 <= 0;
	  tx_eop_0 <= 0;
	  tx_sop_0 <= 0;
    end
      else begin
    	tx_bv_0 <= rx_bv_0;
    	tx_data_0 <= rx_data_0;
    	tx_valid_0 <= rx_valid_0;
    	tx_eop_0 <= rx_eop_0;
    	tx_sop_0 <= rx_sop_0;
  	end
  end
  
endmodule
/*
module switch(
input logic clk, 
input logic reset,
// APB Interface comes here 


// MAC Interfaces
input logic[1:0]       rx_bv_0,
input logic[31:0]      rx_data_0,
input logic            rx_valid_0,
input logic            rx_eop_0,
input logic            rx_sop_0,
output logic[1:0]       tx_bv_0,
output logic[31:0]      tx_data_0,
output logic            tx_valid_0,
output logic            tx_eop_0,
output logic            tx_sop_0,

input logic[1:0]       rx_bv_1,
input logic[31:0]      rx_data_1,
input logic            rx_valid_1,
input logic            rx_eop_1,
input logic            rx_sop_1,
output logic[1:0]       tx_bv_1,
output logic[31:0]      tx_data_1,
output logic            tx_valid_1,
output logic            tx_eop_1,
output logic            tx_sop_1,

input logic[1:0]       rx_bv_2,
input logic[31:0]      rx_data_2,
input logic            rx_valid_2,
input logic            rx_eop_2,
input logic            rx_sop_2,
output logic[1:0]       tx_bv_2,
output logic[31:0]      tx_data_2,
output logic            tx_valid_2,
output logic            tx_eop_2,
output logic            tx_sop_2,


input logic[1:0]       rx_bv_3,
input logic[31:0]      rx_data_3,
input logic            rx_valid_3,
input logic            rx_eop_3,
input logic            rx_sop_3,
output logic[1:0]       tx_bv_3,
output logic[31:0]      tx_data_3,
output logic            tx_valid_3,
output logic            tx_eop_3,
output logic            tx_sop_3,

input logic[1:0]       rx_bv_4,
input logic[31:0]      rx_data_4,
input logic            rx_valid_4,
input logic            rx_eop_4,
input logic            rx_sop_4,
output logic[1:0]       tx_bv_4,
output logic[31:0]      tx_data_4,
output logic            tx_valid_4,
output logic            tx_eop_4,
output logic            tx_sop_4,

input logic[1:0]       rx_bv_5,
input logic[31:0]      rx_data_5,
input logic            rx_valid_5,
input logic            rx_eop_5,
input logic            rx_sop_5,
output logic[1:0]       tx_bv_5,
output logic[31:0]      tx_data_5,
output logic            tx_valid_5,
output logic            tx_eop_5,
output logic            tx_sop_5,


input logic[1:0]       rx_bv_6,
input logic[31:0]      rx_data_6,
input logic            rx_valid_6,
input logic            rx_eop_6,
input logic            rx_sop_6,
output logic[1:0]       tx_bv_6,
output logic[31:0]      tx_data_6,
output logic            tx_valid_6,
output logic            tx_eop_6,
output logic            tx_sop_6,


input logic[1:0]       rx_bv_7,
input logic[31:0]      rx_data_7,
input logic            rx_valid_7,
input logic            rx_eop_7,
input logic            rx_sop_7,
output logic[1:0]       tx_bv_7,
output logic[31:0]      tx_data_7,
output logic            tx_valid_7,
output logic            tx_eop_7,
output logic            tx_sop_7
);
*/