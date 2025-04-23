interface axi_stream_if #(
  parameter int AXI_STREAM_DATA_WIDTH = 16
);

  logic                             tvalid;
  logic                             tready;
  logic [AXI_STREAM_DATA_WIDTH-1:0] tdata;

  modport Master (output tvalid, input  tready, output tdata);
  modport Slave  (input  tvalid, output tready, input  tdata);
endinterface


/************************** Imports ******************************************/

//  If you would like to import or `include any files you create, you may do so here

/*****************************************************************************/

module testbench;

  bit clk;
  bit rst_n;

  axi_stream_if master_to_multiplier();
  axi_stream_if multiplier_to_slave();

  add_shift_multiplier dut(
    .clk                (clk                        ),
    .rst_n              (rst_n                      ),
    .axis_operands      (master_to_multiplier.Slave ),
    .axis_result        (multiplier_to_slave.Master )
  );
  
  always #10 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
  end

  // if the design is not reset within 1000 clock cycles, invoke a timeout
  bit dut_rst = '0;
  initial begin : timeout_monitor
    repeat(1000) @(posedge clk);
    if(!dut_rst) begin
      $display("\nDesign timed out...\n");
      $finish();
    end
  end : timeout_monitor
  always @(posedge rst_n) begin
    dut_rst <= '1;
  end

  assign multiplier_to_slave.tready = '1;

//   /************************** YOUR CODE HERE ***********************************/

initial begin
  rst_n=0; 
  @(posedge clk)
  rst_n=1;
  master_to_multiplier.tvalid=1;
 // #5 //@(posedge clk)
  wait(master_to_multiplier.tready)  //
  master_to_multiplier.tdata = {8'd4, 8'd4};
      @(posedge clk)
    master_to_multiplier.tvalid=0; 
  
  wait(multiplier_to_slave.tvalid)
  $display("the result of multiplication is %d",   multiplier_to_slave.tdata);
  #1000;
  $finish;
end
 /*****************************************************************************/

endmodule
