`include "Environment.sv"

class Test_RUN;
  
  virtual mac_intf mac_vif;
  int num;
  
  Environment Envt;
  
  function new(virtual mac_intf mac_vif,int num);
    Envt = new();
    this.mac_vif = mac_vif;
    this.num = num;
  endfunction
  
  task run();
    Envt.connect(mac_vif,num);
    Envt.run();
  endtask
 
endclass

class Test_RESET;
  
  
  Environment Envt;
  
  virtual mac_intf mac_vif;
  int num;
  
  function new(virtual mac_intf mac_vif,int num);
    Envt = new();
    this.mac_vif = mac_vif;
    this.num = num;
  endfunction
  
  
  task run();
    Envt.connect(mac_vif,num);
    Envt.build();
    Envt.reset();
  endtask
 
endclass

class Test_RANDOM_WAIT;
  Environment Envt;
  
  virtual mac_intf mac_vif;
  int num;
  
  function new(virtual mac_intf mac_vif,int num);
    Envt = new();
    this.mac_vif = mac_vif;
    this.num = num;
  endfunction
  
  
  task run();
    Envt.connect(mac_vif,num);
    fork
    Envt.run();
    #50 Envt.txbfm.set_random_disable_valid (1,10);
    join
  endtask
  
endclass
  