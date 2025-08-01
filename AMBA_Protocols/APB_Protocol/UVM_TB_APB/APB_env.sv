class APB_model_env extends uvm_env;

  APB_agent      APB_agnt;
  APB_scoreboard APB_scb;
  
  `uvm_component_utils(APB_model_env)

  function new(string name = "APB_model_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    APB_agnt = APB_agent::type_id::create("APB_agnt", this);
    APB_scb  = APB_scoreboard::type_id::create("APB_scb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    //c_agnt.monitor.item_collected_port.connect(cc_scb.item_collected_export);
    // mul_agnt.monitor.item_collected_port.connect(mul_cov.analysis_export);
  endfunction : connect_phase

endclass : APB_model_env
