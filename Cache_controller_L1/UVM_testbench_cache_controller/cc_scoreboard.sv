class cc_scoreboard extends uvm_scoreboard;

 
 // uvm_analysis_imp#(mem_seq_item, mem_scoreboard) item_collected_export;
  `uvm_component_utils(cc_scoreboard)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      //item_collected_export = new("item_collected_export", this);
 
  endfunction: build_phase

//   virtual function void write(mem_seq_item pkt);
//   endfunction : write


  virtual task run_phase(uvm_phase phase);
  
    
//     forever begin
    //     end
    $display("Time: %d,  Scoreboard_Class",$time);
      //end
    //end
  endtask : run_phase
endclass : cc_scoreboard
