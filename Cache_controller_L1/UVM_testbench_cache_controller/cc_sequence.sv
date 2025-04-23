class cc_base_sequence extends uvm_sequence#(cc_seq_item);
  `uvm_object_utils(cc_base_sequence)

  function new(string name = "cc_base_sequence");
    super.new(name);
  endfunction
    
  cc_seq_item req;
  
endclass


class read_miss1_seq extends cc_base_sequence;
    `uvm_object_utils(read_miss1_seq)

  function new(string name = "read_miss1_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
    wait_for_grant();
      #5
      assert (req.randomize() with{
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AA;
    			req.data_mem_to_c == 32'd1;
      })
        #5
    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass

class read_miss2_seq extends cc_base_sequence;
  `uvm_object_utils(read_miss2_seq)

  function new(string name = "read_miss2_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
    start_item(req);
      assert (req.randomize() with{
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AB;
    			req.data_mem_to_c == 32'd2;
      })
    finish_item(req);
   end 
  endtask
endclass

class read_miss3_seq extends cc_base_sequence;
  `uvm_object_utils(read_miss3_seq)

  function new(string name = "read_miss3_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
    start_item(req);
      assert (req.randomize() with{
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AC;
    			req.data_mem_to_c == 32'd3;
      })
    finish_item(req);
   end 
  endtask
endclass

class read_hit1_seq extends cc_base_sequence;
  `uvm_object_utils(read_hit1_seq)

  function new(string name = "read_hit1_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AA;
      })
   end 
  endtask
endclass

class read_hit3_seq extends cc_base_sequence;
  `uvm_object_utils(read_hit3_seq)

  function new(string name = "read_hit3_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AC;
      })
   end 
  endtask
endclass

class read_hit2_seq extends cc_base_sequence;
  `uvm_object_utils(read_hit2_seq)

  function new(string name = "read_hit2_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AB;
      })
   end 
  endtask
endclass

class write_hit1_seq extends cc_base_sequence;
  `uvm_object_utils(write_hit1_seq)

  function new(string name = "write_hit1_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.write_c == 1;
                req.read_c == 0;
    			req.address == 16'h00AA;
    			req.data_mp_to_c == 32'd11;
      })
   end 
  endtask
endclass

class write_hit2_seq extends cc_base_sequence;
  `uvm_object_utils(write_hit2_seq)

  function new(string name = "write_hit2_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.write_c == 1;
                req.read_c == 0;
    			req.address == 16'h00AB;
    			req.data_mp_to_c == 32'd22;
      })
   end 
  endtask
endclass

class read_hit4_seq extends cc_base_sequence;
  `uvm_object_utils(read_hit4_seq)

  function new(string name = "read_hit4_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AA;
      })
   end 
  endtask
endclass

class read_hit5_seq extends cc_base_sequence;
  `uvm_object_utils(read_hit5_seq)

  function new(string name = "read_hit5_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.read_c == 1;
                req.write_c == 0;
    			req.address == 16'h00AB;
      })
   end 
  endtask
endclass

class write_miss1_seq extends cc_base_sequence;
  `uvm_object_utils(write_miss1_seq)

  function new(string name = "write_miss1_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = cc_seq_item::type_id::create("req");
      `uvm_do_with(req, {
                req.write_c == 1;
                req.read_c == 0;
    			req.address == 16'h00AD;
      })
   end 
  endtask
endclass
