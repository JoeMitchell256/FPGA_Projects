//This module is meant to implement a systolic array slice at first
//  then meant to instantiate this slice multiple times to design the full array
module systolic_slice #( parameter WIDTH = 8 )//Data WIDTH
(
  input signed [WIDTH-1:0] x, w,
  input clk,
  output reg signed [2*WIDTH-1:0] y,
  input signed [2*WIDTH-1:0] yin
  );

  wire signed [2*WIDTH-1:0] wx;
  assign wx = w*x; //Multiply two registers??? Signed multiplication!

  always @(posedge clk) //D-Flip-Flops activate!
  begin
    y <= wx + yin; //The weight is multiplied by the input, and summed with the yin and passed to y
  end

endmodule
