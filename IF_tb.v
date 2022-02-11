module IF_tb #(parameter SIZE = 32) ();
  reg clk;
  reg [SIZE-1:0][SIZE-1:0] instructionMemory;
  reg [SIZE-1:0] PC;
  wire [SIZE-1:0] IF_ID;

  IF dut (clk,instructionMemory,PC,IF_ID);

  initial begin
    $dumpfile("IF_tb.vcd");  // waveforms file
    $dumpvars;  // save waveforms
    $display("%d %m: Starting testbench simulation...", $stime);
    instructionMemory = 0;
    instructionMemory[0] = 32'b000000_00100_01000_10000_00000_010000;
    instructionMemory[1] = 32'b000000_00110_01100_10001_00000_010000;
    instructionMemory[2] = 32'b000000_00101_01001_10100_00000_010000;
    instructionMemory[3] = 32'b000000_10100_11000_11000_00000_010000;
    instructionMemory[4] = 32'b000000_00101_01010_10010_00000_010000;
    PC = 0;
    clk = 0; #1
    clk = 1; #1 //Rising edge to the clock! The output should be as expected in binary form...
    PC = 1;
    clk = 0; #1
    clk = 1; #1
    PC = 2;
    clk = 0; #1
    clk = 1; #1
    PC = 3;
    clk = 0; #1
    clk = 1; #1
    PC = 4;
    clk = 0; #1
    clk = 1; #1
    $display("%d %m: Testbench simulation PASSED.", $stime);
    $finish;  // end simulation
  end

endmodule
