`include "cc_interface.sv"
`include "cc_package.sv"

module tbench_top;

  bit clk;
  bit rst;

  always #5 clk = ~clk;

  initial begin
    rst = 1;clk = 1;
    #5 rst =0;
  end

  cc_if intf(clk,rst);

  cache_controller DUT (
    .clk(clk), .rst(rst),
  .read_c(intf.read_c),
  .write_c(intf.write_c),
  .cache_flush(intf.cache_flush),
  .ready(intf.ready),
  .wr(intf.wr),
  .address(intf.address),
  .data_mem_to_c(intf.data_mem_to_c),
  .data_mp_to_c(intf.data_mp_to_c),
  .data_c_to_mp(intf.data_c_to_mp),
  .data_c_to_mem(intf.data_c_to_mem)
   );
  
 
  initial begin 
    uvm_config_db#(virtual cc_if)::set(uvm_root::get(),"*","vif",intf);
    $dumpfile("dump.vcd"); 
    $dumpvars(0,tbench_top) ;
  end
 
  initial begin 
    run_test("cc_wr_rd_test");
    $finish;
  end
  
endmodule
