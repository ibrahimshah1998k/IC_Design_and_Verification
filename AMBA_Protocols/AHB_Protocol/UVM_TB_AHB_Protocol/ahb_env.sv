class ahb_model_env extends uvm_env;

  ahb_agent      ahb_agnt;
  ahb_scoreboard ahb_scb;
  
  `uvm_component_utils(ahb_model_env)

  function new(string name = "ahb_model_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ahb_agnt = ahb_agent::type_id::create("ahb_agnt", this);
    ahb_scb  = ahb_scoreboard::type_id::create("ahb_scb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    //c_agnt.monitor.item_collected_port.connect(cc_scb.item_collected_export);
    // mul_agnt.monitor.item_collected_port.connect(mul_cov.analysis_export);
  endfunction : connect_phase

endclass : ahb_model_env
