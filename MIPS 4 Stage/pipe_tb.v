module pipe_tb #(parameter SIZE = 32) ();
  reg clk;

  wire stall;

  wire [SIZE-1:0] Instruction;
  wire [SIZE-1:0] PC_4;

  wire [SIZE-1:0] readData1; //Read Data 1
  wire [SIZE-1:0] readData2; //Read Data 2
  wire [$clog2(SIZE) - 1 : 0] shamt;
  wire [SIZE-1:0] testReg;

  wire [10:0] control; //Control bits
  wire [10:0] control_EX; //Control bits sent out of EX stage
  wire [10:0] control_MEM;
  //wire [9:0] control_WB;

  wire [SIZE-1:0] PC_4_ID;
  wire [SIZE-1:0] PC_4_EX;

  wire [SIZE-1:0] ALUresult;
  wire [SIZE-1:0] ALUresult_MEM;
  wire [3:0] ALUcontrol;
  //wire [SIZE-1:0] ALUresult_WB;

  wire [$clog2(SIZE)-1 : 0] writeReg;
  wire [$clog2(SIZE)-1 : 0] writeReg_EX;
  wire [$clog2(SIZE)-1 : 0] writeReg_MEM;
  //wire [$clog2(SIZE)-1 : 0] writeReg_WB;

  wire written;
  wire writtenRst;

  wire [SIZE-1:0] testMem;

  pipe dut (
    clk,


    Instruction,
    PC_4,

    readData1,
    readData2,
    shamt,
    testReg,

    control,
    control_EX,
    control_MEM,
    //control_WB,

    PC_4_ID,
    PC_4_EX,

    ALUresult,
    ALUresult_MEM,
    ALUcontrol,
    //ALUresult_WB,

    writeReg,
    writeReg_EX,
    writeReg_MEM,


    stall,
    written,
    writtenRst,

    testMem
    );

  integer i;

  initial begin
    $dumpfile("pipe_tb.vcd");  // waveforms file
    $dumpvars;  // save waveforms
    $display("%d %m: Starting testbench simulation...", $stime);

    //This first clock is like a dummy clock edge...
    //  Since we can't at the same time increment the clock and read the instruction
    //  We need to have the PC start at -4 instead of 0...
    clk = 0; #1
    clk = 1; #1 //Stage 1

    clk = 0; #1
    clk = 1; #1 //Stage 2

    clk = 0; #1
    clk = 1; #1 //Stage 3

    clk = 0; #1
    clk = 1; #1 //Stage 4

    clk = 0; #1
    clk = 1; #1 //Stage 5

    clk = 0; #1
    clk = 1; #1 //Stage 6

    clk = 0; #1
    clk = 1; #1 //Stage 1

    clk = 0; #1
    clk = 1; #1 //Stage 2

    clk = 0; #1
    clk = 1; #1 //Stage 3

    clk = 0; #1
    clk = 1; #1 //Stage 4

    clk = 0; #1
    clk = 1; #1 //Stage 5

    clk = 0; #1
    clk = 1; #1 //Stage 6

    clk = 0; #1
    clk = 1; #1 //Stage 1

    clk = 0; #1
    clk = 1; #1 //Stage 2

    clk = 0; #1
    clk = 1; #1 //Stage 3

    clk = 0; #1
    clk = 1; #1 //Stage 4

    clk = 0; #1
    clk = 1; #1 //Stage 5

    clk = 0; #1
    clk = 1; #1 //Stage 6

    clk = 0; #1
    clk = 1; #1 //Stage 1

    clk = 0; #1
    clk = 1; #1 //Stage 2

    clk = 0; #1
    clk = 1; #1 //Stage 3

    clk = 0; #1
    clk = 1; #1 //Stage 4

    clk = 0; #1
    clk = 1; #1 //Stage 5

    clk = 0; #1
    clk = 1; #1 //Stage 6

    $display("%d %m: Testbench simulation PASSED.", $stime);
    $finish;  // end simulation
  end

endmodule
