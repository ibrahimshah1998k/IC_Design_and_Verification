class cc_model_base_test extends uvm_test;
  `uvm_component_utils(cc_model_base_test)

  cc_model_env env;

  function new(string name = "cc_model_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = cc_model_env::type_id::create("env", this);
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



endclass : cc_model_base_test


class cc_wr_rd_test extends cc_model_base_test;
  `uvm_component_utils(cc_wr_rd_test)

  // Declare all your sequences here
  read_miss1_seq  seq1;
  read_miss2_seq  seq2;
  read_miss3_seq  seq3;
  read_hit1_seq   seq4;
  read_hit3_seq   seq5;
  read_hit2_seq   seq6;
  write_hit1_seq  seq7;
  write_hit2_seq  seq8;
  read_hit4_seq   seq9;
  read_hit5_seq   seq10;
  write_miss1_seq  seq11;

  function new(string name = "cc_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq1 = read_miss1_seq::type_id::create("seq1");
    seq2 = read_miss2_seq::type_id::create("seq2");
    seq3 = read_miss3_seq::type_id::create("seq3");
    seq4 = read_hit1_seq::type_id::create("seq4");
    seq5 = read_hit3_seq::type_id::create("seq5");
    seq6 = read_hit2_seq::type_id::create("seq6");
    seq7 = write_hit1_seq::type_id::create("seq7");
    seq8 = write_hit2_seq::type_id::create("seq8");
    seq9 = read_hit4_seq::type_id::create("seq9");
    seq10 = read_hit5_seq::type_id::create("seq10");
    seq11 = write_miss1_seq::type_id::create("seq11");

  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Starting run_phase", UVM_MEDIUM)

    phase.raise_objection(this, "Running multiple sequences");

    // Start each sequence on the sequencer
    seq1.start(env.cc_agnt.sequencer);
    seq2.start(env.cc_agnt.sequencer);
    seq3.start(env.cc_agnt.sequencer);
    seq4.start(env.cc_agnt.sequencer);
    seq5.start(env.cc_agnt.sequencer);
    seq6.start(env.cc_agnt.sequencer);
    seq7.start(env.cc_agnt.sequencer);
    seq8.start(env.cc_agnt.sequencer);
    seq9.start(env.cc_agnt.sequencer);
    seq10.start(env.cc_agnt.sequencer);
    seq11.start(env.cc_agnt.sequencer);
    phase.drop_objection(this, "Sequences finished");

    `uvm_info(get_type_name(), "run_phase completed", UVM_MEDIUM)
    `uvm_info(get_type_name(), "Starting run_phase for cc_wr_rd_test", UVM_LOW)

  endtask

endclass
