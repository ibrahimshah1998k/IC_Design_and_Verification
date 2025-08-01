// `define DRIV_IF vif.DRIVER.driver_cb

class APB_driver extends uvm_driver #(APB_seq_item);
  `uvm_component_utils(APB_driver)

  virtual APB_if vif;
  uvm_analysis_port #(APB_seq_item) drv2sb;

  function new(string name = "APB_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual APB_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});

    drv2sb = new("drv2sb", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      drv2sb.write(req);  // optionally send to scoreboard
      `uvm_info(get_full_name(), $sformatf("driver transaction:\n%s", req.sprint()), UVM_MEDIUM);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive(); 
    for (int i=0; i<4; i++) begin
      for (int j=0; j<4; j++) begin
        vif.PSEL[i][j] = req.PSEL[i][j]; end end
    for (int i=0; i<4; i++)
      if(vif.PGRANT[i]) begin
        for (int i=0; i<4; i++) vif.PREADY_S[i] = req.PREADY_S[i];
        for (int i=0; i<4; i++) vif.PADDR[i] = req.PADDR[i];
        for (int i=0; i<4; i++) vif.PWRITE[i] = req.PWRITE[i];
        for (int i=0; i<4; i++) vif.PSTRB[i] = req.PSTRB[i]; 
        for (int i=0; i<4; i++) vif.PWDATA[i] = req.PWDATA[i];
        for (int i=0; i<4; i++) vif.PRDATA_S[i] = req.PRDATA_S[i];
        for (int i=0; i<4; i++) vif.PENABLE[i] = req.PENABLE[i];
      end

//     for (int i=0; i<4; i++) vif.PENABLE[i] = 0;
    

//     repeat (2) @(posedge vif.PCLK);
//     for (int i=0; i<4; i++) vif.PENABLE[i] = 1;
//     repeat (1) @(posedge vif.PCLK);
//     for (int i=0; i<4; i++) vif.PENABLE[i] = 0;
//     for (int i=0; i<4; i++) begin
//       for (int j=0; j<4; j++) begin
//         vif.PSEL[i][j] = 0; end end
    
  endtask
endclass : APB_driver
