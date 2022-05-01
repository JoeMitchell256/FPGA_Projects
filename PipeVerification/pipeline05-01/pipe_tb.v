module pipe_tb #(parameter SIZE = 32) ();

  reg clk;//Clock that drives the pipeline

  wire dstall; //Data stall signal

  wire [SIZE-1:0] Instruction; //Instruction from the fetch stage
  wire [SIZE-1:0] PC4; //The incremented program counter from the IF stage
  wire [SIZE-1:0] PC4ID; //The incremented program counter from the ID stage
  wire [SIZE-1:0] PC4EX; //The incremented program counter from the EX stage (Used for branch target detection)
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
  wire [SIZE-1:0] storeData; //data to store in memory
  wire [SIZE-1:0] storeDataEX; //Data to store in memory carried from the execute stage
  wire [SIZE-1:0] storeDataEXF;
  wire [SIZE-1:0] storeDataMEM;
  wire [$clog2(SIZE)-1:0] writeReg; //The decoded write register for register write instructions
  wire [SIZE-1:0] writeRegData; //Data that will handle execeptions
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

  pipe dut (
    clk, //Clock that drives the pipeline

    Instruction, //Instruction from the fetch stage
    PC4,
    PC4ID,
    PC4EX,
    PCoffset,

    writeRegEX, //The write register for the execute stage
    writeRegMEM, //The write register for the memory stage
    writeRegMEM2,
    data, //The data fetched from the data memory
    ALUresult, //The ALU result that is produced from the execute stage

    ALUcontrol, //Determine the ALU oepration from the ALU control bits
    readData1, //read data for operand 1
    readData2, //read data for operand 2
    readData1EX,
    readData2EX,
    ALUcontrolEX,
    ALUcontrolMEM,
    storeData, //data to store in memory
    storeDataEX,
    storeDataMEM,
    writeReg, //The decoded write register for register write instructions
    control, //Control bits for the decoded instruction

    rs, //Source register from ID stage
    rt, //Target register from ID stage
    rsEX, //Source register from EX stage
    rtEX, //Target register from EX stage
    rsMEM, //Source register from MEM stage
    rtMEM, //Target register from MEM stage
    testMEM,


    controlEX, //The control bits for the execute stage
    controlMEM, //Control bits at the memory stage
    controlMEM2,

    testReg //Used for testing CPI
    );

    integer i;

    initial begin
      $dumpfile("pipe_tb.vcd");  // waveforms file
      $dumpvars;  // save waveforms
      $display("%d %m: Starting testbench simulation...", $stime);



      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1
      clk = 0; #1
      clk = 1; #1


      $display("%d %m: Testbench simulation PASSED.", $stime);
      $finish;  // end simulation
    end
endmodule
