module ex1(clock,A,Y,S_0,S_1);
  input clock;
  input A;
  output Y,Y;
  //output S_0, S_1;
  reg S0,S1;
  wire X1,NS0,NS1;

  initial begin //Initialize the current state to be 00
    S0 <= 0;
    S1 <= 0;
  end

  and g0(X1,S0,S1);
  and g1(NS1,A,X1);
  not g2(NS0,X1);
  and g3(Y,A,X1);
  always @(posedge clock) begin
    S1<=NS1;
    S0<=NS0;
  end
  assign S_0 = S0;
  assign S_1 = S1;
endmodule
