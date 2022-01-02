`timescale 1ps/1ps
module systolic_array_top_tb #( parameter WIDTH = 8 ) ();
  reg signed [WIDTH-1:0] w1, w2, w3;
  reg signed [WIDTH-1:0] x1, x2, x3;
  reg clk1, clk2, clk3;
  output wire signed [2*WIDTH-1:0] y;
  reg signed [2*WIDTH-1:0] yin;

  systolic_array_top dut (.w1 (w1), .w2 (w2), .w3 (w3), .x1 (x1), .x2 (x2), .x3 (x3), .clk1 (clk1), .clk2 (clk2), .clk3 (clk3), .yin (yin), .y (y));

  initial begin
    $dumpfile("systolic_array_top_tb.vcd");  // waveforms file
    $dumpvars;  // save waveforms
    $display("%d %m: Starting testbench simulation...", $stime);
    $monitor("%d %m: MONITOR - w1 = %d, w2 = %d, w3 = %d, x1 = %d, x2 = %d, x3 = %d, y = %d", $stime, w1, w2, w3, x1, x2, x3, y);
    //This all needs to be pipelined! So each clock needs to be toggled at the right time and order
    x1 = 8'b0010_1100; //x_11
    x2 = 8'b0001_1100; //x_12
    x3 = 8'b0001_1101; //x_13

    w1 = 8'b0001_0001; //w_1
    w2 = 8'b0000_1000; //w_2
    w3 = 8'b0000_0010; //w_3

    yin = 16'b0000_0000_0000_0000; //yin
    clk1 = 0; #1
    clk1 = 1; #1 //On rising edge, the flip-flops pass inputs to outputs!
    x1 = 8'b0000_1110; //x_21
    clk2 = 0; #1
    clk2 = 1; #1
    clk1 = 0; #1 //Raise clock 1 after you raise clock 2
    clk1 = 1; #1 //On rising edge, the flip-flops pass inputs to outputs!
    x2 = 8'b0001_0000; //x_22
    clk3 = 0; #1
    clk3 = 1; #1
    clk2 = 0; #1
    clk2 = 1; #1 //Raise clock 2 after you raise clock 3
    x3 = 8'b0001_0101; //x_23
    clk3 = 0; #1
    clk3 = 1; #1 //Finally raise clock 3 again!
    $display("%d %m: Testbench simulation PASSED.", $stime);
    $finish;  // end simulation
  end


endmodule
