// `define MONITOR_IF vif.MONITOR.monitor_cb

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  virtual ahb_if vif;

  uvm_analysis_port #(ahb_seq_item) item_collected_port;
  ahb_seq_item trans_collected;

  function new(string name = "ahb_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Unable to get interface for monitor.");
    
    trans_collected = ahb_seq_item::type_id::create("trans_collected");
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.HCLK);

        // Capture common fields
      for (int i=0; i<4; i++) trans_collected.HBUSREQ[i] = vif.HBUSREQ[i];
      for (int i=0; i<4; i++) trans_collected.HWRITE[i] = vif.HWRITE[i];
 for (int i=0; i<4; i++) trans_collected.HADDR[i] = vif.HADDR[i];
 for (int i=0; i<4; i++) trans_collected.HWDATA[i] = vif.HWDATA[i];
 for (int i=0; i<4; i++) trans_collected.HSIZE[i] = vif.HSIZE[i];
 for (int i=0; i<4; i++) trans_collected.HBURST[i] = vif.HBURST[i];
 for (int i=0; i<4; i++) trans_collected.HPROT[i] = vif.HPROT[i];
 for (int i=0; i<4; i++) trans_collected.HTRANS[i] = vif.HTRANS[i];
    
 for (int i=0; i<4; i++) trans_collected.HRDATA_S[i] = vif.HRDATA_S[i];
 for (int i=0; i<4; i++) trans_collected.HREADY_S[i] = vif.HREADY_S[i];
 for (int i=0; i<4; i++) trans_collected.HRESP_S[i] = vif.HRESP_S[i];
    item_collected_port.write(trans_collected);

    `uvm_info(get_full_name(), $sformatf("Captured transaction:\n%s", trans_collected.sprint()), UVM_MEDIUM);
      end
    
  endtask

endclass : ahb_monitor
