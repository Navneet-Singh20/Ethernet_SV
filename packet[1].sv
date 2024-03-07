// ethernet packet switch - packet class
`define MAX 3000

class Packet;
  
  int pkt_id;

  bit [63:0] preamble = 64'hAAAA_AAAA_AAAA_AAAB; 
  rand bit [47:0] DA ; 
  rand bit [47:0] SA ; 	
 
  bit [15:0] len ;						// length of frame which is excluding preamble section
  rand bit [7:0] payload []; 
  bit [31:0] crc = 32'hAABB_AABB ;
  bit [7:0] data [];                     // dynamic array to include the entire data pkt 
  int length;                            // total length of the entire data pkt 
 
  
  
  typedef enum { SMALL, MEDIUM, BIG, RUNT, JUMBO} Payload_type;
  typedef enum { unicast, multicast, broadcast } DA_type;
  
  rand Payload_type payload_type;
  rand DA_type da_type;
  
  constraint dist_payload_type {
    payload_type dist { SMALL := 25, MEDIUM := 25, BIG := 25, RUNT := 5, JUMBO := 5};    
  }
  
  constraint dist_da_type {
    da_type dist { unicast := 50, multicast := 25, broadcast := 25};    
  }
  
  constraint payload_type_c {
		
    if (payload_type == SMALL) payload.size() inside {[46:512]};
    if (payload_type == MEDIUM) payload.size() inside {[513:1024]};
    if (payload_type == BIG) payload.size() inside {[1025:1500]};  
    if ( payload_type == RUNT) payload.size() < 46;
    if (payload_type == JUMBO) (payload.size() >1500 && payload.size()<`MAX);
  } 
  
	
  constraint valid_addr_c {
    DA != 48'h0000_0000_0000;  // addr should not be all zeros
    SA != 48'h0000_0000_0000; 
    SA != 48'hFFFF_FFFF_FFFF;  // SA should'nt be broadcast addr   
  }  

  constraint da_c { 
    if (da_type == broadcast) DA == 48'hFFFF_FFFF_FFFF;
    if (da_type == multicast) DA[40] == 1; 
    if (da_type == unicast) DA[47] == 0;
		}
 
  
  function int Length();                  // total length of data pkt
    length = 8+6+6+payload.size()+2+4;    // preamble to crc
    len = length-8;                       // len is the size of frame from DA to crc
    return length;                        // length is in the form of no. of bytes here
  endfunction

    
  function void pack();                   // packing the whole data pkt 
    data = new[Length()];                 // data is created with the total length of packet
    
    data = {>>8{preamble, DA, SA, len, payload, crc}};  // streaming operator
  endfunction
  
  function void unpack( ); // unpacking the whole data pkt 
   {>>8{preamble, DA, SA, len, payload, crc}} = data;  // streaming 
  endfunction  

  function bit compare(Packet pkt);
    bit i;
    if(pkt == null) begin
      $display(" \t\t\t--------------------** ERROR ** : pkt : received a null object -----------------------");
      i = 1;
    end
    else begin
      if(pkt.DA !== this.DA) begin
        $display(" \t\t\t--------------------** ERROR **: pkt : DA field did not match-----------------------");
        i = 1;
      end
      
      if(pkt.SA !== this.SA) begin
        $display(" \t\t\t--------------------** ERROR **: pkt : SA field did not match-----------------------");
        i = 1;
      end

      if(pkt.length !== this.length) begin
        $display(" \t\t\t--------------------** ERROR **: pkt : Length field did not match-----------------------");
        i = 1;
      end
      
      foreach(this.data[j]) begin
        if(pkt.data[j] !== this.data[j]) begin
          $display(" \t\t\t--------------------** ERROR **: pkt : Data[%0d] field did not match-----------------------",j);
          i = 1;
        end
      end
      if(i == 0)
      	compare = 1;          // BY ME
      else
        compare = 0;
    end
endfunction : compare

/*  
	Another Way of comparing BY ME BUT I NEED TO IMPROVE IT
    
  function bit compare(Packet pkt);
    if(this.data == pkt.data)
      return 1;
    else
      return 0;
  endfunction
 */  
  
  
  function void display();   // display data packet contents
    $display("\t\t\tpayload size:%0d", payload.size());
    $display("\t\t\ttotal packet length:%0d\n", Length());
    
    $display("\t\ttime     preamble(hex) \t DA(hex) \t SA(hex)  Len(dec)  \t\t\t\t\t\t\t\t\t\t\t\tpayload(hex)\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tcrc(hex)");
    
    $display($time,"\t%0h %0h %0h   %0d   %0p %0h",preamble, DA, SA, len, payload, crc);
    $display("data=%p",data);
  endfunction 
  
endclass : Packet



