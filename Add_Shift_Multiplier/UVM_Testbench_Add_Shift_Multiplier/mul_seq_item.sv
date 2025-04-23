class mul_seq_item extends uvm_sequence_item ;

 rand bit   tvalid;
 rand bit         tready;
  rand bit [15:0] tdata;

  `uvm_object_utils_begin(mul_seq_item)
  `uvm_field_int(tvalid,UVM_ALL_ON)
  `uvm_field_int(tready,UVM_ALL_ON)
  `uvm_field_int(tdata,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "mul_seq_item");
    super.new(name);
  endfunction

  //constraint  
  
endclass
