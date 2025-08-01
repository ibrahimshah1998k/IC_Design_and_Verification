class APB_seq_item extends uvm_sequence_item;

  rand bit         PWRITE   [4];
  rand bit  [31:0] PADDR    [4];
  rand bit  [31:0] PWDATA   [4];
       bit  [31:0] PRDATA   [4];
  rand bit   [3:0] PSTRB    [4];
       bit         PREADY   [4];
  rand bit         PENABLE  [4];
  rand bit         PSEL     [4][4];
       bit         PGRANT   [4];

       bit         PWRITE_S [4];
       bit  [31:0] PADDR_S  [4];
       bit  [31:0] PWDATA_S [4];
  rand bit  [31:0] PRDATA_S [4];
       bit   [3:0] PSTRB_S  [4];
  rand bit         PREADY_S [4];
       bit         PENABLE_S[4];
       bit         PSEL_S   [4];

  `uvm_object_utils(APB_seq_item)

  function new(string name = "APB_seq_item");
    super.new(name);
  endfunction

  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);

    foreach (PWRITE[i])    printer.print_field($sformatf("PWRITE[%0d]", i),    PWRITE[i],    1);
    foreach (PADDR[i])     printer.print_field($sformatf("PADDR[%0d]", i),     PADDR[i],    32);
    foreach (PWDATA[i])    printer.print_field($sformatf("PWDATA[%0d]", i),    PWDATA[i],   32);
    foreach (PRDATA[i])    printer.print_field($sformatf("PRDATA[%0d]", i),    PRDATA[i],   32);
    foreach (PSTRB[i])     printer.print_field($sformatf("PSTRB[%0d]", i),     PSTRB[i],     4);
    foreach (PREADY[i])    printer.print_field($sformatf("PREADY[%0d]", i),    PREADY[i],    1);
    foreach (PENABLE[i])   printer.print_field($sformatf("PENABLE[%0d]", i),   PENABLE[i],   1);
    foreach (PGRANT[i])    printer.print_field($sformatf("PGRANT[%0d]", i),    PGRANT[i],    1);
    foreach (PSEL[i,j])    printer.print_field($sformatf("PSEL[%0d][%0d]", i,j), PSEL[i][j], 1);

    foreach (PWRITE_S[i])  printer.print_field($sformatf("PWRITE_S[%0d]", i),  PWRITE_S[i], 1);
    foreach (PADDR_S[i])   printer.print_field($sformatf("PADDR_S[%0d]", i),   PADDR_S[i], 32);
    foreach (PWDATA_S[i])  printer.print_field($sformatf("PWDATA_S[%0d]", i),  PWDATA_S[i], 32);
    foreach (PRDATA_S[i])  printer.print_field($sformatf("PRDATA_S[%0d]", i),  PRDATA_S[i], 32);
    foreach (PSTRB_S[i])   printer.print_field($sformatf("PSTRB_S[%0d]", i),   PSTRB_S[i],  4);
    foreach (PREADY_S[i])  printer.print_field($sformatf("PREADY_S[%0d]", i),  PREADY_S[i], 1);
    foreach (PENABLE_S[i]) printer.print_field($sformatf("PENABLE_S[%0d]", i), PENABLE_S[i],1);
    foreach (PSEL_S[i])    printer.print_field($sformatf("PSEL_S[%0d]", i),    PSEL_S[i],   1);
  endfunction

  virtual function void do_pack(uvm_packer packer);
    super.do_pack(packer);

    foreach (PWRITE[i])     packer.pack_field_int(PWRITE[i],     1);
    foreach (PADDR[i])      packer.pack_field_int(PADDR[i],     32);
    foreach (PWDATA[i])     packer.pack_field_int(PWDATA[i],    32);
    foreach (PRDATA[i])     packer.pack_field_int(PRDATA[i],    32);
    foreach (PSTRB[i])      packer.pack_field_int(PSTRB[i],      4);
    foreach (PREADY[i])     packer.pack_field_int(PREADY[i],     1);
    foreach (PENABLE[i])    packer.pack_field_int(PENABLE[i],    1);
    foreach (PGRANT[i])     packer.pack_field_int(PGRANT[i],     1);
    foreach (PSEL[i,j])     packer.pack_field_int(PSEL[i][j],    1);

    foreach (PWRITE_S[i])   packer.pack_field_int(PWRITE_S[i],   1);
    foreach (PADDR_S[i])    packer.pack_field_int(PADDR_S[i],   32);
    foreach (PWDATA_S[i])   packer.pack_field_int(PWDATA_S[i],  32);
    foreach (PRDATA_S[i])   packer.pack_field_int(PRDATA_S[i],  32);
    foreach (PSTRB_S[i])    packer.pack_field_int(PSTRB_S[i],    4);
    foreach (PREADY_S[i])   packer.pack_field_int(PREADY_S[i],   1);
    foreach (PENABLE_S[i])  packer.pack_field_int(PENABLE_S[i],  1);
    foreach (PSEL_S[i])     packer.pack_field_int(PSEL_S[i],     1);
  endfunction

  virtual function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);

    foreach (PWRITE[i])     PWRITE[i]     = packer.unpack_field_int(1);
    foreach (PADDR[i])      PADDR[i]      = packer.unpack_field_int(32);
    foreach (PWDATA[i])     PWDATA[i]     = packer.unpack_field_int(32);
    foreach (PRDATA[i])     PRDATA[i]     = packer.unpack_field_int(32);
    foreach (PSTRB[i])      PSTRB[i]      = packer.unpack_field_int(4);
    foreach (PREADY[i])     PREADY[i]     = packer.unpack_field_int(1);
    foreach (PENABLE[i])    PENABLE[i]    = packer.unpack_field_int(1);
    foreach (PGRANT[i])     PGRANT[i]     = packer.unpack_field_int(1);
    foreach (PSEL[i,j])     PSEL[i][j]    = packer.unpack_field_int(1);

    foreach (PWRITE_S[i])   PWRITE_S[i]   = packer.unpack_field_int(1);
    foreach (PADDR_S[i])    PADDR_S[i]    = packer.unpack_field_int(32);
    foreach (PWDATA_S[i])   PWDATA_S[i]   = packer.unpack_field_int(32);
    foreach (PRDATA_S[i])   PRDATA_S[i]   = packer.unpack_field_int(32);
    foreach (PSTRB_S[i])    PSTRB_S[i]    = packer.unpack_field_int(4);
    foreach (PREADY_S[i])   PREADY_S[i]   = packer.unpack_field_int(1);
    foreach (PENABLE_S[i])  PENABLE_S[i]  = packer.unpack_field_int(1);
    foreach (PSEL_S[i])     PSEL_S[i]     = packer.unpack_field_int(1);
  endfunction

endclass
