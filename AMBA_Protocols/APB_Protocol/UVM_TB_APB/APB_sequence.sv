class APB_base_sequence extends uvm_sequence#(APB_seq_item);
  `uvm_object_utils(APB_base_sequence)

  function new(string name = "APB_base_sequence");
    super.new(name);
  endfunction
    
  APB_seq_item req;
  
endclass


class write_m2_2_s1_seq extends APB_base_sequence;
    `uvm_object_utils(write_m2_2_s1_seq)

  function new(string name = "write_m2_2_s1_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = APB_seq_item::type_id::create("req");
    wait_for_grant();
      assert (req.randomize() with{
    // Simple write request from Master 2.2 to Slave 1
        req.PSEL[2][2] == 1; req.PSEL[3][3] == 1; 
        req.PWRITE[2] == 1;
        req.PADDR[2] == 32'h7000_0003; // Assume Slave 1 selected
        req.PWDATA[2] == 32'd10;
        req.PSTRB[2] == 4'b010;

    //ready/response from slave
        req.PREADY_S[1] == 1;
      })

    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass


class write_m1_2_s3_seq extends APB_base_sequence;
    `uvm_object_utils(write_m1_2_s3_seq)
  function new(string name = "write_m1_2_s3_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = APB_seq_item::type_id::create("req");
    wait_for_grant();
      assert (req.randomize() with{
    // Simple write request from Master 1.2 to Slave 3
        req.PSEL[1][2] == 1; req.PSEL[3][2] == 1; 
        req.PWRITE[1] == 0;
        req.PADDR[1] == 32'hf000_0003; // Assume Slave 3 selected
        req.PWDATA[1] == 32'd10;
        req.PSTRB[1] == 4'b010;

    //ready/response from slave
        req.PREADY_S[3] == 1;
        req.PRDATA_S[3] == 32'd11;
      })

    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass
