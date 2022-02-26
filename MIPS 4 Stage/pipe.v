//This module will repesent a practice pipeline arena
module pipe #(parameter SIZE = 32) (
  input clk, //Clock that drives the processor

  output [SIZE-1:0] Instruction,
  output [SIZE-1:0] PC_4,

  output [SIZE-1:0] readData1, //Read Data 1
  output [SIZE-1:0] readData2, //Read Data 2
  output [$clog2(SIZE) - 1 : 0] shamt,
  output [SIZE-1:0] regTest, //Testing Register from register file


  output [10:0] control, //Control bits
  output [10:0] control_EX, //Control bits sent out of EX stage
  output [10:0] control_MEM, //Control MEM stage
  //output [9:0] control_WB, //Control WB stage

  output [SIZE-1:0] PC_4_ID,
  output [SIZE-1:0] PC_4_EX,

  output [SIZE-1:0] ALUresult,
  output [SIZE-1:0] ALUresult_MEM,
  output [3:0] ALUcontrol,
  //output [SIZE-1:0] ALUresult_WB,

  output [$clog2(SIZE)-1:0] writeReg,
  output [$clog2(SIZE)-1:0] writeReg_EX,
  output [$clog2(SIZE)-1:0] writeReg_MEM,
  output stall, //High when there is a stall, low there is no stall (R-Type)
  output written, //Signal to notify that the data has been written...
  output writtenRst, //Signal to toggle the stall signal (So that it can actually synthesize!)
  output [SIZE-1:0] testMem
  //output freeze_raw //Signal for raw hazards
  //output [$clog2(SIZE)-1:0] writeReg_WB
  );

  reg raw;//Register used to monitor raw hazards...

  wire stall;

  wire [SIZE-1:0] PC_4; //Program Counter + 4
  wire [SIZE-1:0] PC_4_ID; //Program Counter out of the ID stage...
  wire [SIZE-1:0] PC_4_EX; //Program Counter + 4 for EX stage
  wire [SIZE-1:0] Instruction; //Instruction from memory
  wire [SIZE-1:0] readData1; //Read Data 1
  wire [SIZE-1:0] readData2; //Read Data 2
  wire [SIZE-1:0] regTest;
  wire [10:0] control; //Control bits
  wire [10:0] control_EX;
  wire [10:0] control_MEM;
  wire [SIZE-1:0] ALUresult;
  wire [SIZE-1:0] ALUresult_MEM;
  wire [$clog2(SIZE)-1:0] writeReg;
  wire [$clog2(SIZE)-1:0] writeReg_EX;
  wire [$clog2(SIZE)-1:0] writeReg_MEM;
  wire [3:0] ALUcontrol;
  wire  written;
  wire  writtenRst; //Used to reset the the stall signal
  wire  [SIZE-1:0] testMem;
  //wire stall;


  //How about we try stalling individual stages of the pipeline???
  //  The only stages to my mind that would need to be stalled would be IF ID and EX


  IFv2 fetch (
    clk,
    writeReg, //Check the previous writeReg before stalling th pipeline!
    writtenRst, //Written Reset needs to go here, because writtenRst was the carried out signal due to synthesis violation!
    PC_4,
    Instruction,
    stall
    );//Problem with the PC...

  //R-Type instructions need to be decoded as such:
  //  If the opcode is 0 , then the instruction is considered R-Type
  //  Now that it is R-Type now we need to determine the ALUcontrol operation
  //   We would have already determined the control bits (10 of these bits)

  // How do we know if we have an R-Type instruction is in the pipeline? Well, the opcode of course!
  //    If the opcode [4:3] == 2'b10

  IDv2 decode (
    clk,
    stall,
    Instruction,
    PC_4,
    writeReg_EX, //If the previous instruction was writing to something that is going to be read, then stall until it is finished writing!!!
    writeReg_MEM, //For load
    control_EX,
    control_MEM, //For load
    ALUresult,
    ALUresult_MEM,
    ALUcontrol,
    regTest,
    readData1,
    readData2,
    shamt,
    writeReg,
    control,
    PC_4_ID,
    written,
    writtenRst
    );

  //What must be sent to the instruction execute stage?
  // read data 2 and read data 1,

  EXv2 execute (
    clk,
    readData1,
    readData2,
    shamt,
    writeReg,
    control,
    PC_4_ID,
    ALUcontrol,
    ALUresult,
    writeReg_EX,
    PC_4_EX,
    control_EX
    );


  MEMv2 memory (
    clk,
    ALUresult,
    writeReg_EX,
    PC_4_EX,
    control_EX,
    ALUresult_MEM,
    writeReg_MEM,
    control_MEM,
    testMem
    ); //By this point you would have calculated the branch target address...


    assign raw_hazard = raw;
endmodule //
