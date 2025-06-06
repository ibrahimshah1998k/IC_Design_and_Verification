class ahb_seq_item extends uvm_sequence_item;

  //master interface signals (4 masters)
 rand bit        HBUSREQ  [0:3];
 rand bit        HWRITE   [0:3];
 rand bit        HGRANT   [0:3];
 rand bit [2:0]  HSIZE    [0:3];
 rand bit        HLOCK    [0:3];
 rand bit [31:0] HADDR    [0:3];
 rand bit [2:0]  HBURST   [0:3];
 rand bit [31:0] HWDATA   [0:3];
 rand bit [2:0]  HPROT    [0:3];
 rand bit [31:0] HRDATA   [0:3];
 rand bit [2:0]  HTRANS   [0:3];
 rand bit        HREADY   [0:3];
 rand bit        HRESP    [0:3];

  //slave interface signals (4 slaves)
 rand bit [31:0] HADDR_S  [0:3];
 rand bit        HWRITE_S [0:3];
 rand bit [2:0]  HSIZE_S  [0:3];
 rand bit [31:0] HWDATA_S [0:3];
 rand bit [31:0] HRDATA_S [0:3];
 rand bit        HREADY_S [0:3];
 rand bit        HRESP_S  [0:3];
 rand bit [2:0]  HBURST_S [0:3];
 rand bit [2:0]  HPROT_S  [0:3];
 rand bit [2:0]  HTRANS_S [0:3];

  `uvm_object_utils_begin(ahb_seq_item)
    // No field macros for arrays here
  `uvm_object_utils_end

  function new(string name = "ahb_seq_item");
    super.new(name);
  endfunction

  // Print
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    foreach (HBUSREQ[i])   printer.print_field($sformatf("HBUSREQ[%0d]", i),   HBUSREQ[i],   1);
    foreach (HWRITE[i])    printer.print_field($sformatf("HWRITE[%0d]", i),    HWRITE[i],    1);
    foreach (HGRANT[i])    printer.print_field($sformatf("HGRANT[%0d]", i),    HGRANT[i],    1);
    foreach (HSIZE[i])     printer.print_field($sformatf("HSIZE[%0d]", i),     HSIZE[i],     3);
    foreach (HLOCK[i])     printer.print_field($sformatf("HLOCK[%0d]", i),     HLOCK[i],     1);
    foreach (HADDR[i])     printer.print_field($sformatf("HADDR[%0d]", i),     HADDR[i],     32);
    foreach (HBURST[i])    printer.print_field($sformatf("HBURST[%0d]", i),    HBURST[i],    3);
    foreach (HWDATA[i])    printer.print_field($sformatf("HWDATA[%0d]", i),    HWDATA[i],    32);
    foreach (HPROT[i])     printer.print_field($sformatf("HPROT[%0d]", i),     HPROT[i],     3);
    foreach (HRDATA[i])    printer.print_field($sformatf("HRDATA[%0d]", i),    HRDATA[i],    32);
    foreach (HTRANS[i])    printer.print_field($sformatf("HTRANS[%0d]", i),    HTRANS[i],    3);
    foreach (HREADY[i])    printer.print_field($sformatf("HREADY[%0d]", i),    HREADY[i],    1);
    foreach (HRESP[i])     printer.print_field($sformatf("HRESP[%0d]", i),     HRESP[i],     1);

    foreach (HADDR_S[i])   printer.print_field($sformatf("HADDR_S[%0d]", i),   HADDR_S[i],   32);
    foreach (HWRITE_S[i])  printer.print_field($sformatf("HWRITE_S[%0d]", i),  HWRITE_S[i],  1);
    foreach (HSIZE_S[i])   printer.print_field($sformatf("HSIZE_S[%0d]", i),   HSIZE_S[i],   3);
    foreach (HWDATA_S[i])  printer.print_field($sformatf("HWDATA_S[%0d]", i),  HWDATA_S[i],  32);
    foreach (HRDATA_S[i])  printer.print_field($sformatf("HRDATA_S[%0d]", i),  HRDATA_S[i],  32);
    foreach (HREADY_S[i])  printer.print_field($sformatf("HREADY_S[%0d]", i),  HREADY_S[i],  1);
    foreach (HRESP_S[i])   printer.print_field($sformatf("HRESP_S[%0d]", i),   HRESP_S[i],   1);
    foreach (HBURST_S[i])  printer.print_field($sformatf("HBURST_S[%0d]", i),  HBURST_S[i],  3);
    foreach (HPROT_S[i])   printer.print_field($sformatf("HPROT_S[%0d]", i),   HPROT_S[i],   3);
    foreach (HTRANS_S[i])  printer.print_field($sformatf("HTRANS_S[%0d]", i),  HTRANS_S[i],  3);
  endfunction

  // Pack
  virtual function void do_pack(uvm_packer packer);
    super.do_pack(packer);
    foreach (HBUSREQ[i])   packer.pack_field_int(HBUSREQ[i], 1);
    foreach (HWRITE[i])    packer.pack_field_int(HWRITE[i], 1);
    foreach (HGRANT[i])    packer.pack_field_int(HGRANT[i], 1);
    foreach (HSIZE[i])     packer.pack_field_int(HSIZE[i], 3);
    foreach (HLOCK[i])     packer.pack_field_int(HLOCK[i], 1);
    foreach (HADDR[i])     packer.pack_field_int(HADDR[i], 32);
    foreach (HBURST[i])    packer.pack_field_int(HBURST[i], 3);
    foreach (HWDATA[i])    packer.pack_field_int(HWDATA[i], 32);
    foreach (HPROT[i])     packer.pack_field_int(HPROT[i], 3);
    foreach (HRDATA[i])    packer.pack_field_int(HRDATA[i], 32);
    foreach (HTRANS[i])    packer.pack_field_int(HTRANS[i], 3);
    foreach (HREADY[i])    packer.pack_field_int(HREADY[i], 1);
    foreach (HRESP[i])     packer.pack_field_int(HRESP[i], 1);

    foreach (HADDR_S[i])   packer.pack_field_int(HADDR_S[i], 32);
    foreach (HWRITE_S[i])  packer.pack_field_int(HWRITE_S[i], 1);
    foreach (HSIZE_S[i])   packer.pack_field_int(HSIZE_S[i], 3);
    foreach (HWDATA_S[i])  packer.pack_field_int(HWDATA_S[i], 32);
    foreach (HRDATA_S[i])  packer.pack_field_int(HRDATA_S[i], 32);
    foreach (HREADY_S[i])  packer.pack_field_int(HREADY_S[i], 1);
    foreach (HRESP_S[i])   packer.pack_field_int(HRESP_S[i], 1);
    foreach (HBURST_S[i])  packer.pack_field_int(HBURST_S[i], 3);
    foreach (HPROT_S[i])   packer.pack_field_int(HPROT_S[i], 3);
    foreach (HTRANS_S[i])  packer.pack_field_int(HTRANS_S[i], 3);
  endfunction

  // Unpack
  virtual function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);
    foreach (HBUSREQ[i])   HBUSREQ[i]   = packer.unpack_field_int(1);
    foreach (HWRITE[i])    HWRITE[i]    = packer.unpack_field_int(1);
    foreach (HGRANT[i])    HGRANT[i]    = packer.unpack_field_int(1);
    foreach (HSIZE[i])     HSIZE[i]     = packer.unpack_field_int(3);
    foreach (HLOCK[i])     HLOCK[i]     = packer.unpack_field_int(1);
    foreach (HADDR[i])     HADDR[i]     = packer.unpack_field_int(32);
    foreach (HBURST[i])    HBURST[i]    = packer.unpack_field_int(3);
    foreach (HWDATA[i])    HWDATA[i]    = packer.unpack_field_int(32);
    foreach (HPROT[i])     HPROT[i]     = packer.unpack_field_int(3);
    foreach (HRDATA[i])    HRDATA[i]    = packer.unpack_field_int(32);
    foreach (HTRANS[i])    HTRANS[i]    = packer.unpack_field_int(3);
    foreach (HREADY[i])    HREADY[i]    = packer.unpack_field_int(1);
    foreach (HRESP[i])     HRESP[i]     = packer.unpack_field_int(1);

    foreach (HADDR_S[i])   HADDR_S[i]   = packer.unpack_field_int(32);
    foreach (HWRITE_S[i])  HWRITE_S[i]  = packer.unpack_field_int(1);
    foreach (HSIZE_S[i])   HSIZE_S[i]   = packer.unpack_field_int(3);
    foreach (HWDATA_S[i])  HWDATA_S[i]  = packer.unpack_field_int(32);
    foreach (HRDATA_S[i])  HRDATA_S[i]  = packer.unpack_field_int(32);
    foreach (HREADY_S[i])  HREADY_S[i]  = packer.unpack_field_int(1);
    foreach (HRESP_S[i])   HRESP_S[i]   = packer.unpack_field_int(1);
    foreach (HBURST_S[i])  HBURST_S[i]  = packer.unpack_field_int(3);
    foreach (HPROT_S[i])   HPROT_S[i]   = packer.unpack_field_int(3);
    foreach (HTRANS_S[i])  HTRANS_S[i]  = packer.unpack_field_int(3);
  endfunction

endclass
