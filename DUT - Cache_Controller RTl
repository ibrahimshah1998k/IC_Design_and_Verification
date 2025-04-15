module cache_controller(
  input read_c, write_c, 
  input clk, rst,
  input cache_flush,
  input [31:0] data_mp_to_c,
  input [15:0] address,
  input [31:0] data_mem_to_c,
  input ready,
  
  output logic [31:0] data_c_to_mp,
  output logic [31:0] data_c_to_mem,
  output logic wr
);
  
  logic update, refill;
  logic [3:0]data_array_index, line;
  
  tag_array uut1(
    .read_c(read_c), .write_c(write_c), .clk(clk), .rst(rst), 
    .cache_flush(cache_flush), .address(address), .wr(wr), 
    .update(update), .refill(refill), 
    .data_array_index(data_array_index), .line(line)
  );

  data_array uut2(
    .read_c(read_c), .write_c(write_c), .ready(ready), .clk(clk), .rst(rst), 
    .update(update), .refill(refill), .data_array_index(data_array_index), 
    .line(line), .cache_flush(cache_flush), 
    .data_mp_to_c(data_mp_to_c), .data_mem_to_c(data_mem_to_c),
    .data_c_to_mp(data_c_to_mp), .data_c_to_mem(data_c_to_mem)
  );
endmodule


module tag_array(
  input read_c, write_c, clk, rst, cache_flush,
  input [15:0] address,
  output logic wr,
  output logic update, refill,
  output logic [3:0] data_array_index, line
);
  
  logic [15:0]tag[7:0];
  //logic valid_b[7:0];  future work
  //logic dirty_b[7:0];
  logic cache_hit, comp, tag_we;
  //update: update the mp or mem from cache
                        //refill : refill the cache from mp or mem
typedef enum logic [2:0] {
    start, tag_comp, send_data_to_mp, 
    update_cache_from_mem, update_cache_and_mem_from_mp, 
    update_mem_from_mp
  } state_t;
  
  state_t curr_state, next_state;
  
  
  always_ff @(posedge clk or posedge rst)
    begin
      if(rst) 
        curr_state <= start;
      else
        curr_state <= next_state;
    end
  
  always_comb
    begin
      next_state = curr_state;   //default statement
      case(curr_state)
      start:   begin 
        cache_hit = 0; tag_we = 0; //line = 0;
        update = 0; refill = 0;
        data_array_index = 0; wr = 0;
        if(read_c || write_c)
          next_state = tag_comp;
//         else if (cache_flush) 
//           next_state = cache_flush
          end
        
        
      tag_comp: begin
        for(int i=0; i<8; i=i+1)
          begin
            $display("in for loop");
            comp = (tag[i] == address); // TODO: include valid bit over here when needed
            $display("comp = %b", comp);
            if (comp) begin
              $display("if in for loop");
              cache_hit = 1;
              data_array_index = i; end
          end
        if (cache_hit && read_c)
          next_state = send_data_to_mp;  //2
        else if (cache_hit && write_c)
          next_state = update_cache_and_mem_from_mp;  //4
        else if (!cache_hit && read_c)
          next_state = update_cache_from_mem;  //3
        else if (!cache_hit && write_c)
          next_state = update_mem_from_mp; //5
      end
        
        
     send_data_to_mp: begin
       update = 1;
       refill = 0;
       tag_we = 0;
       next_state = start;
     end
        
     update_cache_and_mem_from_mp: begin
       refill = 1;
       update = 1; 
       wr = 1;
       next_state = start;
     end   
        
     update_cache_from_mem: begin
       refill = 1;
       update = 0; 
       tag_we = 1;
       data_array_index = line;
       //line = 4'd0;  // Simplified: always refill index 0
       next_state = send_data_to_mp;
     end
        
     update_mem_from_mp: begin
       refill = 0;
       update = 1; 
       wr = 1;
       next_state = start;    
     end
      endcase
    end //always_comb ended here
      
  always_ff @(posedge clk or posedge rst)  //used to store tag in array
    begin
      if (rst) begin
      line <= 0;
      for (int i = 0; i < 8; i++)
        tag[i] <= 16'h0;
    end
      else if (tag_we) begin
        tag[line] <= address;
        line <= line + 1; end
      else if (!cache_hit && write_c)
        $display ("Doesnot need to store tag"); 
    end
  
//   always_comb  // LRU policy to to find out the least recent location
//     begin
//     end
 endmodule


module data_array(
  input read_c, write_c,ready,
  input clk, rst,
  input update, refill,
  input [3:0]data_array_index, line,
  input cache_flush,
  input [31:0]data_mp_to_c,
  input [31:0]data_mem_to_c,
  output logic [31:0]data_c_to_mp,
  output logic [31:0]data_c_to_mem
);
  
  logic [31:0] cache_data [7:0];
  
  always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          for (int i = 0; i < 8; i++)
           cache_data[i] <= 32'h0;
           data_c_to_mp <= 0;
           data_c_to_mem <= 0;
          end else
    begin    //TODO: replace update and refill with cache_hit
      
      if (read_c && update && !refill)
        data_c_to_mp <= cache_data[data_array_index];
      else if ( read_c && !update && refill)
        cache_data[line] <= data_mem_to_c;  // apply FIFO policy
      else if (write_c && update && refill) begin
        cache_data[data_array_index] <= data_mp_to_c;
        if(ready)
        //data_c_to_mem <= cache_data[data_array_index]; end
          data_c_to_mem <= data_mp_to_c; end
      else if (write_c && update && !refill) begin
        $display ("Data Transfer from Micro-Processor to memory directly");
      data_c_to_mem <= data_mp_to_c; end
    end
  end
endmodule
