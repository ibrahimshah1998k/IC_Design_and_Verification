`define MONITOR_IF vif.MONITOR.monitor_cb

class cc_monitor extends uvm_monitor;
  `uvm_component_utils(cc_monitor)

  virtual cc_if vif;

  uvm_analysis_port #(cc_seq_item) item_collected_port;
  cc_seq_item trans_collected;

  function new(string name = "cc_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual cc_if)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Unable to get interface for monitor.");
    
    trans_collected = cc_seq_item::type_id::create("trans_collected");
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);

      if (`MONITOR_IF.read_c || `MONITOR_IF.write_c) begin
        // Wait additional cycles if needed (based on your DUT timing)
        repeat (2) @(posedge vif.clk);

        // Capture common fields
        trans_collected.read_c        = `MONITOR_IF.read_c;
        trans_collected.write_c       = `MONITOR_IF.write_c;
        trans_collected.cache_flush   = `MONITOR_IF.cache_flush;
        trans_collected.address       = `MONITOR_IF.address;
        trans_collected.ready         = `MONITOR_IF.ready;
        trans_collected.data_mem_to_c = `MONITOR_IF.data_mem_to_c;
        trans_collected.data_mp_to_c  = `MONITOR_IF.data_mp_to_c;

        if (`MONITOR_IF.read_c)
          trans_collected.data_c_to_mp = `MONITOR_IF.data_c_to_mp;
        else if (`MONITOR_IF.write_c)
          trans_collected.data_c_to_mem = `MONITOR_IF.data_c_to_mem;

        item_collected_port.write(trans_collected);

        `uvm_info(get_full_name(), $sformatf("Captured transaction:\n%s", trans_collected.sprint()), UVM_MEDIUM);
      end
    end
  endtask

endclass : cc_monitor
