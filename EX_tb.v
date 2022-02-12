module EX_tb #(parameter SIZE = 32) ();
  reg clk;
  reg [$clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE - 1 : 0 ] ID_EX;
  wire [ $clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE - 1 : 0 ] EX_MEM;


  EX dut (clk,ID_EX,EX_MEM);

  integer i;

  initial begin
    $dumpfile("EX_tb.vcd");  // waveforms file
    $dumpvars;  // save waveforms
    $display("%d %m: Starting testbench simulation...", $stime);

    ID_EX = 142'b10010_00000000000000000000000000000000_00010000000010000010000000010000_00000000000010000000000100000010_00000000000000000000000000000000_1_0_0_0_0_10_0_0_1; //Add the contents of register 4 to register 6 and write the result to register 8


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
