//This module will describe the instruction fetch stage of the cpu pipeline
module IF #(parameter SIZE = 32)(
  input clk, //Clock will be used to send the next instruction to the ID stage on rising edge
  input [SIZE-1:0][SIZE-1:0] instructionMemory, //Our instruction memory is a 32 by 32 block (Will be described as SRAM in later developments)
  input [SIZE-1:0] PC, //Program Counter used to point to the next instruction in instruction memory
  output reg [SIZE+SIZE-1:0] IF_ID //Holds the data that will be sent on to the ID stage
  );

  // The least significant SIZE bits will store the instruction IF_ID[ SIZE-1 : 0 ]

  // The PC will be stored in the last SIZE bits IF_ID[ SIZE + SIZE - 1 : SIZE ]

  always @(posedge clk)// From simulation the incrementation from the program counter is happening in the middle of the clock cycle...
  begin                   // I would expect that the PC would update at the same time as the instruction.
    IF_ID[SIZE-1:0] <= instructionMemory[PC]; //Instruction from given PC
    IF_ID[SIZE+SIZE-1:SIZE] <= PC + 1; //Next instruction address
  end

endmodule
