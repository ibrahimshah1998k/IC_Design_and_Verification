class mul_model_base_test extends uvm_test;
  `uvm_component_utils(mul_model_base_test)

  mul_model_env env;

  function new(string name = "mul_model_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = mul_model_env::type_id::create("env", this);
  endfunction : build_phase
  
  virtual function void end_of_elaboration();
    print();
  endfunction

 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 
endclass : mul_model_base_test




class mul_test extends mul_model_base_test;

  `uvm_component_utils(mul_test)
 
  mul2x2_sequence seq;

  function new(string name = "mul_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = mul2x2_sequence::type_id::create("seq");
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    seq.start(env.mul_agnt.sequencer);
      wait(env.mul_agnt.monitor.multiplier_to_slave.tvalid);

    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  
endclass : mul_test
