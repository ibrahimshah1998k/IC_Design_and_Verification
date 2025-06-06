// `define DRIV_IF vif.DRIVER.driver_cb

class ahb_driver extends uvm_driver #(ahb_seq_item);
  `uvm_component_utils(ahb_driver)

  virtual ahb_if vif;
  uvm_analysis_port #(ahb_seq_item) drv2sb;

  function new(string name = "ahb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
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
    for (int i=0; i<4; i++) vif.HBUSREQ[i] = req.HBUSREQ[i];
    for (int i=0; i<4; i++) vif.HWRITE[i] = req.HWRITE[i];
    for (int i=0; i<4; i++) vif.HADDR[i] = req.HADDR[i];
    for (int i=0; i<4; i++) vif.HWDATA[i] = req.HWDATA[i];
    for (int i=0; i<4; i++) vif.HSIZE[i] = req.HSIZE[i];
    for (int i=0; i<4; i++) vif.HBURST[i] = req.HBURST[i];
    for (int i=0; i<4; i++) vif.HPROT[i] = req.HPROT[i];
    for (int i=0; i<4; i++) vif.HTRANS[i] = req.HTRANS[i];
    
    for (int i=0; i<4; i++) vif.HRDATA_S[i] = req.HRDATA_S[i];
    for (int i=0; i<4; i++) vif.HREADY_S[i] = req.HREADY_S[i];
    for (int i=0; i<4; i++) vif.HRESP_S[i] = req.HRESP_S[i];
    repeat (2) @(posedge vif.HCLK);
    for (int i=0; i<4; i++) vif.HBUSREQ[i] = 0;
    repeat (4) @(posedge vif.HCLK);
    
  endtask
endclass : ahb_driver
