interface axi_stream_if #(
  parameter int AXI_STREAM_DATA_WIDTH = 16
) (input logic clk,rst_n);

  logic                             tvalid;
  logic                             tready;
  logic [AXI_STREAM_DATA_WIDTH-1:0] tdata;

  modport Master (output tvalid, input  tready, output tdata);
  modport Slave  (input  tvalid, output tready, input  tdata);
endinterface
