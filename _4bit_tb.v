module _4bit_tb #( parameter WIDTH = 4 ) ();
  reg clk;
  reg [WIDTH-1:0] next;
  wire [WIDTH-1:0] ir;
  wire id;
  wire [WIDTH-1:0] iex;

  //Initialize the wires
  /*
  assign ir = 4'b0100;
  assign id = 1'b1;
  assign iex = 4'b1010;
  */

  _4bit dut (.clk(clk), .ir(ir), .id(id), .iex(iex), .next(next));


  initial begin
    $dumpfile("_4bit_tb.vcd");  // waveforms file
    $dumpvars;  // save waveforms
    $display("%d %m: Starting testbench simulation...", $stime);
    $monitor("%d %m: MONITOR - ir = %d, id = %d, iex = %d.", $stime, ir, id, iex);
    next[3:0] = 4'b0000;//The first instruction must be a NOP!
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    next[3:0] = 4'b1110;
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    next[3:0] = 4'b1100;
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    next[3:0] = 4'b1010;
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    next[3:0] = 4'b0110;
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    next[3:0] = 4'b0010;
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    next[3:0] = 4'b0000;
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    clk = 0; #5
    clk = 1; #5 //Rising edge every 10 ns
    $display("%d %m: Testbench simulation PASSED.", $stime);
    $finish;  // end simulation
  end


endmodule
