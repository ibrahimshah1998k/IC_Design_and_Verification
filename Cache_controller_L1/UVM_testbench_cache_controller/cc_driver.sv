`define DRIV_IF vif.DRIVER.driver_cb

class cc_driver extends uvm_driver #(cc_seq_item);
  `uvm_component_utils(cc_driver)

  virtual cc_if vif;
  uvm_analysis_port #(cc_seq_item) drv2sb;

  function new(string name = "cc_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual cc_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});

    drv2sb = new("drv2sb", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      drv2sb.write(req);  // optionally send to scoreboard
      `uvm_info(get_full_name(), $sformatf("driver transaction:\n%s", req.sprint()), UVM_MEDIUM);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    `DRIV_IF.ready <= 1;

    // Handle reset
    if (vif.rst) begin
      `DRIV_IF.read_c         <= 0;
      `DRIV_IF.write_c        <= 0;
      `DRIV_IF.cache_flush    <= 0;
      `DRIV_IF.data_mp_to_c   <= 0;
      `DRIV_IF.address        <= 0;
      `DRIV_IF.data_mem_to_c  <= 0;
      #5;
    end

    // Handle read
    else if (req.read_c) begin
      `DRIV_IF.read_c         <= 1;
      `DRIV_IF.write_c        <= 0;
      `DRIV_IF.address        <= req.address;
      `DRIV_IF.data_mem_to_c  <= req.data_mem_to_c;
      repeat (4) @(posedge vif.clk);
      `DRIV_IF.read_c         <= 0;
      repeat (2) @(posedge vif.clk);
    end

    // Handle write
    else if (req.write_c) begin
      `DRIV_IF.write_c        <= 1;
      `DRIV_IF.read_c         <= 0;
      `DRIV_IF.address        <= req.address;
      `DRIV_IF.data_mp_to_c   <= req.data_mp_to_c;
      repeat (4) @(posedge vif.clk);
      `DRIV_IF.write_c        <= 0;
      repeat (2) @(posedge vif.clk);
    end
  endtask
endclass : cc_driver
