module IFv2 #(parameter SIZE = 32) (
  input clk,
  input [$clog2(SIZE) - 1 : 0] writeReg,
  //input written, //Send written, so that when data is written IF knows, that way stall can be reset and allow IF and ID to continue!
  input writtenRst,
  output reg [SIZE-1:0] PC_4, //Output the Program Counter + 4
  output reg [SIZE-1:0] Instruction, //Output the Instruction
  output reg stall
  );

  reg [SIZE-1:0] PC; //Try having the program counter inside of the module...

  reg [SIZE-1:0] instructionMemory [SIZE-1:0];


  initial
  begin
      stall <= 1'b0;
  end

  //Now that we have the simple R-Type 0/20 instruction we can make a program to add to 100
  //  Carefull though!!!! We do not yet have hazard detection/prevention implemented yet!

  //Now how do you stall the pipeline???
  //  Define NOP as all Xs, then if the recieved data is X, we know not to do anything with it...
  //  Right now we currently have a total of 3 raw stalls, we can do better than that! (Maybe some timing or signalling...)

  //According to the documentation I've taken so far there is a speedup of 9/5 when you include data forwarding!!!

  // After adding raw hazard detection I managed to fix the nop issue. Now nops/stalls will be implemented when they need to be!

  initial
  begin
    PC = -4; //Program counter before any instruction
    //The below program should only be messing with the test register (It should either have value of X, 25, or 50 at all times...)
    // The addition of data forwarding has lowered the number of stalls required to reach the right answer!!!!
    instructionMemory[0] = 32'b000000_10100_00101_00000_00000_100000;//Add r20 , r5, r0
    instructionMemory[1] = 32'b000000_00000_00111_00000_00000_100100;//AND r0, r7, r0
    instructionMemory[2] = 32'b000000_00000_01011_00000_00000_100111;//NOR r0, r11, r0
    instructionMemory[3] = 32'b000000_00000_10001_00000_00000_100101;//OR r0, r17, r0
    instructionMemory[4] = 32'b000000_00000_01000_00000_00000_101010;//slt r0, r8, r0
    instructionMemory[5] = 32'b000000_00000_00000_00000_00101_000000;//sll r0, 5, r0
    instructionMemory[6] = 32'b000000_00000_00000_00000_00011_000010;//srl r0, 3, r0
    instructionMemory[7] = 32'b000000_00000_01100_00000_00000_100010;//sub r0, r12, r0
  end


  always @(negedge clk) //If this his happening on the negedge of clock then after its positive it would have an instruction to read from...
  begin


  end

  always @(posedge clk) //At rising edge of clock and only when raw is low
  begin


    if(stall == 1'b0)
    begin
      PC = PC + 4;//Increment the program counter first before anything else
      Instruction = instructionMemory[PC[6:2]]; //Since there are only SIZE-1 entries for now this makes sense
      PC_4 <= PC + 4;//Increment PC by 4
    end


    case (writeReg)
      5'b00000: if(Instruction[25:21] == 5'b00000 || Instruction[20:16] == 5'b00000) stall = 1'b1;
      5'b00001: if(Instruction[25:21] == 5'b00001 || Instruction[20:16] == 5'b00001) stall = 1'b1;
      5'b00010: if(Instruction[25:21] == 5'b00010 || Instruction[20:16] == 5'b00010) stall = 1'b1;
      5'b00011: if(Instruction[25:21] == 5'b00011 || Instruction[20:16] == 5'b00011) stall = 1'b1;
      5'b00100: if(Instruction[25:21] == 5'b00100 || Instruction[20:16] == 5'b00100) stall = 1'b1;
      5'b00101: if(Instruction[25:21] == 5'b00101 || Instruction[20:16] == 5'b00101) stall = 1'b1;
      5'b00110: if(Instruction[25:21] == 5'b00110 || Instruction[20:16] == 5'b00110) stall = 1'b1;
      5'b00111: if(Instruction[25:21] == 5'b00111 || Instruction[20:16] == 5'b00111) stall = 1'b1;
      5'b01000: if(Instruction[25:21] == 5'b01000 || Instruction[20:16] == 5'b01000) stall = 1'b1;
      5'b01001: if(Instruction[25:21] == 5'b01001 || Instruction[20:16] == 5'b01001) stall = 1'b1;
      5'b01010: if(Instruction[25:21] == 5'b01010 || Instruction[20:16] == 5'b01010) stall = 1'b1;
      5'b01011: if(Instruction[25:21] == 5'b01011 || Instruction[20:16] == 5'b01011) stall = 1'b1;
      5'b01100: if(Instruction[25:21] == 5'b01100 || Instruction[20:16] == 5'b01100) stall = 1'b1;
      5'b01101: if(Instruction[25:21] == 5'b01101 || Instruction[20:16] == 5'b01101) stall = 1'b1;
      5'b01110: if(Instruction[25:21] == 5'b01110 || Instruction[20:16] == 5'b01110) stall = 1'b1;
      5'b01111: if(Instruction[25:21] == 5'b01111 || Instruction[20:16] == 5'b01111) stall = 1'b1;
      5'b10000: if(Instruction[25:21] == 5'b10000 || Instruction[20:16] == 5'b10000) stall = 1'b1;
      5'b10001: if(Instruction[25:21] == 5'b10001 || Instruction[20:16] == 5'b10001) stall = 1'b1;
      5'b10010: if(Instruction[25:21] == 5'b10010 || Instruction[20:16] == 5'b10010) stall = 1'b1;
      5'b10011: if(Instruction[25:21] == 5'b10011 || Instruction[20:16] == 5'b10011) stall = 1'b1;
      5'b10100: if(Instruction[25:21] == 5'b10100 || Instruction[20:16] == 5'b10100) stall = 1'b1;
      5'b10101: if(Instruction[25:21] == 5'b10101 || Instruction[20:16] == 5'b10101) stall = 1'b1;
      5'b10110: if(Instruction[25:21] == 5'b10110 || Instruction[20:16] == 5'b10110) stall = 1'b1;
      5'b10111: if(Instruction[25:21] == 5'b10111 || Instruction[20:16] == 5'b10111) stall = 1'b1;
      5'b11000: if(Instruction[25:21] == 5'b11000 || Instruction[20:16] == 5'b11000) stall = 1'b1;
      5'b11001: if(Instruction[25:21] == 5'b11001 || Instruction[20:16] == 5'b11001) stall = 1'b1;
      5'b11010: if(Instruction[25:21] == 5'b11010 || Instruction[20:16] == 5'b11010) stall = 1'b1;
      5'b11011: if(Instruction[25:21] == 5'b11011 || Instruction[20:16] == 5'b11011) stall = 1'b1;
      5'b11100: if(Instruction[25:21] == 5'b11100 || Instruction[20:16] == 5'b11100) stall = 1'b1;
      5'b11101: if(Instruction[25:21] == 5'b11101 || Instruction[20:16] == 5'b11101) stall = 1'b1;
      5'b11110: if(Instruction[25:21] == 5'b11110 || Instruction[20:16] == 5'b11110) stall = 1'b1;
      5'b11111: if(Instruction[25:21] == 5'b11111 || Instruction[20:16] == 5'b11111) stall = 1'b1;
      default: stall = 1'b0;
    endcase

    //Need to check if written is 1 after all of this other stuff. Thats becuause there are blocking statements that help delay for the written signal to show up in this stage!
    if(writtenRst == 1'b1) //If we don't check for stall here it will reset stall :0
    begin
      stall = 1'b0; //Reset stall to 0!
    end


  end
endmodule
