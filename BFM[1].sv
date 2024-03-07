//--------------------------------------------------------------------
//-------------------------CLASS TXBFM--------------------------------
//--------------------------------------------------------------------

class TxBfm;

  int IPG_size = 12;  // size of IPG(Interpacket Gap) in bytes
  
  int i;
  
  mailbox tx_mbx ;  // to receive pkt from pktgen
	
  virtual mac_intf mac_vif;  // virtual interface	
	
  bit insert_random_wait;
  int random_wait;
  
  int count;  // temp var used in task drive
  
  function new(mailbox tx_mbx, virtual mac_intf mac_vif);
    this.tx_mbx = tx_mbx;
    this.mac_vif = mac_vif;
  endfunction

	
  function void set_random_disable_valid (bit insert_random_wait, int random_wait);
	this.insert_random_wait = insert_random_wait;        // to disable valid, if needed
	this.random_wait = random_wait;
  endfunction
	
  task reset();
    
    wait(mac_vif.reset);
    
    $display($time,"\t------------------------------------reset started-----------------------------------");
    
    @(posedge mac_vif.clk);
    
    mac_vif.tx_sop = 0;  
    mac_vif.tx_eop = 0;
    mac_vif.tx_valid = 0;  
    mac_vif.tx_bv = 0;
    mac_vif.tx_data = 0;
     
    $display($time,"\t sop:%0b eop:%0b valid:%0b bv:%0b data:%0h", mac_vif.tx_sop,mac_vif.tx_eop, mac_vif.tx_valid, mac_vif.tx_bv, mac_vif.tx_data); 

    wait(!mac_vif.reset);
    
    $display($time,"\t--------------------------------reset ended------------------------------------------\n");
    
  endtask
  
  
 task drive(Packet pkt);
    $display($time,"\t-----------------------------start of driving pkt-------------------------------------");
    count = pkt.data.size()%4; // assigning the value of residual bytes 
     i = 0;
    
   while(i < pkt.data.size()) begin
                                     // since one cycle can transmit 4 bytes (using i+4)
 
 
      @(posedge mac_vif.clk);
      
      if(!mac_vif.reset) begin

         if(insert_random_wait) begin         // for randomly disabling valid
            int n = $urandom_range(0,random_wait);
            for (int j = 0; j < n; j++) begin
		       mac_vif.tx_valid = 0; 
               $display($time,"----random_wait_of_%0d_clock_cycle_is_inserted----valid:%0b--",n,mac_vif.tx_valid);
               @(posedge mac_vif.clk);
             end
            insert_random_wait = 1'b0;
            i = i - 4;
          end 
         else begin
           mac_vif.tx_valid = 1;   // set valid bit 
           mac_vif.tx_bv = 0;     // set bv bit 
        
           if (i == 0) begin  
              mac_vif.tx_sop = 1; // sop - at the beginning
              mac_vif.tx_eop = 0;
         
              mac_vif.tx_data[31:24] = pkt.data[i+0];   
              mac_vif.tx_data[23:16] = pkt.data[i+1];
              mac_vif.tx_data[15:8] = pkt.data[i+2];
              mac_vif.tx_data[7:0] = pkt.data[i+3]; 
              $display($time,"\t sop:%0b eop:%0b valid:%0b bv:%0b data:%0h", mac_vif.tx_sop,mac_vif.tx_eop, mac_vif.tx_valid, mac_vif.tx_bv, mac_vif.tx_data); 
      
            end
        
            else if((count == 0) &&(i == pkt.data.size()-4)) begin
              mac_vif.tx_sop = 0;
              mac_vif.tx_eop = 1;
          
              mac_vif.tx_data[31:24] = pkt.data[i+0];   
              mac_vif.tx_data[23:16] = pkt.data[i+1];
              mac_vif.tx_data[15:8] = pkt.data[i+2];
              mac_vif.tx_data[7:0] = pkt.data[i+3]; 
              $display($time,"\t sop:%0b eop:%0b valid:%0b bv:%0b data:%0h", mac_vif.tx_sop,mac_vif.tx_eop, mac_vif.tx_valid, mac_vif.tx_bv, mac_vif.tx_data);
              $display($time,"\t-----------------------------------end of driving pkt------------------------------------\n"); 
        
             end
        
             else if ((count != 0) && (i == pkt.data.size() - count)) begin
          
               mac_vif.tx_sop = 0;
               mac_vif.tx_eop = 1;
               mac_vif.tx_bv = count;
               if(count == 3) begin
          	      mac_vif.tx_data[31:24] = pkt.data[i+0];   
          	      mac_vif.tx_data[23:16] = pkt.data[i+1];
          	      mac_vif.tx_data[15:8] = pkt.data[i+2];
               end
               else if(count == 2) begin
                  mac_vif.tx_data[31:24] = pkt.data[i+0];   
          	      mac_vif.tx_data[23:16] = pkt.data[i+1];
               end
               else begin
              mac_vif.tx_data[31:24] = pkt.data[i+0];
              end
              
              $display($time,"\t sop:%0b eop:%0b valid:%0b bv:%0b data:%0h", mac_vif.tx_sop,mac_vif.tx_eop, mac_vif.tx_valid, mac_vif.tx_bv, mac_vif.tx_data);
              $display($time,"\t-----------------------------------end of driving pkt------------------------------------\n");  
              end
                 
          else begin
          
            mac_vif.tx_sop = 0 ;
            mac_vif.tx_eop = 0;
      
            mac_vif.tx_data[31:24] = pkt.data[i+0];   
            mac_vif.tx_data[23:16] = pkt.data[i+1];
            mac_vif.tx_data[15:8] = pkt.data[i+2];
            mac_vif.tx_data[7:0] = pkt.data[i+3]; 
            $display($time,"\t sop:%0b eop:%0b valid:%0b bv:%0b data:%0h", mac_vif.tx_sop,mac_vif.tx_eop, mac_vif.tx_valid, mac_vif.tx_bv, mac_vif.tx_data);
        
           end 
      end
      		i = i + 4;

        $display($time,"\t----------------------------------------------------------------------------------\n");     
    end
      else begin
        i = i ;
      end
    end
    
    endtask : drive 
  
  
  task run();          // main task
    
    while (1) begin
      Packet pkt;
      tx_mbx.get(pkt);    // receives the pkt
      drive(pkt);        // drives the pkt
    
       repeat (IPG_size/4) begin
         @(posedge mac_vif.clk);  // port stays idle for 3 clk cycle
         mac_vif.tx_valid = 0;  // valid should be zero for no data transmission
       end
      
    end
  endtask : run

endclass : TxBfm


//-----------------------------------------------------------------
//----------------------CLASS RXBFM--------------------------------
//-----------------------------------------------------------------


class RxBfm ; //extends Bfm;
  
  virtual mac_intf mac_vif;

  mailbox rx_mbx;
  event receiver_done;
  
  bit [7:0] temp [$]; // temporary queue for storing each received pkt
  
  function new(mailbox rx_mbx, virtual mac_intf  mac_vif, event receiver_done);
    this.rx_mbx = rx_mbx;
    this.mac_vif = mac_vif;
    this.receiver_done = receiver_done ;
  endfunction
 
  task run();
    
    Packet pkt;
  
    while(1) begin
      @(posedge mac_vif.clk);
    
      if (mac_vif.rx_valid & !mac_vif.reset) begin
     
        if(mac_vif.rx_sop) begin
          $display($time,"\t-----------------------------start of receiving pkt-------------------------------------");
          temp.push_back(mac_vif.rx_data[31:24]);
          temp.push_back(mac_vif.rx_data[23:16]);
          temp.push_back(mac_vif.rx_data[15:8]);
          temp.push_back(mac_vif.rx_data[7:0]);
        end
        
        else if (mac_vif.rx_eop) begin
          
          if(mac_vif.rx_bv == 0) begin
            temp.push_back(mac_vif.rx_data[31:24]);
            temp.push_back(mac_vif.rx_data[23:16]);
            temp.push_back(mac_vif.rx_data[15:8]);
            temp.push_back(mac_vif.rx_data[7:0]);
          end
        
          else if(mac_vif.rx_bv == 3) begin
            temp.push_back(mac_vif.rx_data[31:24]);
            temp.push_back(mac_vif.rx_data[23:16]);
            temp.push_back(mac_vif.rx_data[15:8]);
          end
          
          else if(mac_vif.rx_bv == 2) begin
            temp.push_back(mac_vif.rx_data[31:24]);
            temp.push_back(mac_vif.rx_data[23:16]);
          end
          
          else begin         
            temp.push_back(mac_vif.rx_data[31:24]);
          end
        
          pkt = new();  // creating a new pkt
          
          $display("\t\t\t size of received data pkt : %0d", temp.size());
          
          pkt.data = new[temp.size()];  // creating the dynamic array data by giving size

          pkt.data = {>>{temp}};  // pushing temp to data
          
          pkt.unpack();  // UnPacking the data pkt
        
          temp.delete(); // deleting temp - can resuse it for nxt pkt
          
          
         
          rx_mbx.put(pkt);
          
          $display($time,"\t-----------------------------end of receiving pkt-------------------------------------");
          -> receiver_done;
          
        end
        
        else begin  
          temp.push_back(mac_vif.rx_data[31:24]);  // for the rest of the clk cycles
          temp.push_back(mac_vif.rx_data[23:16]);
          temp.push_back(mac_vif.rx_data[15:8]);
          temp.push_back(mac_vif.rx_data[7:0]);
        end
        
      end

    end     
    
  endtask : run
  
endclass : RxBfm
     

//-----------------------------------------------------------------------------------


