module ID_tb #(parameter SIZE = 32) ();
  reg clk;
  reg [SIZE+SIZE-1:0] IF_ID;
  reg [SIZE-1:0] [SIZE-1:0] registerFile;
  wire [$clog2(SIZE)+SIZE+10+SIZE+SIZE+SIZE-1:0] ID_EX;


  ID dut (clk,IF_ID,registerFile,ID_EX);

  integer i;

  initial begin
    $dumpfile("ID_tb.vcd");  // waveforms file
    $dumpvars;  // save waveforms
    $display("%d %m: Starting testbench simulation...", $stime);

    IF_ID = 64'b00000000000000000000000000000100_000000_00100_00110_01000_00000_010000; //Add the contents of register 4 to register 6 and write the result to register 8

    for(i=0; i<SIZE; i++)
    begin
      registerFile[i] = i; //Each register will hold integer value equal to its register name!
    end

    clk = 0; #1
    clk = 1; #1 //Rising edge to the clock!
    clk = 0; #1
    clk = 1; #1 //Rising edge to the clock!
    clk = 0; #1
    clk = 1; #1 //Rising edge to the clock!
    clk = 0; #1
    clk = 1; #1 //Rising edge to the clock!


    $display("%d %m: Testbench simulation PASSED.", $stime);
    $finish;  // end simulation
  end

endmodule
