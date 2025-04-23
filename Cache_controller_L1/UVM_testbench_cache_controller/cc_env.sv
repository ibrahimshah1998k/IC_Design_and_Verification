class cc_model_env extends uvm_env;

  cc_agent      cc_agnt;
  cc_scoreboard cc_scb;
  
  `uvm_component_utils(cc_model_env)

  function new(string name = "cc_model_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cc_agnt = cc_agent::type_id::create("cc_agnt", this);
    cc_scb  = cc_scoreboard::type_id::create("cc_scb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    //c_agnt.monitor.item_collected_port.connect(cc_scb.item_collected_export);
    // mul_agnt.monitor.item_collected_port.connect(mul_cov.analysis_export);
  endfunction : connect_phase

endclass : cc_model_env
