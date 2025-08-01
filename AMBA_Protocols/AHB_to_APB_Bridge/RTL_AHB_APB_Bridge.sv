module APB (
  //System clock and rest signals
  input logic PCLK, PRSTn,
  
  //master interface signals (4 masters)
  input  logic        PWRITE   [0:3],
  input  logic [31:0] PADDR    [0:3],
  input  logic [31:0] PWDATA   [0:3],
  output logic [31:0] PRDATA   [0:3],
  input  logic [3:0]  PSTRB    [0:3],
  output logic        PREADY   [0:3],
  input  logic        PENABLE  [0:3],
  input  logic        PSEL[0:3][0:3],  //each master has 4 PSEL lines , one for each slave.

  output logic        PGRANT   [0:3], //this signal is not part of standard APB protocol, it is added just for arbitration.

  //slave interface signals (4 slaves)
  output logic        PWRITE_S [0:3],
  output logic [31:0] PADDR_S  [0:3],
  output logic [31:0] PWDATA_S [0:3],
  input  logic [31:0] PRDATA_S [0:3],
  output logic [3:0]  PSTRB_S  [0:3],
  input  logic        PREADY_S [0:3],
  output logic        PENABLE_S[0:3],
  output logic        PSEL_S   [0:3]   //each slave has only one PSEL_S line
);
  
  logic [1:0]k,j,l;
  logic [31:0] wdata, rdata;  //Delete this line, just for testing
  typedef enum logic [2:0] {idle_p, arbitration_p, setup_p, access_p} state;
  state current_state, next_state;
  
  always_ff @(posedge PCLK or negedge PRSTn)
    begin
      if(!PRSTn)
        begin
          current_state <= idle_p;
          //reset all outputs to default
          
        end
      else
        current_state <= next_state;
    end // always_ff ended here
  
  
  
  always_comb
    begin
      next_state=current_state;
      case(current_state)
        idle_p:
          begin
            for (int i = 0; i < 4; i++) begin
            PGRANT[i]   = 0;
            PREADY[i]   = 0;
            PRDATA[i]   = 0;
            PADDR_S[i]  = 0;
            PWRITE_S[i] = 0;
            PWDATA_S[i] = 0;
            PSTRB_S[i]  = 0;
            PENABLE_S[i]= 0;
            PSEL_S   [i]= 0;
            end
            j=0; k=0; l=0;
            for (int a=0; a<4; a++) begin
                for (int b=0; b<4; b++) begin
                  if (PSEL[a][b]) begin // if any one PSEL line assrted by master.
                     next_state=arbitration_p; end end end
          end
        
        arbitration_p:
          begin
            //I have implemented proirity logic for simplicity, Round robbin could also be implemented
            if(PSEL[0][0]||PSEL[0][1]||PSEL[0][2]||PSEL[0][3]) // any PSEL line in master 1
              begin
                PGRANT[0]=1;
                PGRANT[1]=0;
                PGRANT[2]=0;
                PGRANT[3]=0;
                k=0;
                if(PSEL[0][0]) l=0; else if (PSEL[0][1]) l=1; else if (PSEL[0][2]) l=2; else if (PSEL[0][3]) l=3;
              end
            
            else if(PSEL[1][0]||PSEL[1][1]||PSEL[1][2]||PSEL[1][3]) // any PSEL line in master 2
              begin
                PGRANT[0]=0;
                PGRANT[1]=1;
                PGRANT[2]=0;
                PGRANT[3]=0;
                k=1;
                if(PSEL[1][0]) l=0; else if (PSEL[1][1]) l=1; else if (PSEL[1][2]) l=2; else if (PSEL[1][3]) l=3;
              end
            
            else if(PSEL[2][0]||PSEL[2][1]||PSEL[2][2]||PSEL[2][3]) // any PSEL line in master 3
              begin
                PGRANT[0]=0;
                PGRANT[1]=0;
                PGRANT[2]=1;
                PGRANT[3]=0;
                k=2;
                if(PSEL[2][0]) l=0; else if (PSEL[2][1]) l=1; else if (PSEL[2][2]) l=2; else if (PSEL[2][3]) l=3;
              end
            
            else if(PSEL[3][0]||PSEL[3][1]||PSEL[3][2]||PSEL[3][3]) // any PSEL line in master 4
              begin
                PGRANT[0]=0;
                PGRANT[1]=0;
                PGRANT[2]=0;
                PGRANT[3]=1;
                k=3;
                if(PSEL[3][0]) l=0; else if (PSEL[3][1]) l=1; else if (PSEL[3][2]) l=2; else if (PSEL[3][3]) l=3;
              end
            j = PADDR[k][31:30];
            next_state = setup_p;
          end //arbitration_p ended here
        
        setup_p:
          begin
            if(PREADY_S[j]) begin
            PSEL_S[j] = 1;             //this should be 1 from master side.
            PSTRB_S[j]=PSTRB[k];
            PADDR_S[j]=PADDR[k];
            PWRITE_S[j]=PWRITE[k];
            PREADY[k]=PREADY_S[j];
            PENABLE_S[j] = 0;
              
            if (PENABLE[k])
              next_state = access_p;
            
            end 
          end //setup_p ended here
        
        access_p:
          begin
              PENABLE_S[j]=1;      //this should be 1 from master side
              
            if(PWRITE[k])
              begin
                PWDATA_S[j]=PWDATA[k];
                wdata=PWDATA[k];    //Delete this line, just for testing
              end//write_transection ended here
            else
              begin
                PRDATA[k]=PRDATA_S[j];
                rdata=PRDATA_S[j];     //Delete this line, just for testing
              end//read transection ended here
            next_state=idle_p;
          end //access_p ended here
      endcase
    end //always_comb ended here
endmodule           // Code your design here
