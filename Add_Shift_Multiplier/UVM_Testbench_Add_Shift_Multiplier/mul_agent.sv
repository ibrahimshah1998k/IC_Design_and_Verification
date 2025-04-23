class mul_agent extends uvm_agent;
  `uvm_component_utils(mul_agent)

  mul_driver    driver;
  mul_sequencer sequencer;
  mul_monitor   monitor;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = mul_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE) begin
      driver    = mul_driver::type_id::create("driver", this);
      sequencer = mul_sequencer::type_id::create("sequencer", this);
      //$display("Time: %d,  Agent_Class",$time);
    end
  endfunction : build_phase
  

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : mul_agent
