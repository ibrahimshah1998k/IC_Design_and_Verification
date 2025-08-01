// Code your design here
module AHB_APB_Bridge(
  input HCLK, HRSTn,
  
  //AHB slave intereface
  input logic [31:0] HADDR_S,
  input logic        HWRITE_S,
  input logic [2:0]  HSIZE_S,
  input logic [31:0] HWDATA_S,
  input logic        HTRANS_S,
  output logic [31:0]HRDATA_S,
  output logic       HREADY_S,
  output logic       HRESP_S,
  
  //APB master interface
  output logic [31:0]PADDR,
  output logic       PWRITE,
  output logic [31:0]PWDATA,
  output logic [3:0] PSTRB,
  output logic       PENABLE,
  output logic       PSEL[3:0], //4 select lines for Bridge (which is acting as master) for 4 slaves.
  input logic [31:0] PRDATA,
  input logic        PREADY,
  input logic        PGRANT
);
  
  typedef enum logic [2:0] {gen_sel,wait_for_grant, start_trans, send_data, end_trans} state;
  state current_state, next_state;
  
  always_ff @(posedge HCLK or negedge HRSTn)
    begin
      if(!HRSTn)
        begin
          current_state <= gen_sel;
          //reset all outputs to default
        end
      else
        current_state <= next_state;
      end // always_ff ended here
  
  always_comb
    begin
      next_state=current_state;
      case(current_state)
        start_trans:
          begin
            if(PREADY)   //it should high for atleast 1 clock cycles
              begin
                HREADY_S=1;
                PADDR=HADDR_S;
                PWRITE=HWRITE_S;
                PWDATA=HWDATA_S;
                case (HSIZE_S)
                  3'b000: PSTRB = 4'b0001; // Byte
                  3'b001: PSTRB = 4'b0011; // Halfword (16-bit)
                  3'b010: PSTRB = 4'b1111; // Word (32-bit)
                  default: PSTRB = 4'b0000; // Undefined or unsupported size
                endcase
                next_state=send_data;
              end
          end
        send_data:
          begin
            PENABLE=1;
            if(HWRITE_S)
              PWDATA=HWDATA_S;
            else
              HRDATA_S=PRDATA;
            next_state=end_trans;
          end
        end_trans:
          begin
            HREADY_S=0;
            PENABLE=0;
            PSEL[0]=0; PSEL[1]=0; PSEL[2]=0; PSEL[3]=0;
            if (!PREADY)
              HRESP_S = 1; // Error if slave didn’t respond
            else
              HRESP_S = 0; //could be later used for error reporting if PREADY remains low too long.
            next_state=gen_sel;
          end
        wait_for_grant:
          begin
            if(PGRANT)
              next_state=start_trans;
          end
        gen_sel:
          begin
            HRDATA_S = 0;
            HREADY_S = 0;
            HRESP_S= 0;
            PWDATA = 0;
            PADDR = 0;
            PSTRB = 0;
            PENABLE= 0;
            case(HADDR_S[31:30])
                0:PSEL[0]=1;
                1:PSEL[1]=1;
                2:PSEL[2]=1;
                3:PSEL[3]=1;
            endcase
              next_state = wait_for_grant;
          end
        default: 
          begin
            HREADY_S = 0;
            PENABLE = 0;
            PSEL[0] = 0; PSEL[1] = 0; PSEL[2] = 0; PSEL[3] = 0;
          end
      endcase 
    end//always_comb ended here
endmodule //module ended here
        //please add logic for HRESP_S
  
