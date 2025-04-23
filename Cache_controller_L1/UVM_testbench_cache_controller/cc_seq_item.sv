class cc_seq_item extends uvm_sequence_item;

  rand bit read_c;
  rand bit write_c;
  rand bit cache_flush;
  rand bit [15:0] address;
  rand bit ready;
       bit wr;
  rand bit [31:0] data_mp_to_c;
  rand bit [31:0] data_mem_to_c;
       bit [31:0] data_c_to_mp;
       bit [31:0] data_c_to_mem;

  `uvm_object_utils_begin(cc_seq_item)
  `uvm_field_int(read_c,UVM_ALL_ON)
  `uvm_field_int(write_c,UVM_ALL_ON)
  `uvm_field_int(cache_flush,UVM_ALL_ON)
  `uvm_field_int(address,UVM_ALL_ON)
  `uvm_field_int(ready,UVM_ALL_ON)
  `uvm_field_int(wr,UVM_ALL_ON)
  `uvm_field_int(data_mp_to_c,UVM_ALL_ON)
  `uvm_field_int(data_mem_to_c,UVM_ALL_ON)
  `uvm_field_int(data_c_to_mp,UVM_ALL_ON)
  `uvm_field_int(data_c_to_mem,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "cc_seq_item");
    super.new(name);
  endfunction

 // constraint wr_rd_c { !(read_c && write_c); } 
  
endclass
