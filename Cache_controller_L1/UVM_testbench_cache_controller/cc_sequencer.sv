class cc_sequencer extends uvm_sequencer#(cc_seq_item);
  `uvm_component_utils(cc_sequencer) 
  function new(string name = "cc_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
