//This module will successfully decode each Instruction
module ID #(parameter SIZE = 32)(
  input clk, //On rising edge of the clock send data to EX stage
  input [SIZE+SIZE-1:0] IF_ID, //The current data that the ID stage has available
  input [SIZE-1:0][SIZE-1:0] registerFile, //Register file should has SIZE available registers, register 0 is the write register...
  output reg [SIZE + 10 + SIZE + SIZE + SIZE-1 : 0 ] ID_EX // ID_EX holds the data to send to the EX stage
  );


  reg [SIZE-1:0] readData1, readData2, imm;
  reg [9:0] control; //Will be labelled from top to bottom from the jump data path
                //RegDst, Jump, Branch, MemRead, MemtoReg, ALUop[ 1 : 0 ], MemWrite, ALUSrc, RegWrite

  // For R-Type instructions the book mentions an easy way to differentiate them from other instruction types

  // The R-Type instruction is divided as follows:
  //  opcode : [31:26]  rs: [25:21]  rt: [20:16]  rd: [15:11] shamt: [10:6] funct: [5:0]

  // Now in order to deduce R-Type instructions all we need to do is send op5 and op2 through a nor gate  [page 269]
  // So if the output of the nor gate is 1, the instruction is R-Type and should be decoded as such...

  // To extract the opcode we know that the first SIZE bits of our IF_ID register must be the instruction fetched from memory
  //  So, that would mean that the bits would be descibed exactly like above:
  //  IF_ID[31:26]     Now extract bits Op5 and Op2     Op5 = IF_ID[31]  Op2 = IF_ID[28]

  //You don't need to use a nor gate, you can use simple if statement logic...




  always @(posedge clk)
  begin
    if(IF_ID[31] + IF_ID[28] != 1)
    begin
      control <= 10'b1_0_0_0_0_10_0_0_1;

      readData1 <= registerFile[IF_ID[25:21]]; //Read the register at 5 bit index 25:21
      readData2 <= IF_ID[20:16]; //Read the register at 5 bit index 20:16

      //Carry the PC
      ID_EX[SIZE + 10 + SIZE + SIZE + SIZE-1 : 10 + SIZE + SIZE + SIZE] <= IF_ID[SIZE+SIZE-1:SIZE];
      //Read Data 1
      ID_EX[10 + SIZE + SIZE + SIZE-1 : 10 + SIZE + SIZE] <= readData1;
      //Read Data 2
      ID_EX[10 + SIZE + SIZE-1 : 10 + SIZE] <= readData2;
      //When the time comes to implement this, Immediate field will go right here... [10 + SIZE - 1 : 10]

      //Control
      ID_EX[9:0] = control;

      //For now I wont define the immediate field, this is fine, it just means that those bits will just appear don't care in simulation
    end
  end
endmodule
