module _4bit #( parameter WIDTH = 4 , parameter IF = 2'b00, parameter ID = 2'b01, parameter EX = 2'b10, parameter WB = 2'b11 ) //Define the width of our pipeline
(
  input clk, //Clock that drives the finite state machine
  input [WIDTH-1:0] next, //Next instruction in the instruction memory
  output reg [WIDTH-1:0] ir, //Instruction register, gets loaded during the instruction fetch stage
  output reg id, //Instruction decode bit
  output reg [WIDTH-1:0] iex //Instruction execute register
  );

  //Data Memory initialization:

  reg [3:0] dm [1:0]; // 2 entry data memory register each 4 bits

  initial
  begin
    dm[0] <= 4'b1010; // A or decimal 10
    dm[1] <= 4'b0101; // 5
    ir <= 4'b0000;
    id <= 0;
    iex <= 4'b0000;
  end


  //In order to get this pipeline to work, we need to design a finite state machine

  //We have three different states. Instruction Fetch state, Instruction Decode state, and Instruction Execute state
  //So for three states we need 2 bits

  reg [1:0] state_reg;//State register and next state

  initial begin
    state_reg <= IF;
  end

  //Finite state machine used to control the cpu pipeline
  always @(posedge clk) begin
    if( state_reg == IF) begin //If the state register is the instruction fetch stage
      ir <= next; //Load the next instruction from the instruction memory
      state_reg <= ID; //Next state is the Instruction Decode state
    end
    if( state_reg == ID) begin
      id <= ir[3]; //0 (add) or 1 (subtract)
      state_reg <= EX;
    end
    if( state_reg == EX) begin
      if( id == 0) begin
        iex <= dm[ir[1]] + dm[ir[0]]; // Take the contents of source register 1 and add it to source register 0
      end
      if( id == 1) begin
        iex <= dm[ir[1]] - dm[ir[0]]; // Take the contents of source register 0 and subtract it to source register 1
      end
      state_reg <= WB;
    end
    if( state_reg == WB) begin
      dm[ir[2]] = iex;
      state_reg <= IF;
    end
  end

endmodule
