//This module will successfully decode each Instruction
module WB #(parameter SIZE = 32)(
  input clk,
  input [$clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE - 1 : 0 ] MEM_WB, //Possibly design our own ALU?
  input [SIZE-1:0][SIZE-1:0] registerFile
  );

  //Write Register

  reg [$clog2(SIZE)-1:0] writeReg = MEM_WB[$clog2(SIZE) + 10 + SIZE - 1 : 10 + SIZE];

  reg [ SIZE - 1 : 0 ] writeRegister = [MEM_WB[$clog2(SIZE) + 10 + SIZE - 1 : 10 + SIZE]] registerFile; //This should be fine...

  //Refer to page 269
  always @(posedge clk)
  begin
    if(MEM_WB[0] == 1)
    begin
      //Write ALU result into write register
      assign [writeReg][SIZE - 1 : 0]registerFile = MEM_WB[10 + SIZE - 1 : 10];
    end
  end
endmodule
