class APB_sequencer extends uvm_sequencer#(APB_seq_item);
  `uvm_component_utils(APB_sequencer) 
  function new(string name = "ahb_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
