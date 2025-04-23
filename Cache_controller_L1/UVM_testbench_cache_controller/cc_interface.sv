
interface cc_if(input clk,rst);

   bit read_c;
   bit write_c;
   bit cache_flush;
   bit [15:0] address;
   bit ready;
   bit wr;
   bit [31:0] data_mp_to_c;
   bit [31:0] data_mem_to_c;
   bit [31:0] data_c_to_mp;
   bit [31:0] data_c_to_mem;

  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output read_c;
    output write_c;
    output cache_flush;
    output address;
    output ready;
    input wr;
    output data_mp_to_c;
    output data_mem_to_c;
    input data_c_to_mp;
    input data_c_to_mem;
  endclocking
  
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input read_c;
    input write_c;
    input cache_flush;
    input address;
    input ready;
    input wr;
    input data_mp_to_c;
    input data_mem_to_c;
    input data_c_to_mp;
    input data_c_to_mem;
  endclocking
  

  modport DRIVER  (clocking driver_cb,input clk,rst);
  
  modport MONITOR (clocking monitor_cb,input clk,rst);
  
endinterface

