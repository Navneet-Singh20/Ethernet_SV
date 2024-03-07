`include "mac_interface.sv"
`include "program_block.sv"

module top;
  logic clk;
  logic reset;
  
  mac_intf mac_vif(clk,reset);
  
  ethernet_packet_switch DUT (.clk(clk),
                              .reset(reset),
                              .rx_data_0(mac_vif.tx_data),
                              .rx_bv_0(mac_vif.tx_bv),
                              .rx_sop_0(mac_vif.tx_sop),
                              .rx_eop_0(mac_vif.tx_eop),
                              .rx_valid_0(mac_vif.tx_valid),
                              .tx_data_0(mac_vif.rx_data),
                              .tx_bv_0(mac_vif.rx_bv),
                              .tx_sop_0(mac_vif.rx_sop),
                              .tx_eop_0(mac_vif.rx_eop),
                              .tx_valid_0(mac_vif.rx_valid));
              
  pb PB(mac_vif);
  
  initial begin
    clk = 1'b0;
    	forever #5ns clk = ~clk;
  end
  
  initial begin
    reset = 0;
   // #30ns reset = 1;
   // #30ns reset = 0;
  end
  
  initial begin
    $dumpfile("Ethernet.vcd");
    $dumpvars;
  end
  
endmodule