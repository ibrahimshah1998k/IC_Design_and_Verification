// Code your testbench here
// or browse Examples
module tb_APB;
  logic PCLK = 0, PRSTn;
  logic PWRITE[0:3];
  logic [31:0]PADDR[0:3], PWDATA[0:3], PRDATA[0:3];
  logic PGRANT[0:3], PREADY[0:3], PENABLE[0:3];
  logic [3:0]PSTRB[0:3];
  logic PSEL[0:3][0:3];

  logic PWRITE_S[0:3];
  logic [31:0]PADDR_S[0:3], PWDATA_S[0:3], PRDATA_S[0:3];
  logic PREADY_S[0:3], PENABLE_S[0:3];
  logic [3:0]PSTRB_S[0:3];
  logic PSEL_S[0:3];

  APB dut (.PCLK(PCLK),
           .PRSTn(PRSTn),
           .PWRITE(PWRITE),
           .PENABLE(PENABLE),
           .PSTRB(PSTRB),
           .PADDR(PADDR),
           .PSEL(PSEL),
           .PWDATA(PWDATA),
           .PRDATA(PRDATA),
           .PGRANT(PGRANT),
           .PREADY(PREADY),
           .PWRITE_S(PWRITE_S),
           .PENABLE_S(PENABLE_S),
           .PSTRB_S(PSTRB_S),
           .PADDR_S(PADDR_S),
           .PSEL_S(PSEL_S),
           .PWDATA_S(PWDATA_S),
           .PRDATA_S(PRDATA_S),
           .PREADY_S(PREADY_S));

  always #5 PCLK = ~PCLK;

  initial begin
    PRSTn = 0;
    repeat(2) @(posedge PCLK);
    PRSTn = 1;

    // Simple write request from Master 2.2 to Slave 1
    PSEL[2][2] = 1; PSEL[3][3] = 1; 
    PWRITE[2] = 1;
    PADDR[2] = 32'h7000_0003; // Assume Slave 1 selected
    PWDATA[2] = 32'd10;
    PSTRB[2] = 4'b010;
    PENABLE[2] = 0;
    
    //ready/response from slave
    PREADY_S[1] = 1;
//     @(posedge PCLK)
    @(posedge PCLK)
    @(posedge PCLK)
    PENABLE[2]=1;
    @(posedge PCLK)
    PENABLE[2]=0;
    PSEL[2][2] = 0; PSEL[3][3] = 0;
   @(posedge PCLK)
    
    // Simple write request from Master 1.2 to Slave 3
    PSEL[1][2] = 1; PSEL[3][2] = 1; 
    PWRITE[1] = 0;
    PADDR[1] = 32'hf000_0003; // Assume Slave 3 selected
    PWDATA[1] = 32'd10;
    PSTRB[1] = 4'b010;
    PENABLE[1] = 0;

    //ready/response from slave
    PREADY_S[3] = 1;
    PRDATA_S[3] = 32'd11;
    @(posedge PCLK)
    @(posedge PCLK)
    PENABLE[1] = 1;
    @(posedge PCLK)
    PENABLE[1]=0;
    PSEL[1][2] = 0; PSEL[3][2] = 0;
   @(posedge PCLK) 

    repeat(1) @(posedge PCLK);
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0,tb_APB) ;
  end

endmodule
