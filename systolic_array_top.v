module systolic_array_top #( parameter WIDTH = 8 )
(
  input signed [WIDTH-1:0] w1, w2, w3,
  input signed [WIDTH-1:0] x1, x2, x3,
  input clk1, clk2, clk3,
  output wire signed [2*WIDTH-1:0] y,
  input signed [2*WIDTH-1:0] yin
  );

  wire signed [2*WIDTH-1:0] net_1, net_2;

  systolic_slice slice1 (.x (x1), .w (w1), .clk (clk1), .y (net_1), .yin (yin));

  systolic_slice slice2 (.x (x2), .w (w2), .clk (clk2), .y (net_2), .yin (net_1)); //This should take previous y output from slice1 and pass it as input to slice 2

  systolic_slice slice3 (.x (x3), .w (w3), .clk (clk3), .y (y), .yin (net_2)); //This should take previous y output from slice2 and pass it as input to slice 3

endmodule
