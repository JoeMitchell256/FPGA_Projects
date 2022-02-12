//This module will successfully decode each Instruction
module EX #(parameter SIZE = 32)(
  input clk,
  input [$clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE - 1 : 0 ] ID_EX, //Possibly design our own ALU?
  output reg [ $clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE - 1 : 0 ] EX_MEM
  );

  // The EX/MEM register
  // (0) writeReg                                     log2(SIZE) bits
  // (1) Branch offset of PC                          SIZE bits
  // (2) ALU Result used for Memory Addressing        SIZE bits
  // (3) Memory Write data                            SIZE bits
  // (4) Control                                      10 bits
  // (5) PC                                           SIZE bits
  //    Jump, Branch, MemRead, MemToReg, ALUop, MemWrite, ALUsrc

  //https://projectf.io/posts/initialize-memory-in-verilog/
  // When we need memory we can use the above website ^^^

  reg [9:0] control; //This register will hold the control values based on the opcode of the instruction
                      //As in IF_ID the instruction is from [SIZE-1:0] and opcode [31:26] or [SIZE-1:SIZE-5]
  reg [SIZE-1:0] readData1; //First register to be read from register file
  reg [SIZE-1:0] readData2; //Second register to be read from register file

  reg [SIZE-1:0] aluResult;


  //Control was defined in the previous stage as ID_EX[ 9 : 0 ]
  //    So, ID_EX[4:3] is the ALUop


  //Refer to page 269
  always @(posedge clk)
  begin

    if(ID_EX[4:3] == 2'b10)
    begin

      //Control bits              9                                   -->                 0
      EX_MEM[9:0] <= ID_EX[9:0];


      //ALU result                SIZE SIZE SIZE 10                   -->                 SIZE SIZE 10
      EX_MEM[10 + SIZE + SIZE + SIZE - 1 : 10 + SIZE + SIZE ]    <=   ID_EX[10 + SIZE + SIZE + SIZE-1 : 10 + SIZE + SIZE]    +    ID_EX[10 + SIZE + SIZE-1 : 10 + SIZE];


      //PC                        SIZE SIZE SIZE SIZE 10              -->                 SIZE SIZE SIZE 10
      EX_MEM[10 + SIZE + SIZE + SIZE + SIZE - 1 : 10 + SIZE + SIZE + SIZE]   <=   ID_EX[10 + SIZE + SIZE + SIZE + SIZE - 1 : 10 + SIZE + SIZE + SIZE];


      //WriteReg                  log2(SIZE) SIZE SIZE SIZE SIZE 10   -->                 SIZE SIZE SIZE SIZE 10
      EX_MEM[$clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE-1 : SIZE + 10 + SIZE + SIZE + SIZE]   <=    ID_EX[$clog2(SIZE) + SIZE + 10 + SIZE + SIZE + SIZE + SIZE - 1 : 10 + SIZE + SIZE + SIZE];

    end

  end
endmodule
