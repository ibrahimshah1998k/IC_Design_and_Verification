class ahb_base_sequence extends uvm_sequence#(ahb_seq_item);
  `uvm_object_utils(ahb_base_sequence)

  function new(string name = "ahb_base_sequence");
    super.new(name);
  endfunction
    
  ahb_seq_item req;
  
endclass


class write_m2_s2_seq extends ahb_base_sequence;
    `uvm_object_utils(write_m2_s2_seq)

  function new(string name = "write_m2_s2_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = ahb_seq_item::type_id::create("req");
    wait_for_grant();
      assert (req.randomize() with{
        req.HBUSREQ[2] == 1; req.HBUSREQ[3] == 1; 
        req.HWRITE[2] == 1;
        req.HADDR[2] == 32'h7000_0001; // Assume Slave 0 selected
        req.HWDATA[2] == 32'd10;
        req.HSIZE[2] == 3'b010;
        req.HBURST[2] == 3'b000;
        req.HPROT[2] == 3'b000;
        req.HTRANS[2] == 3'b010;

                //ready/response from slave
        req.HRDATA_S[1] == 32'd11;
        req.HREADY_S[1] == 1;
        req.HRESP_S[1] == 0;
      })

    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass


class write_m3_m3_seq extends ahb_base_sequence;
    `uvm_object_utils(write_m3_m3_seq)
  function new(string name = "write_m3_m3_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(1) begin
    req = ahb_seq_item::type_id::create("req");
    wait_for_grant();
      assert (req.randomize() with{
        req.HBUSREQ[3] == 1; //HBUSREQ[3] = 1; 
        req.HWRITE[3] == 0;
        req.HADDR[3] == 32'hf000_0001; // Assume Slave 0 selected
        req.HWDATA[3] == 32'd10;
        req.HSIZE[3] == 3'b010;
        req.HBURST[3] == 3'b000;
        req.HPROT[3] == 3'b000;
        req.HTRANS[3] == 3'b010;

               //ready/response from slave
        req.HRDATA_S[3] == 32'd11;
        req.HREADY_S[3] == 1;
        req.HRESP_S[3] == 0;
      })

    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass
