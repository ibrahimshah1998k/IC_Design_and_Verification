// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_AHB_APB_Bridge;

  logic HCLK;
  logic HRSTn;

  // AHB Slave interface signals
  logic [31:0] HADDR_S;
  logic        HWRITE_S;
  logic [2:0]  HSIZE_S;
  logic [31:0] HWDATA_S;
  logic        HTRANS_S;
  logic [31:0] HRDATA_S;
  logic        HREADY_S;
  logic        HRESP_S;

  // APB Master interface signals
  logic [31:0] PADDR;
  logic        PWRITE;
  logic [31:0] PWDATA;
  logic [3:0]  PSTRB;
  logic        PENABLE;
  logic        PSEL     [3:0];
  logic [31:0] PRDATA;
  logic        PREADY;
  logic        PGRANT;

  // Instantiate the Bridge
  AHB_APB_Bridge dut (
    .HCLK(HCLK),
    .HRSTn(HRSTn),
    .HADDR_S(HADDR_S),
    .HWRITE_S(HWRITE_S),
    .HSIZE_S(HSIZE_S),
    .HWDATA_S(HWDATA_S),
    .HTRANS_S(HTRANS_S),
    .HRDATA_S(HRDATA_S),
    .HREADY_S(HREADY_S),
    .HRESP_S(HRESP_S),
    .PADDR(PADDR),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PSTRB(PSTRB),
    .PENABLE(PENABLE),
    .PSEL(PSEL),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PGRANT(PGRANT)
  );

  // Clock generation
  always #5 HCLK = ~HCLK;

  // Test logic
  initial begin
    // Initialize
    HCLK = 0;
    HRSTn = 0;
    HADDR_S = 0;
    HWRITE_S = 0;
    HSIZE_S = 0;
    HWDATA_S = 0;
    HTRANS_S = 0;
    PRDATA = 32'hAAAA_BBBB;
    PREADY = 1;
    PGRANT = 1;

    // Reset
    repeat (2) @(posedge HCLK);
    HRSTn = 1;

    // Wait for few clocks
    //repeat (1) @(posedge HCLK);

    // Test Write Operation
    HADDR_S = 32'hC000_0000; // target slave 3
    HWRITE_S = 1;
    HSIZE_S = 3'b010; // Word
    HWDATA_S = 32'h1234_5678;
    HTRANS_S = 1;
    repeat (5) @(posedge HCLK);

    // Test Read Operation
    HADDR_S = 32'h8000_0000; // target slave 2
    HWRITE_S = 0;
    HSIZE_S = 3'b001; // Half-word
    HTRANS_S = 1;
    PRDATA = 32'hDEAD_BEEF;
    repeat (5) @(posedge HCLK);

    $display("Testbench completed.");
    $finish;
  end
  
  initial 
    begin
      $dumpfile("dump.vcd"); 
      $dumpvars(0,tb_AHB_APB_Bridge) ;
    end

endmodule
