class mul_sequence extends uvm_sequence#(mul_seq_item);
  `uvm_object_utils(mul_sequence)

  function new(string name = "mul_sequence");
    super.new(name);
  endfunction
    
  virtual task body();
    repeat(5) begin
    req = mul_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass

////////////////////////////////////////////////////////////////////
// Multiply _sequence - "mult" type
//////////////////////////////////////////////////////////

class mul2x2_sequence extends uvm_sequence#(mul_seq_item);
  `uvm_object_utils(mul2x2_sequence)

  function new(string name = "mul2x2_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{
      req.tdata == {8'd4, 8'd4}; 
                     })
    #10
        `uvm_do_with(req,{
      req.tdata == {8'd4, 8'd4}; 
                     })
  endtask
endclass
