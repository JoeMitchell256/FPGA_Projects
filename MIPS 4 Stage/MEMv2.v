module MEMv2 #(parameter SIZE = 32) (
  input clk,
  input [SIZE-1:0] ALUresult,  //Result from ALU for R/I-Type instructions
  input [$clog2(SIZE)-1:0] writeReg_EX, //Write register for write back
  input [SIZE-1:0] PC_4_EX, //Program Counter from the execute stage  [This is a net for PC, this is why I needed to use another wire]
  input [10:0] control_EX,

  output reg [SIZE-1:0] ALUresult_MEM, //Only for load and store type instructions... Data to be written back to register file
  output reg [$clog2(SIZE)-1:0] writeReg_MEM,
  output reg [10:0] control_MEM,
  output [SIZE-1:0] testMem
  );

  reg [SIZE-1:0] dataMemory [SIZE-1:0]; //Define the data memory


  integer i;

  initial
  begin
    for(i=0; i<SIZE; i++)
    begin
      dataMemory[i] = i; //Load each data value into the dataMemory
    end
  end

  always @(posedge clk)
  begin

    if(control_EX[5:3] == 3'b000) //Instruction is lw or sw
    begin
      ALUresult_MEM[SIZE-1:0] <= dataMemory[ALUresult[4:0]]; //The only bits that matter for the data addressing are the 5 least significant bits!
      writeReg_MEM[$clog2(SIZE) - 1 : 0] <= writeReg_EX[$clog2(SIZE)-1:0];
    end

    control_MEM[10:0] <= control_EX[10:0]; //No matter what operation its in, update control memory

  end
  assign testMem = dataMemory[5'b00100]; //Take a look at data memory address 4 , when I load 4 I should see 4 in test register!
endmodule
