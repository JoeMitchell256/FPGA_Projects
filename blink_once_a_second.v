//This Program will blink the on board LED of the TinyFPGA BX board at 1 Hz!
// look in pins.pcf for all the pin names on the TinyFPGA BX board
module blink_once_a_second (
    input CLK,    // 16MHz clock ***** Important!!!
    output LED,   // User/boot LED next to power LED
    output USBPU,  // USB pull-up resistor
    output [23:0] BLINK_REG // The Blink register
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    ////////
    // make a simple blink circuit
    ////////

    // keep track of time and location in blink_pattern
    reg [23:0] blink;//Set the blink register to have 24 bits
    //The clock frequency for the TinyFPGA BX is 16MHz
    //16MHz = 16,000,000 clock cycles per second
    //This also means that at each rising edge of our clock counts as 1 clock cycle
    //So 2^24 - 1 = 16,777,215
    //This means that the most significant bit in our blink register is a good target to
    //  properly determine our blink frequency!

    wire pattern = blink[23];
    wire [23:0] blinkr = blink;

    //Now, can we make our design even more accurate by reseting the bink back to 0
    //  upon equaling 24'b111101000010010000000000
    // increment the blink_counter every clock
    always @(posedge CLK) begin
        blink <= blink + 1;
        if (blink == 24'b111101000010010000000000)
          blink <= 24'b0; //Reset blink to 0 if it has reached 16 million clock cycles!
    end

    // light up the LED according to the most significant bit in bink register!
    assign LED = pattern;
    assign BLINK_REG = blinkr; // BLINK_REG should have the contents of blinkr
endmodule


//We can design a new module right here!
//Lets design a d flip-flop!
/*
module d_flip_flop (d,clk,q);
    input d;
    input clk;
    output q;
    always @(posedge clk) begin
      q <= d;
    end
    assign q = d;
endmodule
*/
