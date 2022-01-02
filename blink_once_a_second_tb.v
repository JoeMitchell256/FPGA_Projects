`timescale 1 ns/10 ps //Waveform will go for 1 nanosecond in 10 picosecond intervals

module blink_once_a_second_tb;
  reg [23:0] b; //Blink register
  wire led;

  blink_once_a_second UUT (.b(b), .led(led));
