class APB_agent extends uvm_agent;
  `uvm_component_utils(APB_agent)

  APB_driver    driver;
  APB_sequencer sequencer;
  APB_monitor   monitor;

  virtual APB_if vif;  // Declare virtual interface

  function new(string name = "APB_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get and set virtual interface for child components
    if (!uvm_config_db#(virtual APB_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Unable to get virtual interface in agent");

    uvm_config_db#(virtual APB_if)::set(this, "driver", "vif", vif);
    uvm_config_db#(virtual APB_if)::set(this, "monitor", "vif", vif);

    // Create monitor always
    monitor = APB_monitor::type_id::create("monitor", this);

    // Create driver/sequencer if agent is ACTIVE
    if (get_is_active() == UVM_ACTIVE) begin
      driver    = APB_driver::type_id::create("driver", this);
      sequencer = APB_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

  function void end_of_elaboration();
    `uvm_info(get_type_name(), $sformatf("Agent %s is %s", get_full_name(),
               get_is_active() ? "ACTIVE" : "PASSIVE"), UVM_LOW)
  endfunction

endclass : APB_agent
