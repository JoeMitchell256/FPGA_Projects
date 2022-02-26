module EXv2 #(parameter SIZE = 32) (
  input clk, //Clock that drives the processor...
  input [SIZE-1:0] readData1, //Read Data 1
  input [SIZE-1:0] readData2, //Read Data 2
  input [$clog2(SIZE) - 1 : 0] shamt,
  input [$clog2(SIZE)-1:0] writeReg, //Write register
  input [10:0] control, //Control from ID stage
  input [SIZE-1:0] PC_4_ID, //Program Counter + 4
  input [3:0] ALUcontrol,


  output reg [SIZE-1:0] ALUresult, //ALUresult from add register
  output reg [$clog2(SIZE)-1:0] writeReg_EX, //Write Reg carried from EX stage
  output reg [SIZE-1:0] PC_4_EX, //PC + 4 from EX stage
  output reg [10:0] control_EX //This may have been the problem... keep all sizes consistent???
  );

  always @(posedge clk) //Nothing notable changes when you change this to negedge...
  begin
    if(control[5:3] == 3'b100 || control[5:3] == 3'b000) //R-Type instruction
    begin
      control_EX[10:0] <= control [10:0];
      PC_4_EX[SIZE-1:0] <= PC_4_ID [SIZE-1:0];
      writeReg_EX[$clog2(SIZE)-1:0] <= writeReg[$clog2(SIZE)-1:0];

      case (ALUcontrol[3:0])
        4'b0010: ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] + readData2 [SIZE-1:0];
        4'b0000: ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] & readData2 [SIZE-1:0];
        4'b1000: ALUresult[SIZE-1:0] <= ~(readData1 [SIZE-1:0] | readData2 [SIZE-1:0]);
        4'b0001: ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] | readData2 [SIZE-1:0]);
        4'b0111: ALUresult[SIZE-1:0] <= (readData2 [SIZE-1:0] < readData1 [SIZE-1:0]) ? 1 : 0 ;
        4'b1001: ALUresult[SIZE-1:0] <= (readData2 [SIZE-1:0] << shamt[$clog2(SIZE) - 1 : 0]);
        4'b1010: ALUresult[SIZE-1:0] <= (readData2 [SIZE-1:0] >>> shamt[$clog2(SIZE) - 1 : 0]);
        4'b0110: ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] - readData2 [SIZE-1:0]);
        default: ; //Do Nothing
      endcase

    end
  end
endmodule
