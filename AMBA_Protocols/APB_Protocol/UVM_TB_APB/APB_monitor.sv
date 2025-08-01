// `define MONITOR_IF vif.MONITOR.monitor_cb

class APB_monitor extends uvm_monitor;
  `uvm_component_utils(APB_monitor)

  virtual APB_if vif;

  uvm_analysis_port #(APB_seq_item) item_collected_port;
  APB_seq_item trans_collected;

  function new(string name = "APB_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual APB_if)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Unable to get interface for monitor.");
    
    trans_collected = APB_seq_item::type_id::create("trans_collected");
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.PCLK);

        // Capture common fields
      for (int i=0; i<4; i++) trans_collected.PWRITE[i] = vif.PWRITE[i];
      for (int i=0; i<4; i++) trans_collected.PADDR[i] = vif.PADDR[i];
      for (int i=0; i<4; i++) trans_collected.PWDATA[i] = vif.PWDATA[i];
      for (int i=0; i<4; i++) trans_collected.PRDATA[i] = vif.PRDATA[i];
      for (int i=0; i<4; i++) trans_collected.PSTRB[i] = vif.PSTRB[i];
      for (int i=0; i<4; i++) trans_collected.PREADY[i] = vif.PREADY[i];
      for (int i=0; i<4; i++) trans_collected.PENABLE[i] = vif.PENABLE[i];
      for (int i=0; i<4; i++)
        for (int j=0; j<4; j++)
          trans_collected.PSEL[i][j] = vif.PSEL[i][j];
      for (int i=0; i<4; i++) trans_collected.PGRANT[i] = vif.PGRANT[i];

      for (int i=0; i<4; i++) trans_collected.PRDATA_S[i] = vif.PRDATA_S[i];
      for (int i=0; i<4; i++) trans_collected.PREADY_S[i] = vif.PREADY_S[i];
      for (int i=0; i<4; i++) trans_collected.PWRITE_S[i] = vif.PWRITE_S[i];
      for (int i=0; i<4; i++) trans_collected.PADDR_S[i] = vif.PADDR_S[i];
      for (int i=0; i<4; i++) trans_collected.PWDATA_S[i] = vif.PWDATA_S[i];
      for (int i=0; i<4; i++) trans_collected.PSTRB_S[i] = vif.PSTRB_S[i];
      for (int i=0; i<4; i++) trans_collected.PENABLE_S[i] = vif.PENABLE_S[i];
      for (int i=0; i<4; i++) trans_collected.PSEL_S[i] = vif.PSEL_S[i];
    //`uvm_info(get_full_name(), $sformatf("Captured transaction:\n%s", trans_collected.sprint()), UVM_MEDIUM);
      end
    
  endtask

endclass : APB_monitor
