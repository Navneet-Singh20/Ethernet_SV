`include "packet.sv"
`include "PacketGenerator.sv"
`include "BFM.sv"
`include "score_board.sv"

class Environment ;

  virtual mac_intf mac_vif;
  
  event receiver_done;		//Maintain Synch. between RxBFM and Scoreboard
  
  TxBfm txbfm;
  RxBfm rxbfm;
  Scoreboard sb;
  Packet_generator pg;
  
  mailbox pg2tx_Bfm;
  mailbox pg2sb;
  mailbox rx_bfm2sb ;
 
  int num;

  function void connect(virtual mac_intf mac_if_new,int num);
    this.mac_vif = mac_if_new;
    this.num     = num;
    $display(" \t\t\t---------------%0d : Environment : created env object------------------",$time);
  endfunction : connect


  function void build();
    $display(" \t\t\t---------------%0d : Environment : start of build() method------------------",$time);
    rx_bfm2sb = new();
    pg2tx_Bfm = new();
    pg2sb     = new();
    
    sb    = new(pg2sb, rx_bfm2sb,receiver_done);
    pg    = new(pg2sb,pg2tx_Bfm);
    txbfm = new(pg2tx_Bfm, mac_vif);
    rxbfm = new(rx_bfm2sb, mac_vif,receiver_done);
    $display(" \t\t\t---------------%0d : Environment : end of build() method------------------",$time);
  endfunction : build
  
  task reset();
    txbfm.reset();
  endtask
  
  task start();
    $display(" \t\t\t---------------%0d : Environment : start of start() method------------------",$time);
    fork
      pg.run();
      txbfm.run();
      rxbfm.run();
      sb.run();
    join_any
    $display(" \t\t\t---------------%0d : Environment : end of start() method------------------",$time);
  endtask : start

  task wait_for_end();
    $display(" \t\t\t---------------%0d : Environment : start of wait_for_end() method------------------",$time);
    fork
      wait(pg.no_of_pkts_to_generate == sb.no_pkts_have_chked);
      
      repeat(1000) @(posedge mac_vif.clk); // it will prevent us from DEAD LOCK Condition
      
    join_any
    $display(" \t\t\t---------------%0d : Environment : end of wait_for_end() method------------------",$time);
  endtask : wait_for_end

  task run();
    $display(" \t\t\t---------------%0d : Environment : start of run() method------------------",$time);
    build();
    pg.set_no_of_pkts_to_generate(num);
    start();
    wait_for_end();
    $display(" \t\t\t---------------%0d : Environment : end of run() method------------------",$time);
    $finish;
  endtask: run

endclass
