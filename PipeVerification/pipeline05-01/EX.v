module EX #(parameter SIZE = 32) (
  input clk, //Clock that drives the pipeline
  input [10:0] control, //Control bits for the decoded instruction
  input [10:0] controlMEM, //For load data forwarding
  input [$clog2(SIZE)-1:0] writeReg, //The write register for the decoded instruction
  input [$clog2(SIZE)-1:0] writeRegMEM, //The write register for the memory stage
  input [SIZE-1:0] readData1, //Read data from operandEX 1 of instruction
  input [SIZE-1:0] readData2, //Read data from operandEX 2 of instruction
  input [SIZE-1:0] storeData, //Data to be stored in memory
  input [3:0] ALUcontrol, //ALU control bits to determine the ALU operation
  input [SIZE-1:0] data, //Data to write back for load type instructions
  input [$clog2(SIZE)-1:0] rs, //Source register from ID stage
  input [$clog2(SIZE)-1:0] rt, //Target register from the ID stage
  input [SIZE-1:0] PC4ID, //The incremented program counter sent through the ID stage
  input [SIZE-1:0] PCoffset,


  output reg [$clog2(SIZE)-1:0] writeRegMEM2,
  output reg [10:0] controlMEM2,
  output reg [SIZE-1:0] readData1EX,
  output reg [SIZE-1:0] readData2EX,
  output reg [3:0] ALUcontrolEX,
  output reg [SIZE-1:0] storeDataEX, //Store Data to carry to MEM stage
  output reg [SIZE-1:0] ALUresult, //The ALU result from the ALU operation stage
  output reg [$clog2(SIZE)-1:0] writeRegEX, //The write register for the decoded instruction sent through the execute stage
  output reg [10:0] controlEX, //The control bits for the previously decoded instruction
  output reg [$clog2(SIZE)-1:0] rsEX, //Source register through the execute stage
  output reg [$clog2(SIZE)-1:0] rtEX, //Target register through the execute stage
  output reg [SIZE-1:0] PC4EX //The incremented program counter passed through the execute stage for branch target calculation
  );


  initial begin

  end


  //I believe there not to be a need for the initial block at the moment


  always @ (posedge clk) //ALU operation always happens on the rising edge of clock
  begin

    //Perform hazard detection here for rtype

    //Regardless of what the instruction ALU operation is, we still carry over the write register from ID stage

    controlEX[10:0] <= control[10:0]; //This is control passing through the execute stage
    writeRegEX[$clog2(SIZE)-1:0] <= writeReg[$clog2(SIZE)-1:0];
    storeDataEX[SIZE-1:0] <= storeData[SIZE-1:0];
    rsEX[$clog2(SIZE)-1:0] <= rs[$clog2(SIZE)-1:0];
    rtEX[$clog2(SIZE)-1:0] <= rt[$clog2(SIZE)-1:0];
    readData1EX[SIZE-1:0] <= readData1[SIZE-1:0];
    readData2EX[SIZE-1:0] <= readData2[SIZE-1:0];//Can be reassigned to fit the needs of arithmetic checks
    ALUcontrolEX[3:0] <= ALUcontrol[3:0];
    writeRegMEM2[$clog2(SIZE)-1:0] <= writeRegMEM[$clog2(SIZE)-1:0];
    controlMEM2[10:0] <= controlMEM[10:0];
    PC4EX[SIZE-1:0] <= PC4ID[SIZE-1:0];


    //Don't forget to specify that the stall only happens when there is a load followed by a register write instruction. That be it not store!
    case (controlEX[6] && !control[6] && !control[8] && (writeRegEX[$clog2(SIZE)-1:0] == rs[$clog2(SIZE)-1:0] || writeRegEX[$clog2(SIZE)-1:0] == rt[$clog2(SIZE)-1:0]) || control[10:0] == 11'b0)
      1'b1: ; //Do nothing
      1'b0: begin
              //Universal case where we just don't care
              case (ALUcontrol[3:0])
                4'b0010: begin
                          ALUresult[SIZE-1:0] <= readData1[SIZE-1:0] + readData2[SIZE-1:0];
                         end
                4'b0000: ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] & readData2 [SIZE-1:0];   //and
                4'b1000: ALUresult[SIZE-1:0] <= ~(readData1 [SIZE-1:0] | readData2 [SIZE-1:0]); //nor
                4'b0001: ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] | readData2 [SIZE-1:0]); //or
                4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                            case (readData1[SIZE-1]) //The most significant bit determines the sign of the number
                              1'b1: begin //If readData1 is negative
                                      case (readData2[SIZE-1])
                                        1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                              end
                                        1'b1: begin //If readData2 is also negative, then just compare them
                                                ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] < readData2 [SIZE-1:0]) ? 1 : 0 ; //slt
                                              end
                                      endcase
                                    end
                              1'b0: begin //If readData1 is positive
                                      case (readData2[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                        1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                              end
                                        1'b0: begin // And readData2 is positive, then just compare the two
                                                ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] < readData2 [SIZE-1:0]) ? 1 : 0 ; //slt
                                              end
                                      endcase
                                    end
                            endcase
                         end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                4'b0110: begin
                          ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] - readData2 [SIZE-1:0]); //sub
                         end
                default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
              endcase




              //So the bottom case statement only pertains to back to back write register instructions, this should also cover previous write register and next branch
              case ( (control[6] == 1'b0 && controlEX[6] == 1'b0) && (control[8] == 1'b0 && controlEX[8] == 1'b0)) //if both are write reg or if prev is
                1'b1: begin                           //and next is load
                        case (readData1EX[SIZE-1] == 1'b1 && readData2EX[SIZE-1] == 1'b0 && ALUresult[SIZE-1] == 1'b0 && ALUcontrolEX[3:0] == 4'b0110)
                          1'b1: $display("EX Subtraction between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]); //Do nothing on stall, if there is no change then no forwarding...
                          1'b0: begin
                                  case (readData1EX[SIZE-1] == 1'b1 && readData2EX[SIZE-1] == 1'b1 && ALUresult[SIZE-1] == 1'b0 && ALUcontrolEX[3:0] == 4'b0010)
                                    1'b1: $display("EX Addition between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]); //Do nothing on Addition overflow
                                    1'b0: begin
                                            case (readData1EX[SIZE-1] == 1'b0 && readData2EX[SIZE-1] == 1'b1 && ALUresult[SIZE-1] == 1'b1 && ALUcontrolEX[3:0] == 4'b0110)
                                              1'b1: $display("EX Subtraction between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]);
                                              1'b0: begin
                                                      case (readData1EX[SIZE-1] == 1'b0 && readData2EX[SIZE-1] == 1'b0 && ALUresult[SIZE-1] == 1'b1 && ALUcontrolEX[3:0] == 4'b0010)
                                                        1'b1: $display("EX Addition between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]);
                                                        1'b0: begin
                                                                    case (writeRegEX[$clog2(SIZE)-1:0] == rt[$clog2(SIZE)-1:0])
                                                                      1'b1: begin
                                                                              case (ALUcontrol[3:0])
                                                                                4'b0010: begin
                                                                                          ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] + ALUresult [SIZE-1:0];
                                                                                         end
                                                                                4'b0000: ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] & ALUresult [SIZE-1:0];   //and
                                                                                4'b1000: begin
                                                                                          ALUresult[SIZE-1:0] <= ~(readData1 [SIZE-1:0] | ALUresult [SIZE-1:0]); //nor
                                                                                         end
                                                                                4'b0001: ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] | ALUresult [SIZE-1:0]); //or
                                                                                4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                                                            case (readData1[SIZE-1]) //The most significant bit determines the sign of the number
                                                                                              1'b1: begin //If readData1 is negative
                                                                                                      case (ALUresult[SIZE-1])
                                                                                                        1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                                                              end
                                                                                                        1'b1: begin //If readData2 is also negative, then just compare them
                                                                                                                ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] < ALUresult [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                              end
                                                                                                      endcase
                                                                                                    end
                                                                                              1'b0: begin //If readData1 is positive
                                                                                                      case (ALUresult[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                                                                        1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                                                              end
                                                                                                        1'b0: begin // And readData2 is positive, then just compare the two
                                                                                                                ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] < ALUresult [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                              end
                                                                                                      endcase
                                                                                                    end
                                                                                            endcase
                                                                                         end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                                                                4'b0110: begin
                                                                                          ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] - ALUresult [SIZE-1:0]); //sub

                                                                                         end
                                                                                default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
                                                                              endcase
                                                                              readData2EX[SIZE-1:0] <= ALUresult[SIZE-1:0];
                                                                            end
                                                                      1'b0: ; //do nothing
                                                                    endcase

                                                                    case (writeRegEX[$clog2(SIZE)-1:0] == rs[$clog2(SIZE)-1:0])
                                                                      1'b1: begin
                                                                              case (ALUcontrol[3:0])
                                                                                4'b0010: begin
                                                                                          ALUresult[SIZE-1:0] <= ALUresult [SIZE-1:0] + readData2 [SIZE-1:0];   //add
                                                                                         end
                                                                                4'b0000: ALUresult[SIZE-1:0] <= ALUresult [SIZE-1:0] & readData2 [SIZE-1:0];   //and
                                                                                4'b1000: begin
                                                                                          ALUresult[SIZE-1:0] <= ~(ALUresult [SIZE-1:0] | readData2 [SIZE-1:0]); //nor
                                                                                         end
                                                                                4'b0001: ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] | readData2 [SIZE-1:0]); //or
                                                                                4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                                                            case (ALUresult[SIZE-1]) //The most significant bit determines the sign of the number
                                                                                              1'b1: begin //If readData1 is negative
                                                                                                      case (readData2[SIZE-1])
                                                                                                        1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                                                              end
                                                                                                        1'b1: begin //If readData2 is also negative, then just compare them
                                                                                                                ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] < readData2 [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                              end
                                                                                                      endcase
                                                                                                    end
                                                                                              1'b0: begin //If readData1 is positive
                                                                                                      case (readData2[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                                                                        1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                                                              end
                                                                                                        1'b0: begin // And readData2 is positive, then just compare the two
                                                                                                                ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] < readData2 [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                              end
                                                                                                      endcase
                                                                                                    end
                                                                                            endcase
                                                                                         end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                                                                4'b0110: begin
                                                                                          //$display("ALUresult Prev: %h ReadData2: %h",ALUresult[SIZE-1:0],readData2[SIZE-1:0]);
                                                                                          ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] - readData2 [SIZE-1:0]); //sub
                                                                                          //$display("ALUresult Next: %h",ALUresult[SIZE-1:0]);
                                                                                         end
                                                                                default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
                                                                              endcase
                                                                              readData1EX[SIZE-1:0] <= ALUresult[SIZE-1:0];
                                                                            end
                                                                      1'b0: ;
                                                                    endcase

                                                                    case (writeRegEX[$clog2(SIZE)-1:0] == rs[$clog2(SIZE)-1:0] && writeRegEX[$clog2(SIZE)-1:0] == rt[$clog2(SIZE)-1:0])
                                                                      1'b1: begin
                                                                              case (ALUcontrol[3:0])
                                                                                4'b0010: begin
                                                                                          ALUresult[SIZE-1:0] <= ALUresult [SIZE-1:0] + ALUresult [SIZE-1:0];   //add
                                                                                         end
                                                                                4'b0000: ALUresult[SIZE-1:0] <= ALUresult [SIZE-1:0] & ALUresult [SIZE-1:0];   //and
                                                                                4'b1000: ALUresult[SIZE-1:0] <= ~(ALUresult [SIZE-1:0] | ALUresult [SIZE-1:0]); //nor
                                                                                4'b0001: ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] | ALUresult [SIZE-1:0]); //or
                                                                                4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                                                            case (ALUresult[SIZE-1]) //The most significant bit determines the sign of the number
                                                                                              1'b1: begin //If readData1 is negative
                                                                                                      case (ALUresult[SIZE-1])
                                                                                                        1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                                                              end
                                                                                                        1'b1: begin //If readData2 is also negative, then just compare them
                                                                                                                ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] < ALUresult [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                              end
                                                                                                      endcase
                                                                                                    end
                                                                                              1'b0: begin //If readData1 is positive
                                                                                                      case (ALUresult[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                                                                        1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                                                                ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                                                              end
                                                                                                        1'b0: begin // And readData2 is positive, then just compare the two
                                                                                                                ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] < ALUresult [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                              end
                                                                                                      endcase
                                                                                                    end
                                                                                            endcase
                                                                                         end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                                                                4'b0110: begin
                                                                                          ALUresult[SIZE-1:0] <= (ALUresult [SIZE-1:0] - ALUresult [SIZE-1:0]); //sub
                                                                                         end
                                                                                default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
                                                                              endcase
                                                                              readData1EX[SIZE-1:0] <= ALUresult[SIZE-1:0];
                                                                              readData2EX[SIZE-1:0] <= ALUresult[SIZE-1:0];
                                                                            end
                                                                      1'b0: ; //do nothing
                                                                    endcase
                                                              end
                                                      endcase
                                                    end
                                            endcase
                                          end
                                  endcase
                                end
                        endcase
                      end
                default: ;
              endcase


              //Previous register write , next store
              case ( (control[8] == 1'b1 && controlEX[6] == 1'b0 && controlEX[8] == 1'b0) ) //if both are write reg or if prev is
                1'b1: begin                           //and next is load
                        case (readData1EX[SIZE-1] == 1'b1 && readData2EX[SIZE-1] == 1'b0 && ALUresult[SIZE-1] == 1'b0 && ALUcontrolEX[3:0] == 4'b0110)
                          1'b1: $display("EX Subtraction between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]); //Do nothing on stall, if there is no change then no forwarding...
                          1'b0: begin
                                  case (readData1EX[SIZE-1] == 1'b1 && readData2EX[SIZE-1] == 1'b1 && ALUresult[SIZE-1] == 1'b0 && ALUcontrolEX[3:0] == 4'b0010)
                                    1'b1: $display("EX Addition between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]); //Do nothing on Addition overflow
                                    1'b0: begin
                                            case (readData1EX[SIZE-1] == 1'b0 && readData2EX[SIZE-1] == 1'b1 && ALUresult[SIZE-1] == 1'b1 && ALUcontrolEX[3:0] == 4'b0110)
                                              1'b1: $display("EX Subtraction between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]);
                                              1'b0: begin
                                                      case (readData1EX[SIZE-1] == 1'b0 && readData2EX[SIZE-1] == 1'b0 && ALUresult[SIZE-1] == 1'b1 && ALUcontrolEX[3:0] == 4'b0010)
                                                        1'b1: $display("EX Addtion between %h and %h resulted in %h", readData1EX[SIZE-1:0], readData2EX[SIZE-1:0], ALUresult[SIZE-1:0]);
                                                        1'b0: begin
                                                                case (writeRegEX[$clog2(SIZE)-1:0] == writeReg[$clog2(SIZE)-1:0])
                                                                  1'b1: begin

                                                                          storeDataEX[SIZE-1:0] <= ALUresult[SIZE-1:0];
                                                                          /*
                                                                          case (ALUcontrol[3:0])
                                                                            4'b0010: begin
                                                                                      storeDataEX[SIZE-1:0] <= readData1 [SIZE-1:0] + ALUresult [SIZE-1:0];
                                                                                     end
                                                                            4'b0000: storeDataEX[SIZE-1:0] <= readData1 [SIZE-1:0] & ALUresult [SIZE-1:0];   //and
                                                                            4'b1000: begin
                                                                                      storeDataEX[SIZE-1:0] <= ~(readData1 [SIZE-1:0] | ALUresult [SIZE-1:0]); //nor
                                                                                     end
                                                                            4'b0001: storeDataEX[SIZE-1:0] <= (readData1 [SIZE-1:0] | ALUresult [SIZE-1:0]); //or
                                                                            4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                                                        case (readData1[SIZE-1]) //The most significant bit determines the sign of the number
                                                                                          1'b1: begin //If readData1 is negative
                                                                                                  case (ALUresult[SIZE-1])
                                                                                                    1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                                                            storeDataEX[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                                                          end
                                                                                                    1'b1: begin //If readData2 is also negative, then just compare them
                                                                                                            storeDataEX[SIZE-1:0] <= (readData1 [SIZE-1:0] < ALUresult [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                          end
                                                                                                  endcase
                                                                                                end
                                                                                          1'b0: begin //If readData1 is positive
                                                                                                  case (ALUresult[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                                                                    1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                                                            storeDataEX[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                                                          end
                                                                                                    1'b0: begin // And readData2 is positive, then just compare the two
                                                                                                            storeDataEX[SIZE-1:0] <= (readData1 [SIZE-1:0] < ALUresult [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                                                          end
                                                                                                  endcase
                                                                                                end
                                                                                        endcase
                                                                                     end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                                                            4'b0110: begin
                                                                                      storeDataEX[SIZE-1:0] <= (readData1 [SIZE-1:0] - ALUresult [SIZE-1:0]); //sub
                                                                                     end
                                                                            default: storeDataEX[SIZE-1:0] <= 32'b0; //Do Nothing

                                                                          endcase

                                                                          */

                                                                          $display("ReadData1 : %h ALUresult: %h", readData1 [SIZE-1:0], ALUresult[SIZE-1:0] );
                                                                        end
                                                                  1'b0: ; //do nothing
                                                                endcase
                                                            end
                                                      endcase
                                                    end
                                            endcase
                                          end
                                  endcase
                                end
                        endcase
                      end
                default: ;
              endcase


              //From LW to the second instruction begin a SW and they share the same write register
              case ( (control[8] && controlMEM[6] && writeRegMEM[$clog2(SIZE)-1:0] == writeReg[$clog2(SIZE)-1:0]) )
                1'b1: begin
                        storeDataEX[SIZE-1:0] <= data[SIZE-1:0]; //Foward the load data to the SW after a nop has been inserted
                      end
                1'b0: ;
              endcase

              //Forwarding for write reg to load instructions

              //Fowarding for load to write register instructions

              case (!control[8] && control[9] == 1'b0 && controlEX[8] == 1'b0 && controlEX[6] == 1'b0 && controlEX[9] == 1'b0 && controlMEM[6] == 1'b1) //Next instruction is not memory but previous instruction is
                1'b1: begin

                          case (writeRegMEM[$clog2(SIZE)-1:0] == rtEX[$clog2(SIZE)-1:0])
                            1'b1: begin
                                    case (ALUcontrol[3:0])
                                      4'b0010: begin
                                                ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] + data [SIZE-1:0];   //add
                                               end
                                      4'b0000: ALUresult[SIZE-1:0] <= readData1 [SIZE-1:0] & data [SIZE-1:0];   //and
                                      4'b1000: ALUresult[SIZE-1:0] <= ~(readData1 [SIZE-1:0] | data [SIZE-1:0]); //nor
                                      4'b0001: ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] | data [SIZE-1:0]); //or
                                      4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                  case (readData1[SIZE-1]) //The most significant bit determines the sign of the number
                                                    1'b1: begin //If readData1 is negative
                                                            case (data[SIZE-1])
                                                              1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                      ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                    end
                                                              1'b1: begin //If readData2 is also negative, then just compare them
                                                                      ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] < data [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                    end
                                                            endcase
                                                          end
                                                    1'b0: begin //If readData1 is positive
                                                            case (data[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                              1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                      ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                    end
                                                              1'b0: begin // And readData2 is positive, then just compare the two
                                                                      ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] < data [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                    end
                                                            endcase
                                                          end
                                                  endcase
                                               end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                      4'b0110: begin
                                                ALUresult[SIZE-1:0] <= (readData1 [SIZE-1:0] - data [SIZE-1:0]); //sub
                                               end
                                      default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
                                    endcase
                                  end
                            1'b0: ;
                          endcase


                          case (writeRegMEM[$clog2(SIZE)-1:0] == rsEX[$clog2(SIZE)-1:0])
                            1'b1: begin
                                    case (ALUcontrol[3:0])
                                      4'b0010: begin
                                                ALUresult[SIZE-1:0] <= data [SIZE-1:0] + readData2 [SIZE-1:0];   //add
                                               end
                                      4'b0000: ALUresult[SIZE-1:0] <= data [SIZE-1:0] & readData2 [SIZE-1:0];   //and
                                      4'b1000: ALUresult[SIZE-1:0] <= ~(data [SIZE-1:0] | readData2 [SIZE-1:0]); //nor
                                      4'b0001: ALUresult[SIZE-1:0] <= (data [SIZE-1:0] | readData2 [SIZE-1:0]); //or
                                      4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                  case (data[SIZE-1]) //The most significant bit determines the sign of the number
                                                    1'b1: begin //If readData1 is negative
                                                            case (readData2[SIZE-1])
                                                              1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                      ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                    end
                                                              1'b1: begin //If readData2 is also negative, then just compare them
                                                                      ALUresult[SIZE-1:0] <= (data [SIZE-1:0] < readData2 [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                    end
                                                            endcase
                                                          end
                                                    1'b0: begin //If readData1 is positive
                                                            case (readData2[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                              1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                      ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                    end
                                                              1'b0: begin // And readData2 is positive, then just compare the two
                                                                      ALUresult[SIZE-1:0] <= (data [SIZE-1:0] < readData2 [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                    end
                                                            endcase
                                                          end
                                                  endcase
                                               end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                      4'b0110: begin
                                                ALUresult[SIZE-1:0] <= (data [SIZE-1:0] - readData2 [SIZE-1:0]); //sub
                                               end
                                      default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
                                    endcase
                                  end
                            1'b0: ;
                          endcase


                         case (writeRegMEM[$clog2(SIZE)-1:0] == rtEX[$clog2(SIZE)-1:0] && writeRegMEM[$clog2(SIZE)-1:0] == rsEX[$clog2(SIZE)-1:0])
                           1'b1: begin
                                   case (ALUcontrol[3:0])
                                     4'b0010: begin
                                               ALUresult[SIZE-1:0] <= data [SIZE-1:0] + data [SIZE-1:0];   //add
                                              end
                                     4'b0000: ALUresult[SIZE-1:0] <= data [SIZE-1:0] & data [SIZE-1:0];   //and
                                     4'b1000: ALUresult[SIZE-1:0] <= ~(data [SIZE-1:0] | data [SIZE-1:0]); //nor
                                     4'b0001: ALUresult[SIZE-1:0] <= (data [SIZE-1:0] | data [SIZE-1:0]); //or
                                     4'b0111: begin //Here we represent both readData1 and readData2 as two's complement negative numbers
                                                 case (data[SIZE-1]) //The most significant bit determines the sign of the number
                                                   1'b1: begin //If readData1 is negative
                                                           case (data[SIZE-1])
                                                             1'b0: begin //If readData2 is positive, then represent it as negative and then compare
                                                                     ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0001; //Always 1 in this case!!!
                                                                   end
                                                             1'b1: begin //If readData2 is also negative, then just compare them
                                                                     ALUresult[SIZE-1:0] <= (data [SIZE-1:0] < data [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                   end
                                                           endcase
                                                         end
                                                   1'b0: begin //If readData1 is positive
                                                           case (data[SIZE-1]) //Should always compare with the sign respective of the left operandEX???
                                                             1'b1: begin // And readData2 is negative, then take complement of readData2 and then compare
                                                                     ALUresult[SIZE-1:0] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Always 0 in this case!
                                                                   end
                                                             1'b0: begin // And readData2 is positive, then just compare the two
                                                                     ALUresult[SIZE-1:0] <= (data [SIZE-1:0] < data [SIZE-1:0]) ? 1 : 0 ; //slt
                                                                   end
                                                           endcase
                                                         end
                                                 endcase
                                              end //These would have been the shift left register and shift right register functions, but through random code generation they failed...
                                     4'b0110: begin
                                                ALUresult[SIZE-1:0] <= (data [SIZE-1:0] - data [SIZE-1:0]); //sub
                                              end
                                     default: ALUresult[SIZE-1:0] <= 32'b0; //Do Nothing
                                   endcase
                                 end
                           1'b0: ;
                         endcase
                       end
                 1'b0: ; //Do nothing
               endcase


               case (controlEX[9] && (ALUresult[SIZE-1:0] != 32'b0) && controlEX[5:3] == 3'b010) //The registers are not equal and it is a branch not equal
                 1'b1: begin
                        $display("ReadData1 : %h and ReadData2: %h and ALUresult: %h",readData1[SIZE-1:0],readData2[SIZE-1:0],readData1[SIZE-1:0]-readData2[SIZE-1:0]);
                        ALUresult[SIZE-1:0] <= PC4EX[SIZE-1:0] + PCoffset[SIZE-1:0]; //PC4 + offset
                       end
                 1'b0: ;
               endcase

            end
    endcase
  end
endmodule
