interface ahb_if(input HCLK, HRSTn);

  //master interface signals (4 masters)
  bit        HBUSREQ  [0:3];
  bit        HWRITE   [0:3];
  bit        HGRANT   [0:3];
  bit [2:0]  HSIZE    [0:3];
  bit        HLOCK    [0:3];
  bit [31:0] HADDR    [0:3];
  bit [2:0]  HBURST   [0:3];
  bit [31:0] HWDATA   [0:3];
  bit [2:0]  HPROT    [0:3];
  bit [31:0] HRDATA   [0:3];
  bit [2:0]  HTRANS   [0:3];
  bit        HREADY   [0:3];
  bit        HRESP    [0:3];

  //slave interface signals (4 slaves)
  bit [31:0] HADDR_S  [0:3];
  bit        HWRITE_S [0:3];
  bit [2:0]  HSIZE_S  [0:3];
  bit [31:0] HWDATA_S [0:3];
  bit [31:0] HRDATA_S [0:3];
  bit        HREADY_S [0:3];
  bit        HRESP_S  [0:3];
  bit [2:0]  HBURST_S [0:3];
  bit [2:0]  HPROT_S  [0:3];
  bit [2:0]  HTRANS_S [0:3];
// we cannot use arrayed signals in clocing block, so better to not use clocking blocks at the cost of great care in signals timings (setup time etc.)
//   clocking driver_cb @(posedge HCLK);
//     default input #1 output #1;
    
//   //master interface signals (4 masters)
//     output         HBUSREQ  [0:3];
//     output         HWRITE   [0:3];
//     input          HGRANT   [0:3];
//     output  [2:0]  HSIZE    [0:3];
//     output         HLOCK    [0:3];
//     output  [31:0] HADDR    [0:3];
//     output  [2:0]  HBURST   [0:3];
//     output  [31:0] HWDATA   [0:3];
//     output  [2:0]  HPROT    [0:3];
//     input   [31:0] HRDATA   [0:3];
//     output  [2:0]  HTRANS   [0:3];
//     input          HREADY   [0:3];
//     input          HRESP    [0:3];

//   //slave interface signals (4 slaves)
//     input [31:0] HADDR_S  [0:3];
//     input        HWRITE_S [0:3];
//     input [2:0]  HSIZE_S  [0:3];
//     input [31:0] HWDATA_S [0:3];
//     output[31:0] HRDATA_S [0:3];
//     output       HREADY_S [0:3];
//     output       HRESP_S  [0:3];
//     input [2:0]  HBURST_S [0:3];
//     input [2:0]  HPROT_S  [0:3];
//     input [2:0]  HTRANS_S [0:3];
//   endclocking
  
//   clocking monitor_cb @(posedge clk);
//     default input #1 output #1;
//     //master interface signals (4 masters)
//     input         HBUSREQ  [0:3];
//     input         HWRITE   [0:3];
//     input         HGRANT   [0:3];
//     input  [2:0]  HSIZE    [0:3];
//     input         HLOCK    [0:3];
//     input  [31:0] HADDR    [0:3];
//     input  [2:0]  HBURST   [0:3];
//     input  [31:0] HWDATA   [0:3];
//     input  [2:0]  HPROT    [0:3];
//     input  [31:0] HRDATA   [0:3];
//     input  [2:0]  HTRANS   [0:3];
//     input         HREADY   [0:3];
//     input         HRESP    [0:3];

//   //slave interface signals (4 slaves)
//     input [31:0] HADDR_S  [0:3];
//     input        HWRITE_S [0:3];
//     input [2:0]  HSIZE_S  [0:3];
//     input [31:0] HWDATA_S [0:3];
//     input [31:0] HRDATA_S [0:3];
//     input        HREADY_S [0:3];
//     input        HRESP_S  [0:3];
//     input [2:0]  HBURST_S [0:3];
//     input [2:0]  HPROT_S  [0:3];
//     input [2:0]  HTRANS_S [0:3];
//   endclocking
  

  modport DRIVER  (/*clocking driver_cb,*/input HCLK, HRSTn);
  
  modport MONITOR (/*clocking monitor_cb,*/input HCLK, HRSTn);
  
endinterface

