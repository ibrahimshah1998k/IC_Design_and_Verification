// Code your design here
module AHB (
  //System clock and rest signals
  input logic HCLK, HRSTn,
  
  //master interface signals (4 masters)
  input  logic        HBUSREQ  [0:3],
  input  logic        HWRITE   [0:3],
  output logic        HGRANT   [0:3],
  input  logic [2:0]  HSIZE    [0:3],
  input  logic        HLOCK    [0:3],
  input  logic [31:0] HADDR    [0:3],
  input  logic [2:0]  HBURST   [0:3],
  input  logic [31:0] HWDATA   [0:3],
  input  logic [2:0]  HPROT    [0:3],
  output logic [31:0] HRDATA   [0:3],
  input  logic [2:0]  HTRANS   [0:3],
  output logic        HREADY   [0:3],
  output logic        HRESP    [0:3],

  //slave interface signals (4 slaves)
  output logic [31:0] HADDR_S  [0:3],
  output logic        HWRITE_S [0:3],
  output logic [2:0]  HSIZE_S  [0:3],
  output logic [31:0] HWDATA_S [0:3],
  input  logic [31:0] HRDATA_S [0:3],
  input  logic        HREADY_S [0:3],
  input  logic        HRESP_S  [0:3],
  output logic [2:0]  HBURST_S [0:3],
  output logic [2:0]  HPROT_S  [0:3],
  output logic [2:0]  HTRANS_S [0:3]
);
  
  logic [1:0]k,j;
  logic [31:0] wdata, rdata;  //Delete this line, just for testing
  typedef enum logic [2:0] {start, arbitration_p, address_p, data_p, response_p} state;
  state current_state, next_state;
  
  always_ff @(posedge HCLK or negedge HRSTn)
    begin
      if(!HRSTn)
        begin
          current_state <= start;
          //reset all outputs to default
          
        end
      else
        current_state <= next_state;
    end // always_ff ended here
  
  
  
  always_comb
    begin
      next_state=current_state;
      case(current_state)
        start:
          begin
            for (int i = 0; i < 4; i++) begin
            HGRANT[i]   = 0;
            HREADY[i]   = 0;
            HRESP[i]    = 0;
            HRDATA[i]   = 0;
            HADDR_S[i]  = 0;
            HWRITE_S[i] = 0;
            HSIZE_S[i]  = 0;
            HWDATA_S[i] = 0;
            HBURST_S[i] = 0;
            HPROT_S[i]  = 0;
            HTRANS_S[i] = 0;
            end
            j=0; k=0;
            if(HBUSREQ[0] || HBUSREQ[1] || HBUSREQ[2] || HBUSREQ[3])
              next_state=arbitration_p;
          end
        
        arbitration_p:
          begin
            //I have implemented proirity logic for simplicity, Round robbin could also be implemented
            if(HBUSREQ[0])
              begin
                HGRANT[0]=1;
                HGRANT[1]=0;
                HGRANT[2]=0;
                HGRANT[3]=0;
                k=0;
              end
            
            else if(HBUSREQ[1])
              begin
                HGRANT[0]=0;
                HGRANT[1]=1;
                HGRANT[2]=0;
                HGRANT[3]=0;
                k=1;
              end
            
            else if(HBUSREQ[2])
              begin
                HGRANT[0]=0;
                HGRANT[1]=0;
                HGRANT[2]=1;
                HGRANT[3]=0;
                k=2;
              end
            
            else if(HBUSREQ[3])
              begin
                HGRANT[0]=0;
                HGRANT[1]=0;
                HGRANT[2]=0;
                HGRANT[3]=1;
                k=3;
              end
            next_state = address_p;
          end //arbitration_p ended here
        
        address_p:
          begin
            j = HADDR[k][31:30];
            HBURST_S[j]=HBURST[k];
            HSIZE_S[j]=HSIZE[k];
            HTRANS_S[j]=HTRANS[k];
            HPROT_S[j]=HPROT[k];
            HADDR_S[j]=HADDR[k];
            HWRITE_S[j]=HWRITE[k];
            HREADY[k]=HREADY_S[j];
            if (HREADY_S[j])
              begin
                next_state=data_p;
                HREADY[k] = 1;
              end
          end //address_p ended here
        
        data_p:
          begin
            if(HWRITE[k])
              begin
                HWDATA_S[j]=HWDATA[k];
                wdata=HWDATA[k];    //Delete this line, just for testing
              end//write_transection ended here
            else
              begin
                HRDATA[k]=HRDATA_S[j];
                rdata=HRDATA_S[j];     //Delete this line, just for testing
              end//read transection ended here
            next_state=response_p;
          end //data_p ended here
        
        response_p:
          begin
            HRESP[k]=HRESP_S[j];
            next_state=start;
          end //response_p ended here
      endcase
    end //always_comb ended here
endmodule           



/*
	input [1:0] HTRANS;		//represents the transfer type. 0 = WAIT state
					//				1 = BUSY state
					//				2 = NONSEQuential transfer type
					//				3 = SEQuential transfer type
                    
                    input [2:0]HSIZE;		//represents the size of data read 000(0) = Byte (8 bit)
					//				   001(1) = halfword (16 bit)
					//				   010(2) = word (32 bit)
					//				   011(3) = double word (64 bit)	
                    */
