module IF #(parameter SIZE = 32) (
  input clk, //Clock that drives the pipeline
  input [$clog2(SIZE)-1:0] rs,
  input [$clog2(SIZE)-1:0] rt,
  input [10:0] control,
  input [10:0] controlEX,
  input [$clog2(SIZE)-1:0] writeRegEX,
  input [SIZE-1:0] ALUresult,
  input [SIZE-1:0] PC4EX,

  output reg [SIZE-1:0] Instruction, //Output the Instruction
  output reg [SIZE-1:0] PC4 //The incremented Program Counter
  );

  reg [SIZE-1:0] PC; //Try having the program counter inside of the module...

  reg [SIZE-1:0] instructionMemory [0:59]; //Instruction memory should be read from mipsMachinecode.txt file

  initial
  begin
      $readmemb("/Users/jm/Desktop/mipsMachinecode.txt", instructionMemory); //For some reason its skipping the first instruction...?
      PC[SIZE-1:0] = 32'b0;
  end

  always @(posedge clk) //At rising edge of clock and only when raw is low
  begin
    case(controlEX[6] && !control[6] && !control[8] && (writeRegEX[$clog2(SIZE)-1:0] == rs[$clog2(SIZE)-1:0] || writeRegEX[$clog2(SIZE)-1:0] == rt[$clog2(SIZE)-1:0])) //As far as instruction level verification we are only interested in the first 60 instructions!
      1'b1: ; //Do nothing
      1'b0: begin
              case (controlEX[9] && (ALUresult[SIZE-1:0] != PC4EX[SIZE-1:0]) )
                1'b1: begin
                        PC[SIZE-1:0] <= ALUresult[SIZE-1:0];
                        PC4[SIZE-1:0] <= PC[SIZE-1:0] + 3'b100;
                        $display("I made it here! %h, %h",PC[SIZE-1:0], PC4EX[SIZE-1:0]);
                      end
                1'b0: begin
                        case(PC[7:2] < 6'b111100)
                          1'b1: begin
                                  Instruction[SIZE-1:0] <= instructionMemory[PC[7:2]]; //Fetch the next instruction from instruction memory
                                  PC[SIZE-1:0] <= PC[SIZE-1:0] + 3'b100; //Increment the program counter by 4
                                  PC4[SIZE-1:0] <= PC[SIZE-1:0] + 3'b100; //Incremented program counter for control hazards
                                end
                          1'b0: ;
                        endcase
                      end
              endcase
            end
    endcase
  end

endmodule
