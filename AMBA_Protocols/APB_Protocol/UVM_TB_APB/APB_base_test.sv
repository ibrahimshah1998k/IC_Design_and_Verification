class APB_model_base_test extends uvm_test;
  `uvm_component_utils(APB_model_base_test)

  APB_model_env env;

  function new(string name = "APB_model_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = APB_model_env::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration();
    print();
  endfunction

  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);

    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end else begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      uvm_report_info(get_full_name(), "run_phase started", UVM_MEDIUM);
    end
  endfunction
  
  virtual function void start_of_simulation_phase(uvm_phase phase);
  uvm_factory::get().print();
endfunction



endclass : APB_model_base_test


class APB_wr_rd_test extends APB_model_base_test;
  `uvm_component_utils(APB_wr_rd_test)

  // Declare all your sequences here
  write_m2_2_s1_seq  seq1;
  write_m1_2_s3_seq  seq2;

  function new(string name = "APB_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq1 = write_m2_2_s1_seq::type_id::create("seq1");
    seq2 = write_m1_2_s3_seq::type_id::create("seq2");
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Starting run_phase", UVM_MEDIUM)

    phase.raise_objection(this, "Running multiple sequences");

    // Start each sequence on the sequencer
   seq1.start(env.APB_agnt.sequencer);
    seq2.start(env.APB_agnt.sequencer);
    phase.drop_objection(this, "Sequences finished");

    `uvm_info(get_type_name(), "run_phase completed", UVM_MEDIUM)
    `uvm_info(get_type_name(), "Starting run_phase for APB_wr_rd_test", UVM_LOW)

  endtask

endclass
