module IDv2 #(parameter SIZE = 32)(
  input clk, //clock driving processor
  input stall,
  input [SIZE - 1 : 0] instruction, // Takes the instruction as input
  input [SIZE - 1 : 0] PC_4, //Takes the program counter + 4

  input [$clog2(SIZE)-1 : 0] writeReg_EX, //All we need is write register of EX to determine when to stall for RAW
  input [$clog2(SIZE)-1 : 0] writeReg_MEM, //For load instructions
  input [10 : 0]  control_EX, //This is specifically meant for instructions that only take use of the ALU!
  input [10 : 0]  control_MEM, //This is for instructions that write back data from memory!
  input [SIZE-1:0] ALUresult,
  input [SIZE-1:0] ALUresult_MEM, //The ALUresult for load is only known at the end of the memory stage

  output reg [3:0] ALUcontrol,

  output [SIZE - 1 : 0] regTest, //See what the value of the test register is in register file for verification!
  output reg [SIZE - 1 : 0] readData1, //read data 1
  output reg [SIZE - 1 : 0] readData2, // read data 2
  output reg [$clog2(SIZE) - 1 : 0] shamt, //Shift register
  output reg [$clog2(SIZE) - 1 : 0] writeReg, //Write Register   How about making this don't care until the register has been written...
  output reg [10:0] control, // Control bits based on op code
  output reg [SIZE - 1 : 0] PC_4_out,
  output reg written,
  output reg writtenRst //due to unfortunate unsynthesizability issues
  );

  reg read2;
  reg read1;

  reg [SIZE-1:0] registerFile [SIZE-1:0]; //This is the register file
  integer i = 0;
  initial
  begin
    written = 0;
    writtenRst = 0;
    read2 = 1'b0;
    read1 = 1'b0;
    for(i = 0; i < SIZE; i++)
    begin
      registerFile[i] = i; // Each register file value has its name as the value...
    end
  end

  always @(posedge clk) //Writing always happens on the positive edge of the clock
  begin


    if(stall == 1'b1 && writeReg == writeReg_EX) //If there is a stall, and this is the register that should be written,
    begin                                       //Then enact the written signal!
      written = 1'b1;  //We can send a signal to notify it being written, we can't reset stall here though!
    end

    if(stall == 1'b0)
    begin
      written = 1'b0;
    end


    if(control_EX[5:3] == 3'b100)// Use data forwarding!!!!!!!!!!!
    begin

      registerFile[writeReg_EX] [SIZE-1:0] <= ALUresult [SIZE-1:0]; //Write the alu result back into the register file

    end

    if(control_MEM[5:3] == 3'b000) //The pipeline should be stalled, if the write registers for IF or ID are the same. So if there is a hazard
    begin                               //Then the pipeline would freeze and force the load to be written back during the MEM stage!

      registerFile[writeReg_MEM] [SIZE-1:0] <= ALUresult_MEM [SIZE-1:0]; //Write back the alu result from memory for load instructions

    end

  end

  //Now we need to discuss how to freeze the pipeline...
  // always @(posedge clk && !freeze)   ; We define freeze as a signal to tell the pipeline to freeze
  //Do we only need to freeze on raw hazards???  How about we start with this and add more functionality later
  // Maybe use a signal like a semaphore???

  always @(negedge clk)//Reading always happens on the negative edge of the clock, and only when there is no raw hazard!
  begin

    case (written)
      1'b1: writtenRst = 1'b1 ;
      1'b0: writtenRst = 1'b0 ;
    endcase

    if(stall == 1'b0)
    begin
      writtenRst = 1'b0;
    end

    //We need to detect raw hazards first...!
    //  Instruction -> ID stage          If instruction read registers match ID writeReg , there is a data hazard!
    //I need a mechanism to handle raw hazards!


    //Need to change all if statements to case statements for synthesis!


    case(stall)
      1'b0: begin
              case(instruction[31:26] > 6'b000011)
                default: begin
                          case (instruction[31:26])
                            6'b001000: begin
                                         control[10:0] <= 11'b0_0_0_1_1_000_0_1_1; //ALUop is 000 because we know what we want to do!
                                         ALUcontrol <= 4'b0010; //ALU control is for Addition
                                         readData2 <= registerFile[instruction[20:16]]; // ReadData2 and signextended immediate will be added together
                                         readData1 <= {  { 16 { instruction[15] } }, instruction[15:0] } ; //ReadData1 will act as immediate value!
                                         writeReg[$clog2(SIZE) - 1 : 0] <= instruction[25:21]; //Rt is the destination register for this instruction
                                       end
                            default: ;
                          endcase
                         end
              endcase
              case(instruction[31:26] < 6'b000011 && instruction[31:26] > 6'b000000)
                default: begin

                         end
              endcase
              case(instruction[31:26] == 6'b000000)
                default: begin
                            case (instruction[5:0])
                              6'b100000: ALUcontrol <= 4'b0010;//add
                              6'b100001: ALUcontrol <= 4'b0010;

                              6'b100100: ALUcontrol <= 4'b0000;//AND

                              6'b100111: ALUcontrol <= 4'b1000;//NOR

                              6'b100101: ALUcontrol <= 4'b0001;//OR

                              6'b101010: ALUcontrol <= 4'b0111;//SLT   This is behaving correctly...
                              6'b101011: ALUcontrol <= 4'b0111;//SLT

                              6'b000000: ALUcontrol <= 4'b1001;//SLL
                              6'b000010: ALUcontrol <= 4'b1010;//SRL

                              6'b100010: ALUcontrol <= 4'b0110;//Sub
                              //default: ;

                            endcase

                            // Assign Control bits
                            control[10:0] <= 11'b1_0_0_0_0_100_0_0_1; // RegDst Jump Branch MemRead MemtoReg ALUOp[2:0] MemWrite ALUSrc RegWrite
                            // We need the read data 1 and the read data 2
                            readData1[SIZE-1:0] <= registerFile[instruction[25:21]]; //Read Data 2 was [20:16], so readData1 was [25:21]
                            // We need the read data 2
                            readData2[SIZE-1:0] <= registerFile[instruction[20:16]]; //This is read data 2...
                            //shamt
                            shamt[$clog2(SIZE) - 1 : 0] <= instruction[10:6];
                            //Write register
                            writeReg[$clog2(SIZE) - 1 : 0] <= instruction[15:11];
                         end
              endcase
              // Now PC + 4 this happens for all instruction types
              PC_4_out[SIZE-1:0] <= PC_4 [SIZE-1:0];
            end
      default: ;
    endcase

  end

  assign regTest = registerFile[5'b00000]; //Keep track of register 0
endmodule
