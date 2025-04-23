/**
  An 8-bit add-shift multiplier
*/
//`include "mul_interface.sv"

module add_shift_multiplier
(
  input   logic         clk,              // Clock driving the sequential logic
  input   logic         rst_n,            // Active low asynchronous reset

  axi_stream_if.Slave   axis_operands,    // AXI Stream interface coming from the operand producer device
                                          //    Signals:
                                          //      I : tvalid - master asserts multiplication should start
                                          //      O : tready - multiplier asserts it is ready to begin multiplication
                                          //      I : tdata  - the 8-bit multiplier and multiplicand packed into a 16-bit line
                                          //            tdata[ 7: 0] -> multiplier
                                          //            tdata[15: 8] -> multiplicand

  axi_stream_if.Master  axis_result       // AXI Stream interface outputing result to the consumer device
                                          //    Signals:
                                          //      O : tvalid - multiplier asserts that multiplication is complete and tdata is valid.
                                          //      I : tready - slave asserts that it is ready to accept the result.
                                          //          YOU MAY ASSUME THAT axis_result.tready IS ALWAYS '1
                                          //          (The slave is always ready to accept the multiplication result)
                                          //      O : tdata  - the 16-bit multiplication output
);

  /*************************** Type Definitions *********************************/
  typedef enum logic[1:0] {
    IDLE,
    ADD,
    SHIFT,
    OUTPUT
  } operation_e;

  typedef struct packed {
    logic         ready;                  // asserted when the multiplier is ready to start a multiplication
    logic         done;                   // asserted when the multiplier is done with a multiplication
    logic [ 3: 0] iteration;              // track the iteration of add-shift opperations
    operation_e   current_operation;      // current operation of the multiplier
    logic         carry;                  // carry bit
    logic [ 7: 0] multiplicand;           // the first operand of the multiplication
    logic [ 7: 0] multiplier;             // the second operand of the multiplication. bottom 8 bits of product when multiplication is complete
    logic [ 7: 0] product;                // top 8 bits of the product.
    logic         slave_ready;            // asserted when the slave of the multiplier is ready
  } multiplier_state_t;

  /*****************************************************************************/

  /*************************** Local Variables *********************************/
  multiplier_state_t  state;              // the current state of the multiplier
  multiplier_state_t  next_state;         // the next state of the multiplier

  assign axis_operands.tready   = state.ready;
  assign axis_result.tvalid     = state.done;
  assign axis_result.tdata      = {{state.product}, {state.multiplier}};
  /*****************************************************************************/

  /*************************** State Machine ***********************************/
  always_ff @(posedge clk, negedge rst_n) begin : next_state_assignment
    if(~rst_n) begin
      state   <= '0;
    end else begin
      state   <= next_state;
    end
  end : next_state_assignment

  always_comb begin : next_state_logic
    next_state        = state;
    case (state.current_operation)
      IDLE: begin
        next_state        = 0;
        next_state.ready  = 1;
        if(axis_operands.tvalid && state.ready) begin
          next_state.current_operation  = ADD;
          next_state.multiplicand       = axis_operands.tdata[15:8];
          next_state.multiplier         = axis_operands.tdata[7:0];
          next_state.iteration = 0;              //Edited
          next_state.ready              = 0;
        end 
      end
      ADD: begin
        next_state.current_operation = SHIFT;
        if (state.multiplier[0]) begin
          {next_state.carry, next_state.product}  = 9'(state.product + state.multiplicand);
        end else begin
          next_state.carry  = '0;
        end
      end
      SHIFT: begin
        next_state.current_operation                  = ADD;
        {next_state.product, next_state.multiplier}   = {state.carry, state.product, state.multiplier[7:1]};
        next_state.iteration                          += 1;
        
        // if the multiplier is on its eighth iteration, it is done
        if (next_state.iteration == 8) begin    //Edited
          next_state.current_operation  = OUTPUT;
          next_state.done               = '1;
          next_state.ready              = '1;
        end
      end
      OUTPUT: begin
        if(axis_result.tready) begin
           next_state.done = '0;      //Edited

          next_state        = '0;
          next_state.ready  = '1;
        end
      end
      default: next_state = state;
    endcase
  end : next_state_logic
  /*****************************************************************************/

endmodule : add_shift_multiplier
