module ID #(parameter SIZE = 32)(
  input clk, //clock driving processor
  input [SIZE-1:0] Instruction, // Takes the instruction as input
  input [SIZE-1:0] PC4, //Incremented Program Counter
  input [SIZE-1:0] PC4EX, //The incremented program counter passed through the ID stage

  input [$clog2(SIZE)-1:0] writeRegEX, //All we need is write register of EX to determine when to stall for RAW
  input [$clog2(SIZE)-1:0] writeRegMEM, //For load instructions
  input [SIZE-1:0] data, //The ALUresult for load is only known at the end of the memory stage
  input [SIZE-1:0] ALUresult, //The result from the R-Type instruction
  input [SIZE-1:0] readData1EX,
  input [SIZE-1:0] readData2EX,
  input [3:0] ALUcontrolEX,

  input [10:0] controlEX, //Enable signal for writing to the EX stage
  input [10:0] controlMEM, //Enable signal for writing to the MEM stage

  output reg [SIZE-1:0] PCoffset,
  output reg [3:0] ALUcontrol, //Determine what operation the ALU will take
  output reg [SIZE-1:0] readData1, //read data 1
  output reg [SIZE-1:0] readData2, // read data 2
  output reg [SIZE-1:0] storeData, //Data to store in memory
  output reg [$clog2(SIZE)-1:0] writeReg, //Write Register   How about making this don't care until the register has been written...
  output reg [10:0] control, // Control bits based on op code

  output reg [$clog2(SIZE)-1:0] rs, //This is the propagated source register
  output reg [$clog2(SIZE)-1:0] rt, //This is the propagated target register
  input [$clog2(SIZE)-1:0] rsEX, //Forwarded from the EX stage
  input [$clog2(SIZE)-1:0] rtEX, //Forwarded from the EX stage

  output reg [SIZE-1:0] PC4ID, //The incremented program counter passed through the ID stage

  output [SIZE-1:0] testReg
  );

  //For control hazards I would send a nop through the pipeline from the ID stage and IF stage. Then on the next cycle, it would begin execution on the next
  // instruction following the new program counter value.

  reg [SIZE-1:0] registerFile [0:10]; //This is the register file

  integer counter; //Count the total number of cycles starting at 1
                //Just count until 70 cycles ...

  integer fd;
  integer i = 0;

  initial
  begin
    fd = $fopen("/Users/jm/Desktop/pipeline.txt","w");
    counter = 0; //Just keep the counter at 0, it doesn't matter we are literally counting clocks
    for(i = 0; i < 10; i++)
    begin
      registerFile[i] = i; // Each register file value has its name as the value...
    end
    registerFile[5'b01010] = 32'b0; //Ensure that the zero register is set to zero and does not change!
    control[10:0] = 11'b0;
  end


  always @(posedge clk) //Writing always happens on the positive edge of the clock
  begin

    PC4ID[SIZE-1:0] <= PC4[SIZE-1:0]; //The incremented program counter sent through the ID stage
    counter <= counter + 1; //Increment the cycle counter (For testing/debug purposes)
    if(counter == 80) //Supposedly clock cycle 9 is the executed raw hazard instruction for test example
    begin
      for(i = 0; i < 10; i++)
      begin
        $fwriteh(fd,registerFile[i]); //Write the register values for $t0 - $t9, these will be compared to the 'golden file'
        $fdisplay(fd,""); //Writes a new line, since $fdisplay always adds a new line
      end
      $fclose(fd);//Close the file descriptor or else bad things may happen
    end

    //If the data is ready to write back into the register file then write it back
    case(controlMEM[0] == 1'b1 && controlMEM[6] == 1'b1) //Write register for load type instructions
      1'b1: begin
              registerFile[writeRegMEM] <= data[SIZE-1:0];
            end
      1'b0: ;
    endcase


    //If the data is ready in the execute stage, then write it back to the register file
    case(controlEX[0] == 1'b1 && controlEX[6] == 1'b0) //Write register for reg write alu instructions
      1'b1: begin
              case (readData1EX[SIZE-1] == 1'b1 && readData2EX[SIZE-1] == 1'b1 && ALUresult[SIZE-1] == 1'b0 && ALUcontrolEX[3:0] == 4'b0010) //If it is a signed addition...
                1'b1: $display("ID Addition between %h and %h resulted in %h with register %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0], writeRegEX[$clog2(SIZE)-1:0]); //Do nothing like what spim does
                1'b0: begin
                        case (readData1EX[SIZE-1] == 1'b1 && readData2EX[SIZE-1] == 1'b0 && ALUresult[SIZE-1] == 1'b0 && ALUcontrolEX[3:0] == 4'b0110) //If signed subtraction...
                          1'b1: $display("ID Subtraction between %h and %h resulted in %h with register %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0], writeRegEX[$clog2(SIZE)-1:0]);
                          1'b0: begin
                                  case (readData1EX[SIZE-1] == 1'b0 && readData2EX[SIZE-1] == 1'b1 && ALUresult[SIZE-1] == 1'b1 && ALUcontrolEX[3:0] == 4'b0110)
                                    1'b1: $display("ID Subtraction between %h and %h resulted in %h with register %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0], writeRegEX[$clog2(SIZE)-1:0]);
                                    1'b0: begin
                                            case (readData1EX[SIZE-1] == 1'b0 && readData2EX[SIZE-1] == 1'b0 && ALUresult[SIZE-1] == 1'b1 && ALUcontrolEX[3:0] == 4'b0010)
                                              1'b1: $display("ID Addition between %h and %h resulted in %h with register %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0], writeRegEX[$clog2(SIZE)-1:0]);
                                              1'b0: registerFile[writeRegEX] <= ALUresult[SIZE-1:0];
                                            endcase
                                          end
                                  endcase
                                end
                        endcase
                      end
              endcase
            end
      1'b0: ; // Do nothing when enable signal is low
    endcase

  end

  always @(negedge clk)//Reading always happens on the negative edge of the clock, and only when there is no raw hazard!
  begin
    //     -      -   MemWrite     -   MemToReg     ---     -     -   WriteReg
    // So for SW, !MemToReg , !WriteReg , and !MemWrite need to be toggled

    //The below should stall?
    case(controlEX[6] && !control[6] && !control[8] && (writeRegEX[$clog2(SIZE)-1:0] == rs[$clog2(SIZE)-1:0] || writeRegEX[$clog2(SIZE)-1:0] == rt[$clog2(SIZE)-1:0]) )
      1'b0: begin


              case (Instruction[31:26] > 6'b000011)
                1'b1: begin

                        case(Instruction[31:26])

                          6'b001000: begin //Add Immediate (Unsigned) [Extend a 0 instead of sign bit]
                                       control[10:0] = 11'b1_0_0_0_0_000_0_1_1;
                                       ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                       readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= {  { 16 { 1'b0 } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                       writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                       rt[$clog2(SIZE)-1:0] <= Instruction[20:16];
                                     end
                          //Start of Immediate Instructions
                          6'b001001: begin //Add immediate (Signed)
                                       control[10:0] = 11'b1_0_0_0_0_000_0_1_1;
                                       ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                       readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                       writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                       rt[$clog2(SIZE)-1:0] <= Instruction[20:16];
                                     end
                          6'b001100: begin //And immediate
                                       control[10:0] = 11'b1_0_0_0_0_000_0_1_1;
                                       ALUcontrol[3:0] <= 4'b0000; //ALU control is for AND
                                       readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                       writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                       rt[$clog2(SIZE)-1:0] <= Instruction[20:16];
                                     end
                          6'b000100: begin //Branch on equal
                                       control[10:0] = 11'b0_1_0_0_0_001_0_0_0; //The Branch control bit is set high and the ALUop code is 001 for on equal
                                       ALUcontrol[3:0] <= 4'b0110; //ALU control is for SUB
                                       readData2[SIZE-1:0] <= registerFile[Instruction[20:16]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= registerFile[Instruction[25:21]]; //ReadData1 will act as immediate value!
                                       PCoffset[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ;
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                       rt[$clog2(SIZE)-1:0] <= Instruction[20:16];
                                     end
                          6'b000101: begin //Branch on not equal
                                       control[10:0] = 11'b0_1_0_0_0_010_0_0_0; //The Branch control bit is set high and the ALUop code is 010 for on equal
                                       ALUcontrol[3:0] <= 4'b0110; //ALU control is for SUB
                                       readData2[SIZE-1:0] <= registerFile[Instruction[20:16]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= registerFile[Instruction[25:21]]; //ReadData1 will act as immediate value!
                                       PCoffset[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ;
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                       rt[$clog2(SIZE)-1:0] <= Instruction[20:16];
                                     end
                          6'b100100: begin //Load Byte (unsigned)
                                       control[10:0] = 11'b1_0_0_1_1_000_0_1_1;
                                       ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                       readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                       writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                     end
                          6'b100101: begin //Load Halfword (unsigned)
                                       control[10:0] = 11'b1_0_0_1_1_000_0_1_1;
                                       ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                       readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                       readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                       writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                       rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                     end
                          6'b110000: begin //Load Linked
                                      control[10:0] = 11'b1_0_0_1_1_000_0_1_1; //ALUop is 000 because we know what we want to do!
                                      ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                      readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                      readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                      writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                      rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                     end
                          6'b001111: begin //Load Upper Immediate
                                      control[10:0] = 11'b1_0_0_1_1_000_0_1_1; //ALUop is 000 because we know what we want to do!
                                      ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                      readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                      readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                      writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                      rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                     end
                         6'b100011: begin //Load Word
                                      control[10:0] = 11'b1_0_0_1_1_000_0_1_1; //ALUop is 000 because we know what we want to do!
                                      ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                      readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                      readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                      writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                      rs[$clog2(SIZE)-1:0] <= Instruction[25:21];//Should not set rt whenever we have a load
                                    end
                          6'b001101: begin //Or I

                                     end
                          6'b001010: begin //SLTI

                                     end
                          6'b001011: begin //SLTUI

                                     end
                          6'b101000: begin //store byte

                                     end
                          6'b111000: begin //Store Conditional

                                     end
                          6'b101001: begin //Store Halfword

                                     end
                          6'b101011: begin //Store Word
                                      control[10:0] = 11'b1_0_1_1_0_000_0_1_0; //ALUop is 000 because we know what we want to do!
                                      ALUcontrol[3:0] <= 4'b0010; //ALU control is for Addition
                                      readData2[SIZE-1:0] <= registerFile[Instruction[25:21]]; // ReadData2 and signextended immediate will be added together
                                      readData1[SIZE-1:0] <= {  { 16 { Instruction[15] } }, Instruction[15:0] } ; //ReadData1 will act as immediate value!
                                      writeReg[$clog2(SIZE) - 1 : 0] = Instruction[20:16]; //Rt is the destination register for this instruction
                                      storeData[SIZE-1:0] <= registerFile[Instruction[20:16]]; //Data to be stored in memory
                                      rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                      //rt[$clog2(SIZE)-1:0] <= Instruction[20:16]; //We'll come back to store word later...
                                     end
                          //End of Immediate Instructions

                          default: ; //Do nothing on nop

                        endcase

                      end
                1'b0: begin

                        case(Instruction[31:26] < 6'b000011 && Instruction[31:26] > 6'b000000) //Jump instructions
                          1'b1: ;//This will handle jump instructions
                          1'b0: begin  //This is the start of R-Type register write instructions

                                  case(Instruction[31:26]) //For CDR we'll just focus on R-Type instructions...  After CDR we will focus on adding memory instructions...
                                    6'b000000: begin
                                                  case (Instruction[5:0]) //Here is the ALU control block, Depending on the function code, we assign the ALUcontrol
                                                    6'b100000: ALUcontrol <= 4'b0010;//add
                                                    6'b100001: ALUcontrol <= 4'b0010;

                                                    6'b100100: ALUcontrol <= 4'b0000;//AND

                                                    6'b100111: ALUcontrol <= 4'b1000;//NOR

                                                    6'b100101: ALUcontrol <= 4'b0001;//OR

                                                    6'b101010: ALUcontrol <= 4'b0111;//SLT   This is behaving correctly...
                                                    6'b101011: ALUcontrol <= 4'b0111;//SLT

                                                    6'b000100: ALUcontrol <= 4'b1001;//SLL
                                                    6'b000110: ALUcontrol <= 4'b1010;//SRL

                                                    6'b100010: ALUcontrol <= 4'b0110;//Sub
                                                    //default: ;
                                                  endcase
                                                  // Assign Control bits
                                                  control[10:0] = 11'b1_0_0_0_0_100_0_0_1; // RegDst Jump Branch MemRead MemtoReg ALUOp[2:0] MemWrite ALUSrc RegWrite
                                                  // We need the read data 1 and the read data 2
                                                  readData1[SIZE-1:0] <= registerFile[Instruction[25:21]]; // This is $rs
                                                  readData2[SIZE-1:0] <= registerFile[Instruction[20:16]]; // This is $rt
                                                  rs[$clog2(SIZE)-1:0] <= Instruction[25:21];
                                                  rt[$clog2(SIZE)-1:0] <= Instruction[20:16];
                                                  writeReg[$clog2(SIZE) - 1 : 0] = Instruction[15:11]; // This is $rd
                                               end
                                    default: ; //Do nothing on nop
                                  endcase

                                end
                        endcase

                      end
              endcase


            end
      1'b1: ; //Do nothing on stall
    endcase


    //This case also applies to store, so come back here when implementing store
    //We have successfully decoded the instruction following the write register instruction that follows the load


    case (controlMEM[6] == 1'b1 && control[6] == 1'b0 && control[8] == 1'b0 && ( controlEX[8] || writeRegMEM[$clog2(SIZE)-1:0] != writeRegEX[$clog2(SIZE)-1:0] ) ) //Previous Previous instruction is load,
      1'b1: begin
              case (writeRegMEM[$clog2(SIZE)-1:0] == Instruction[20:16]) //The case where the write register from load matches a subsequent operand
                1'b1: begin
                        readData2[SIZE-1:0] <= data[SIZE-1:0];
                        $display("Forwarded Data: %h", data[SIZE-1:0], counter);
                      end
                1'b0: ;
              endcase



              case (writeRegMEM[$clog2(SIZE)-1:0] == Instruction[25:21]) //The case where the write register from a load matches a subsequent operand
                1'b1: begin
                        readData1[SIZE-1:0] <= data[SIZE-1:0];
                        $display("Forwarded Data: %h", data[SIZE-1:0], counter);
                      end
                1'b0: ;
              endcase


             case (writeRegMEM[$clog2(SIZE)-1:0] == Instruction[20:16] && writeRegMEM[$clog2(SIZE)-1:0] == Instruction[25:21])
               1'b1: begin
                       readData1[SIZE-1:0] <= data[SIZE-1:0];
                       readData2[SIZE-1:0] <= data[SIZE-1:0]; //No blocking statement here!!!!! Why though???
                       $display("Forwarded Data: %h", data[SIZE-1:0]);
                     end
               1'b0: ;
             endcase

            end
      1'b0: ; //No need to forward an operand here
    endcase


    //From LW to the second instruction begin a SW and they share the same write register
    case (control[8] && controlMEM[6] && writeRegMEM[$clog2(SIZE)-1:0] == writeReg[$clog2(SIZE)-1:0])
      1'b1: begin
              storeData[SIZE-1:0] <= data[SIZE-1:0]; //Foward the load data to the SW after a nop has been inserted
              $display("WriteReg: %b, WriteRegMEM: %b counter: %d",writeReg[$clog2(SIZE)-1:0],writeRegMEM[$clog2(SIZE)-1:0], counter);
            end
      1'b0: ;
    endcase


    case (controlEX[9] && (ALUresult[SIZE-1:0] != PC4EX[SIZE-1:0]) )
      1'b1: begin
              control[10:0] <= 11'b00000000000;
            end
      1'b0: ;
    endcase

  end

  assign testReg[SIZE-1:0] = registerFile[5'b00001]; //Test register is register 3
endmodule
