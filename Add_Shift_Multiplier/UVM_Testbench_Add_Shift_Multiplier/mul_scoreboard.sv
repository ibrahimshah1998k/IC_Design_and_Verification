class mul_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(mul_scoreboard)

  uvm_analysis_imp#(mul_seq_item, mul_scoreboard) item_collected_export;

  mul_seq_item trans_q[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction: build_phase

  virtual function void write(mul_seq_item trans);
    trans_q.push_back(trans);
  endfunction : write

  virtual task run_phase(uvm_phase phase);
    
    mul_seq_item trans;
    bit [15:0] expected_result;
 $display("Time: %d,  Scoreboard_Class",$time);
 
    forever begin
       $display("Time: %d,  Scoreboard_Class",$time);
      wait(trans_q.size() > 0);
       $display("Time: %d,  Scoreboard_Class",$time);
      trans = trans_q.pop_front();  

      expected_result = trans.tdata[7:0] * trans.tdata[15:8];

      if (expected_result == trans.tdata) begin  
        $display("The expected result is: %0d and the Dut result is %0d, Which are matching", expected_result, trans.tdata);
      end else begin 
        $display("The expected result is: %0d and the Dut result is %0d, Which are not matching", expected_result, trans.tdata);
      end
      
    end
  endtask : run_phase

endclass : mul_scoreboard
