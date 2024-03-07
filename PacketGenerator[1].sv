
// ethernet packet switch - packet generator

`define MAXCOUNT 500

class Packet_generator;

  rand Packet pkt;
  
  mailbox tx_mbx;  // to send pkt to txBFM
  mailbox pg2sb;  // to send  pkt to sb

  int no_of_pkts_to_generate;
	
  function void set_no_of_pkts_to_generate (int n);
    if(n <= `MAXCOUNT) 
      this.no_of_pkts_to_generate = n;
    else $error("pkt count exceeds maximum count");
  endfunction

	
  function new(mailbox pg2sb, mailbox tx_mbx);				// changed tx_mbx to pg2sb
	this.tx_mbx = tx_mbx;  // connecting to mbx of txBFM
	this.pg2sb = pg2sb;  // connecting to the mbx of ref model
  endfunction

  
  task run();
    for (int j=1; j<=no_of_pkts_to_generate; j++) begin
    
      pkt = new ();  // creating a pkt
      pkt.pkt_id = j;
	  if (!pkt.randomize()) 
        $error ("error in randomizing");
	  else begin
        
        $display("\t\t\t-------------------------------------------------------------------------------------------");
        $display($time,"\t----------------------------pkt[%0d] generation started----------------------------------------",j);
        
        pkt.pack();                 // pack the whole data to be transmitted
        pkt.display();              // displaying contents in each pkt before sending it
        tx_mbx.put(pkt);           // send the complete data pkt to txBFM
        pg2sb.put(pkt);           // send the complete data pkt to scoreboard
	
        $display($time,"\t-----------------------------pkt [%0d] generation completed----------------------------\n",j);
	    
      end
    end
  endtask                    

endclass : Packet_generator



