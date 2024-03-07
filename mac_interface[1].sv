
// ethernet packet switch - MAC interface

interface mac_intf (input logic clk, reset);  // clk and reset are directly given
	                                          // from testbench_top

  logic [1:0]   rx_bv;
  logic [31:0]  rx_data;
  logic         rx_valid;
  logic         rx_eop;
  logic         rx_sop;
  logic [1:0]   tx_bv;
  logic [31:0]  tx_data;
  logic         tx_valid;
  logic         tx_eop;
  logic         tx_sop;
     
endinterface