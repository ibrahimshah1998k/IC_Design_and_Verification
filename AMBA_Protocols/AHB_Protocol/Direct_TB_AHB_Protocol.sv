module tb_AHB;
  logic HCLK = 0, HRSTn;
  logic HBUSREQ[0:3], HWRITE[0:3], HLOCK[0:3];
  logic [2:0]HSIZE[0:3], HBURST[0:3], HPROT[0:3], HTRANS[0:3];
  logic [31:0]HADDR[0:3], HWDATA[0:3];
  logic [31:0]HRDATA[0:3];
  logic HGRANT[0:3], HREADY[0:3], HRESP[0:3];

  logic HWRITE_S[0:3], HREADY_S[0:3], HRESP_S[0:3];
  logic [2:0]HSIZE_S[0:3], HBURST_S[0:3], HPROT_S[0:3], HTRANS_S[0:3];
  logic [31:0]HADDR_S[0:3], HWDATA_S[0:3], HRDATA_S[0:3];

  AHB dut (.HCLK(HCLK),
    .HRSTn(HRSTn),
    .HBUSREQ(HBUSREQ),
    .HWRITE(HWRITE),
    .HLOCK(HLOCK),
    .HSIZE(HSIZE),
    .HADDR(HADDR),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HPROT(HPROT),
    .HTRANS(HTRANS),
    .HRDATA(HRDATA),
    .HGRANT(HGRANT),
    .HREADY(HREADY),
    .HRESP(HRESP),
    .HADDR_S(HADDR_S),
    .HWRITE_S(HWRITE_S),
    .HSIZE_S(HSIZE_S),
    .HWDATA_S(HWDATA_S),
    .HRDATA_S(HRDATA_S),
    .HREADY_S(HREADY_S),
    .HRESP_S(HRESP_S),
    .HBURST_S(HBURST_S),
    .HPROT_S(HPROT_S),
    .HTRANS_S(HTRANS_S));

  always #5 HCLK = ~HCLK;

  initial begin
    HRSTn = 0;
    repeat(2) @(posedge HCLK);
    HRSTn = 1;

    // Simple write request from Master 2 to Slave 2
    HBUSREQ[2] = 1; HBUSREQ[3] = 1; 
    HWRITE[2] = 1;
    HADDR[2] = 32'h7000_0001; // Assume Slave 0 selected
    HWDATA[2] = 32'd10;
    HSIZE[2] = 3'b010;
    HBURST[2] = 3'b000;
    HPROT[2] = 3'b000;
    HTRANS[2] = 3'b010;

    //ready/response from slave
    HRDATA_S[1] = 32'd11;
    HREADY_S[1] = 1;
    HRESP_S[1] = 0;
    @(posedge HCLK)
    @(posedge HCLK)
    HBUSREQ[2]=0; HBUSREQ[3]=0;
    
    @(posedge HCLK)
    @(posedge HCLK)
    @(posedge HCLK)
    @(posedge HCLK)
    
    // Simple write request from Master 3 to Slave 3
    HBUSREQ[3] = 1; //HBUSREQ[3] = 1; 
    HWRITE[3] = 0;
    HADDR[3] = 32'hf000_0001; // Assume Slave 0 selected
    HWDATA[3] = 32'd10;
    HSIZE[3] = 3'b010;
    HBURST[3] = 3'b000;
    HPROT[3] = 3'b000;
    HTRANS[3] = 3'b010;

    //ready/response from slave
    HRDATA_S[3] = 32'd11;
    HREADY_S[3] = 1;
    HRESP_S[3] = 0;
    @(posedge HCLK)
    @(posedge HCLK)
    HBUSREQ[2]=0; HBUSREQ[3]=0;

    repeat(10) @(posedge HCLK);
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0,tb_AHB) ;
  end

endmodule
