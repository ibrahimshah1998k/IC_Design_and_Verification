`timescale 10ns/10ps
`include "mul_interface.sv"
`include "mul_package.sv"

module testbench;

  bit clk;
  bit rst_n;

  always #5 clk = ~clk;

  initial begin
    rst_n = 0;clk = 0;
    @(posedge clk) rst_n =1;
  end

  axi_stream_if master_to_multiplier(clk,rst_n);
  axi_stream_if multiplier_to_slave(clk,rst_n);

  add_shift_multiplier DUT (
    .clk(clk),
    .axis_operands(master_to_multiplier.Slave),
    .rst_n(rst_n),
    .axis_result(multiplier_to_slave.Master)
   );
 
  initial begin 
    uvm_config_db#(virtual axi_stream_if)::set(uvm_root::get(),"*","master_to_multiplier",master_to_multiplier);
    
        uvm_config_db#(virtual axi_stream_if)::set(uvm_root::get(),"*","multiplier_to_slave",multiplier_to_slave);
    
    
    $dumpfile("dump.vcd");
    $dumpvars(0,testbench);
  end
 
  initial begin 
    run_test("mul_test");
    #1000
    $finish;
  end
  
endmodule
