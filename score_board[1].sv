class Scoreboard;

  mailbox rx_bfm2sb;    //packet from rx_mbx
  mailbox pg2sb;    //packet from sb
  event receiver_done;
  
  int no_pkts_have_chked;

  function new(mailbox pg2sb, mailbox rx_bfm2sb, event receiver_done);
    this.pg2sb = pg2sb;
    this.rx_bfm2sb = rx_bfm2sb;
    this.receiver_done = receiver_done;
  endfunction:new

  task run();
    Packet pkt_rcv; 
    Packet pkt_exp;
    forever begin 
      wait(receiver_done.triggered);
      
      rx_bfm2sb.get(pkt_exp);
      
      $display("\t\t\t\t\t-------------------*******Inside Scoreboard*******------------------------ ");
      
      $display(" %0d : Scorebooard : Scoreboard received a packet from Rx_Bfm ", $time);
     
      pkt_exp.display();
      
      $display(" %0d : Scorebooard : Scoreboard received a packet from PacketGenerator ", $time);
      
      pg2sb.get(pkt_rcv);
      
      pkt_rcv.display();
      
      
      if(pkt_rcv.compare(pkt_exp)) begin
        $display(" %0d : Scoreboard :Packet with particular (id = %0d) Matched ", $time,pkt_rcv.pkt_id);
        $display("------------------------------------------------------------------------------------");
      end
      else begin
        $display(" %0d : Scoreboard :Packet with particular (id = %0d) did not Match ", $time,pkt_rcv.pkt_id);
        $display("------------------------------------------------------------------------------------");
      end
      no_pkts_have_chked++;
    end
  endtask : run

endclass
