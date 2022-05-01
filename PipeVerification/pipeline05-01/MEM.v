module MEM #(parameter SIZE = 32)(
  input clk, //Clock that drives the pipeline
  input [SIZE-1:0] ALUresult, //The ALUresult from the EX stage
  input [SIZE-1:0] storeDataEX, //Data to store in memory
  input [$clog2(SIZE)-1:0] writeReg,
  input [$clog2(SIZE)-1:0] writeRegEX, //The write register from the EX stage
  input [10:0] control,
  input [10:0] controlEX, //The control for the instruction that passed through the EX stage
  input [$clog2(SIZE)-1:0] rsEX, //The source register from the EX stage
  input [$clog2(SIZE)-1:0] rtEX, //The target register from the EX stage
  input [3:0] ALUcontrolEX,
  input [$clog2(SIZE)-1:0] writeRegMEM2,
  input [10:0] controlMEM2,

  output reg [SIZE-1:0] data, //The data that was fetched from the data memory
  output reg [$clog2(SIZE)-1:0] writeRegMEM, //The write register for the current instruction
  output reg [10:0] controlMEM, //The control of the current instruction
  output reg [$clog2(SIZE)-1:0] rsMEM,
  output reg [$clog2(SIZE)-1:0] rtMEM,
  output [SIZE-1:0] testMEM
  );

  reg [SIZE-1:0] dataMemory [0:9]; //The data memory for the MEM stage (10 entries)

  integer counter;
  integer i;
  integer file;

  initial
  begin
    file = $fopen("/Users/jm/Desktop/pipelineMem.txt","w");
    counter = 0;
    for(i=0; i<10; i++)
    begin
      dataMemory[i] = i; //Load each data value into the dataMemory
    end
    $readmemh("/Users/jm/Desktop/perlProjects/memory.txt", dataMemory);
    data[SIZE-1:0] = 32'b0;
    writeRegMEM[$clog2(SIZE)-1:0] = 5'b01010;
    controlMEM[10:0] = 11'b0;
  end

  always @ (posedge clk)
  begin



    //Write the memory data to a file for verification with SPIM simulator
    counter <= counter + 1; //Increment the cycle counter (For testing/debug purposes)
    if(counter == 80) //Supposedly clock cycle 9 is the executed raw hazard instruction for test example
    begin
      for(i = 0; i < 10; i++)
      begin
        $fwriteh(file,dataMemory[i]); //Write the register values for $t0 - $t9, these will be compared to the 'golden file'
        $fdisplay(file,""); //Writes a new line, since $fdisplay always adds a new line
      end
      $fclose(file);//Close the file descriptor or else bad things may happen
    end

    case (controlEX[6])
      1'b1: data[SIZE-1:0] <= dataMemory[ALUresult[6:2]];
      1'b0: ;
    endcase

    case (controlEX[8])
      1'b1: dataMemory[ALUresult[6:2]] <= storeDataEX[SIZE-1:0];
      1'b0: ;
    endcase

    //There should be a case where the write register from the memory stage and the write register from the execute stage are the same
    //  the previous is load and next is store
    case (controlMEM[6] && controlEX[8] && writeRegMEM[$clog2(SIZE)-1:0] == writeRegEX[$clog2(SIZE)-1:0])
      1'b1: begin
              $display("I have reached this statement: Prev: %d, Next: %d, data: %h, ALUresult: %b",writeRegMEM[$clog2(SIZE)-1:0],writeRegEX[$clog2(SIZE)-1:0],data[SIZE-1:0], ALUresult[6:2]);
              dataMemory[ALUresult[6:2]] <= data[SIZE-1:0]; //This is just moving memory!!!
            end
      1'b0: ;
    endcase

    //From LW to the second SW and they share the same write register
    case (controlEX[8] && controlMEM2[6] && writeRegEX[$clog2(SIZE)-1:0] == writeRegMEM2[$clog2(SIZE)-1:0])
      1'b1: begin
              $display("I HAVE reached this statement: Prev: %d, NextNext: %d, data: %h", writeRegMEM2[$clog2(SIZE)-1:0], writeRegEX[$clog2(SIZE)-1:0],data[SIZE-1:0]);
              dataMemory[ALUresult[6:2]] <= storeDataEX[SIZE-1:0]; //Foward the load data to the SW after a nop has been inserted
            end
      1'b0: ;
    endcase

    controlMEM[10:0] <= controlEX[10:0]; //No matter what operation its in, update control memory
    writeRegMEM[$clog2(SIZE) - 1 : 0] <= writeRegEX[$clog2(SIZE)-1:0];


  end
  assign testMEM[SIZE-1:0] = dataMemory[5'b00100]; //Memory address I am currently testing
endmodule
