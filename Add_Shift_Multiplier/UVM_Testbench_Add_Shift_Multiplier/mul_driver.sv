class mul_driver extends uvm_driver #(mul_seq_item);
  `uvm_component_utils(mul_driver)

  virtual axi_stream_if master_to_multiplier;
  
  uvm_analysis_port #(mul_seq_item) drv2sb; 

  function new (string name = "mul_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_stream_if)::get(this, "", "master_to_multiplier", master_to_multiplier)) 
       `uvm_fatal("driver", "unable to get interface");

    drv2sb = new("drv2sb", this);  
  endfunction: build_phase



  virtual task run_phase(uvm_phase phase);
        //vif.rst = 0;  //try to initilize DUT not the seq
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
      $display("Time: %d,  Driver_Class",$time);

    end
  endtask : run_phase

  virtual task drive();
    master_to_multiplier.tvalid = 1;
    master_to_multiplier.tdata  = req.tdata;

    wait(master_to_multiplier.tready);
    @(posedge master_to_multiplier.clk);
    master_to_multiplier.tvalid = 0; 
  endtask : drive
  
endclass : mul_driver
