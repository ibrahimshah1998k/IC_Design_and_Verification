class mul_coverage extends uvm_subscriber #(mul_seq_item);
  `uvm_component_utils(mul_coverage)
  mul_seq_item trans_collected;

  covergroup mul_cg;
    
    // cp, multiplcand and multipler values
    multiplicand_cp: coverpoint trans_collected.tdata[15:8] {
     bins zero = {8'b00000000};
      bins ones = {8'b11111111};
      bins power_of_2[] = {8'b00000001, 8'b00000010, 8'b00000100, 
                           8'b00001000, 8'b00010000, 8'b00100000, 
                           8'b01000000, 8'b10000000};
      bins others = default;
    }

    multiplier_cp: coverpoint trans_collected.tdata[7:0] {
     bins zero = {8'b00000000};
      bins ones = {8'b11111111};
    bins power_of_2[] = {8'b00000001, 8'b00000010, 8'b00000100, 
                           8'b00001000, 8'b00010000, 8'b00100000, 
                           8'b01000000, 8'b10000000};
      bins others = default;
    }

 // cp, final value
    result_cp: coverpoint trans_collected.tdata {
      bins zero = {16'b0000000000000000};
     bins max = {16'b1111111111111111};
      bins odd_values = {[16'h0001 : 16'hFFFD]};  
   bins even_values = {[16'h0002 : 16'hFFFE]}; 
    }

 //cp, control signals
    tvalid_cp: coverpoint trans_collected.tvalid {
      bins active = {1'b1};
      bins inactive = {1'b0};
    }
    tready_cp: coverpoint trans_collected.tready {
      bins active = {1'b1};
      bins inactive = {1'b0};
    }
           // cg
    mult_vs_multicand: cross multiplicand_cp, multiplier_cp;
   mult_vs_result: cross multiplier_cp, result_cp;
  multicand_vs_result: cross multiplicand_cp, result_cp;
    
  endgroup : mul_cg

  function new(string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = mul_seq_item::type_id::create("trans_collected");
    mul_cg = new();
  endfunction

  virtual function void write(mul_seq_item trans);
    trans_collected = trans;
    mul_cg.sample(); 
    `uvm_info(get_full_name(), "something", UVM_LOW)
  endfunction
endclass : mul_coverage
