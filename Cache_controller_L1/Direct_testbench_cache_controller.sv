module tb_cache_controller;
  logic clk = 0, rst = 0;
  logic read_c, write_c, cache_flush, ready;
  logic [15:0] address;
  logic [31:0] data_mp_to_c, data_mem_to_c;
  logic [31:0] data_c_to_mp, data_c_to_mem;
  logic wr;

  always #5 clk = ~clk;

  cache_controller uut (
    .read_c(read_c), .write_c(write_c), .clk(clk), .rst(rst),
    .cache_flush(cache_flush), .ready(ready),
    .address(address), .data_mp_to_c(data_mp_to_c),
    .data_mem_to_c(data_mem_to_c),
    .data_c_to_mp(data_c_to_mp), .data_c_to_mem(data_c_to_mem),
    .wr(wr)
  );

  initial begin
    rst = 1; read_c = 0; write_c = 0; cache_flush = 0;
    data_mp_to_c = 0; address = 0; data_mem_to_c = 0;
    ready = 1;
    #5;
    rst = 0;

    //read miss 1, update cache from mem & then send data to mp
    read_c = 1;
    address = 16'h00AA;
    data_mem_to_c = 32'd1;
    #50;
    read_c = 0;
    #20
    //read miss 2, update cache from mem & then send data to mp
    read_c = 1;
    address = 16'h00AB;
    data_mem_to_c = 32'd2;
    #40;
    read_c = 0;
    #20
        //read miss 3, update cache from mem & then send data to mp
    read_c = 1;
    address = 16'h00AC;
    data_mem_to_c = 32'd3;
    #40;
    read_c = 0;
    #20
    //read hit 1, send data to mp
    read_c = 1;
    address = 16'h00AA;
    data_mem_to_c = 32'd2;
    #30;
    read_c = 0;
    #20
    //read hit 3, send data to mp
    read_c = 1;
    address = 16'h00AC;
    data_mem_to_c = 32'd3;
    #30;
    read_c = 0;
    #20
    //read hit 2, send data to mp
    read_c = 1;
    address = 16'h00AB;
    data_mem_to_c = 32'd2;
    #30;
    read_c = 0;
    #20
    //write hit 1: write through policy, write data on cache and then write into memory
    write_c = 1;
    address = 16'h00AA;
    data_mp_to_c = 32'd11;
    #30;
    write_c = 0;
    #20
    //write hit 2: write through policy, write data on cache and then write into memory
    write_c = 1;
    address = 16'h00AB;
    data_mp_to_c = 32'd22;
    #30
    write_c = 0;
    #20
    //read hit: read the previous written data1
    read_c = 1;
    address = 16'h00AA;
    data_mem_to_c = 32'd1;
    #30
    read_c = 0;
    #20
    //read hit: read the previous written data2
    read_c = 1;
    address = 16'h00AB;
    data_mem_to_c = 32'd2;
    #30;
    read_c = 0;
    #20
    //write miss: Write from mp to mem directly
    write_c = 1;
    address = 16'h00AD;
    data_mp_to_c = 32'd33;
    #30
    write_c = 0;


    #50 $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_cache_controller);
  end
  
endmodule
