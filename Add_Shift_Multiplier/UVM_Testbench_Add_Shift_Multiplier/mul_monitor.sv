//`define MONITOR_IF vif.MONITOR.monitor_cb

class mul_monitor extends uvm_monitor;
  `uvm_component_utils(mul_monitor)

  virtual axi_stream_if multiplier_to_slave;

  uvm_analysis_port #(mul_seq_item) item_collected_port;
 mul_seq_item trans_collected;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();  //check with create method
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_stream_if)::get(this, "", "multiplier_to_slave", multiplier_to_slave))
     `uvm_fatal("monitor", "unable to get interface");
  endfunction: build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   // mul_seq_item trans_collected;
    multiplier_to_slave.tready=1;

    forever begin
 //trans_collected = mul_seq_item::type_id::create("trans_collected");
      wait(multiplier_to_slave.tvalid);
      @(posedge multiplier_to_slave.clk);
      trans_collected.tdata = multiplier_to_slave.tdata;
       
      
	  item_collected_port.write(trans_collected);
      `uvm_info(get_full_name(), $sformatf("transection = \n%s", trans_collected.sprint()), UVM_LOW);
          
      end 
  endtask : run_phase

endclass : mul_monitor
