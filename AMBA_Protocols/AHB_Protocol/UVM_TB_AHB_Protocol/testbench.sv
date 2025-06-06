`include "ahb_interface.sv"
`include "ahb_package.sv"

module tbench_top;

  bit HCLK;
  bit HRSTn;

  always #5 HCLK = ~HCLK;

  initial begin
    HRSTn = 0;HCLK = 1;
    #5 HRSTn =1;
  end

  ahb_if intf(HCLK,HRSTn);
  
    AHB dut (.HCLK(HCLK),
    .HRSTn(HRSTn),
             .HBUSREQ(intf.HBUSREQ),
    .HWRITE(intf.HWRITE),
    .HLOCK(intf.HLOCK),
    .HSIZE(intf.HSIZE),
    .HADDR(intf.HADDR),
    .HBURST(intf.HBURST),
    .HWDATA(intf.HWDATA),
    .HPROT(intf.HPROT),
    .HTRANS(intf.HTRANS),
    .HRDATA(intf.HRDATA),
    .HGRANT(intf.HGRANT),
    .HREADY(intf.HREADY),
    .HRESP(intf.HRESP),
    .HADDR_S(intf.HADDR_S),
    .HWRITE_S(intf.HWRITE_S),
    .HSIZE_S(intf.HSIZE_S),
    .HWDATA_S(intf.HWDATA_S),
    .HRDATA_S(intf.HRDATA_S),
    .HREADY_S(intf.HREADY_S),
    .HRESP_S(intf.HRESP_S),
    .HBURST_S(intf.HBURST_S),
    .HPROT_S(intf.HPROT_S),
    .HTRANS_S(intf.HTRANS_S));

  initial begin 
    uvm_config_db#(virtual ahb_if)::set(uvm_root::get(),"*","vif",intf);
    $dumpfile("dump.vcd"); 
    $dumpvars(0,tbench_top) ;
  end
 
  initial begin 
    run_test("ahb_wr_rd_test");
    $finish;
  end
  
endmodule
