module pipe #(parameter SIZE = 32)(
  input clk, //Clock that drives the pipeline

  output [SIZE-1:0] Instruction, //Instruction from the fetch stage
  output [SIZE-1:0] PC4,
  output [SIZE-1:0] PC4ID,
  output [SIZE-1:0] PC4EX,
  output [SIZE-1:0] PCoffset,

  output [$clog2(SIZE)-1:0] writeRegEX, //The write register for the execute stage
  output [$clog2(SIZE)-1:0] writeRegMEM, //The write register for the memory stage
  output [$clog2(SIZE)-1:0] writeRegMEM2,
  output [SIZE-1:0] data, //The data fetched from the data memory
  output [SIZE-1:0] ALUresult, //The ALU result that is produced from the execute stage

  output [3:0] ALUcontrol, //Determine the ALU oepration from the ALU control bits
  output [SIZE-1:0] readData1, //read data for operand 1
  output [SIZE-1:0] readData2, //read data for operand 2
  output [SIZE-1:0] readData1EX, //read data for operand 1
  output [SIZE-1:0] readData2EX, //read data for operand 2
  output [3:0] ALUcontrolEX,
  output [3:0] ALUcontrolMEM,
  output [SIZE-1:0] storeData, //The data to store in memory
  output [SIZE-1:0] storeDataEX, //Data to store from the execute stage
  output [SIZE-1:0] storeDataMEM,
  output [$clog2(SIZE)-1:0] writeReg, //The decoded write register for register write instructions
  output [10:0] control, //Control bits for the decoded instruction

  output [$clog2(SIZE)-1:0] rs, //Source register from ID stage
  output [$clog2(SIZE)-1:0] rt, //Target register from ID stage
  output [$clog2(SIZE)-1:0] rsEX, //Source register from EX stage
  output [$clog2(SIZE)-1:0] rtEX, //Target register from EX stage
  output [$clog2(SIZE)-1:0] rsMEM, //Source register from MEM stage
  output [$clog2(SIZE)-1:0] rtMEM, //Target register from MEM stage
  output [SIZE-1:0] testMEM,


  output [10:0] controlEX, //The control bits for the execute stage
  output [10:0] controlMEM, //Control bits at the memory stage
  output [10:0] controlMEM2,

  output [SIZE-1:0] testReg

  );


  //wire dstall; //Data stall signal

  wire [SIZE-1:0] Instruction; //Instruction from the fetch stage
  wire [SIZE-1:0] PC4;
  wire [SIZE-1:0] PC4ID;
  wire [SIZE-1:0] PC4EX;
  wire [SIZE-1:0] PCoffset;

  wire [$clog2(SIZE)-1:0] writeRegEX; //The write register for the execute stage
  wire [$clog2(SIZE)-1:0] writeRegMEM; //The write register for the memory stage
  wire [$clog2(SIZE)-1:0] writeRegMEM2;
  wire [SIZE-1:0] data; //The data fetched from the data memory
  wire [SIZE-1:0] ALUresult; //The ALU result that is produced from the execute stage

  wire [3:0] ALUcontrol; //Determine the ALU oepration from the ALU control bits
  wire [SIZE-1:0] readData1; //read data for operand 1
  wire [SIZE-1:0] readData2; //read data for operand 2
  wire [SIZE-1:0] forward1;
  wire [SIZE-1:0] forward2;
  wire [SIZE-1:0] readData1EX;
  wire [SIZE-1:0] readData2EX;
  wire [3:0] ALUcontrolEX;
  wire [3:0] ALUcontrolMEM;
  wire [SIZE-1:0] storeData; //Data to store in memory
  wire [SIZE-1:0] storeDataEX; //Data to store in memory from the execute stage
  wire [SIZE-1:0] storeDataEXF;
  wire [$clog2(SIZE)-1:0] writeReg; //The decoded write register for register write instructions
  wire [SIZE-1:0] writeRegData; //Data for exception handling
  wire [10:0] control; //Control bits for the decoded instruction
  wire written; //The flag to signal that the data has been written back to register for dstall


  wire [$clog2(SIZE)-1:0] rs; //Source register from ID stage
  wire [$clog2(SIZE)-1:0] rt; //Target register from ID stage
  wire [$clog2(SIZE)-1:0] rsEX; //Source register from EX stage
  wire [$clog2(SIZE)-1:0] rtEX; //Target register from EX stage
  wire [$clog2(SIZE)-1:0] rsMEM; //Source register from MEM stage
  wire [$clog2(SIZE)-1:0] rtMEM; //Target register from MEM stage
  wire [SIZE-1:0] testMEM;


  wire [10:0] controlEX; //The control bits for the execute stage
  wire [10:0] controlMEM; //Control bits at the memory stage
  wire [10:0] controlMEM2;

  wire [SIZE-1:0] testReg;

  IF fetch (
    clk,
    rs,
    rt,
    control,
    controlEX,
    writeRegEX,
    ALUresult,
    PC4EX,

    Instruction,
    PC4
    );

  ID decode (
    clk, //clock driving processor
    Instruction, // Takes the instruction as input
    PC4,
    PC4EX,

    writeRegEX, //All we need is write register of EX to determine when to stall for RAW
    writeRegMEM, //For load instructions
    data, //The ALUresult for load is only known at the end of the memory stage
    ALUresult, //The ALUresult for R-Type instructions\
    readData1EX,
    readData2EX,
    ALUcontrolEX,

    controlEX, //Enable signal for writing from EX stage
    controlMEM, //Enable signal for writing from MEM stage


    PCoffset,
    ALUcontrol, //Determine what operation the ALU will take
    readData1, //read data 1
    readData2, // read data 2
    storeData, //Data to store into memory
    writeReg, //Write Register   How about making this don't care until the register has been written...
    control, // Control bits based on op code

    rs,//Source register from ID stage
    rt,//Target register from ID stage
    rsEX,
    rtEX,
    PC4ID,

    testReg
    );

  EX execute (
    clk, //Clock that drives the pipeline
    control, //Control bits for the decoded instruction
    controlMEM, //For load data forwarding
    writeReg, //The write register for the decoded instruction
    writeRegMEM, //write register from the memory stage
    readData1, //Read data from operand 1 of instruction
    readData2, //Read data from operand 2 of instruction
    storeData, //Data to store into memory
    ALUcontrol, //ALU control bits to determine the ALU operationzs
    data, //Data to write back for load type instructions
    rs,//Source register from ID stage
    rt,//Target register from ID stage
    PC4ID,
    PCoffset,

    writeRegMEM2,
    controlMEM2,
    readData1EX,
    readData2EX,
    ALUcontrolEX,
    storeDataEX, //Data to store into memory coming out of the execute stage
    ALUresult, //The ALU result from the ALU operation stage
    writeRegEX, //The write register for the decoded instruction sent through the execute stage
    controlEX, //The control bits for the previously decoded instruction
    rsEX,//Source register from EX stage
    rtEX, //Target register from EX stage
    PC4EX
    );

  MEM memory (
    clk, //Clock that drives the pipeline
    ALUresult, //The ALUresult from the EX stage
    storeDataEX, //Data to store into memory
    writeReg,
    writeRegEX, //The write register from the EX stage
    control,
    controlEX, //The control for the instruction that passed through the EX stage
    rsEX,//Source register from EX stage
    rtEX,//Target register from EX stage
    ALUcontrolEX,
    writeRegMEM2,
    controlMEM2,


    data, //The data that was fetched from the data memory
    writeRegMEM, //The write register for the current instruction
    controlMEM, //The control of the current instruction
    rsMEM, //Source register from MEM stage
    rtMEM, //Target register from MEM stage
    testMEM
    );

endmodule
