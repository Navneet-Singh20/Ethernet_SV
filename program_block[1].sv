`include "TestCase.sv"

program pb(mac_intf mac_vif);
  int num;
  
  Test_RESET tst_rst;
  
  Test_RUN tst_run;
  
  Test_RANDOM_WAIT tst_wait;
  
  initial begin
    if($test$plusargs("RESET"))
       begin
         tst_rst = new(mac_vif,0);
         tst_rst.run();
    end
    else if($value$plusargs("RUN=%0d",num)) begin
      tst_run = new(mac_vif,num);
         tst_run.run();
    end
    else if($value$plusargs("WAIT=%0d",num)) begin
      tst_wait = new(mac_vif,num);
      tst_wait.run();
    end
 end
 
 endprogram