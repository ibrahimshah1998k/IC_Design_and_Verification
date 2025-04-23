class mul_model_env extends uvm_env;
  `uvm_component_utils(mul_model_env)

  mul_agent      mul_agnt;
  mul_scoreboard mul_scb;
  mul_coverage   mul_cov;
  

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mul_agnt = mul_agent::type_id::create("mul_agnt", this);
    mul_scb  = mul_scoreboard::type_id::create("mul_scb", this);
    mul_cov  = mul_coverage::type_id::create("mul_cov", this);
  endfunction : build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase); mul_agnt.monitor.item_collected_port.connect(mul_scb.item_collected_export);
  mul_agnt.monitor.item_collected_port.connect(mul_cov.analysis_export);
endfunction : connect_phase


endclass : mul_model_env
