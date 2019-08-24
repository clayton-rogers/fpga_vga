`default_nettype none

// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    output USBPU,  // USB pull-up resistor

    output PIN_14,
    output PIN_15,
    output PIN_16,
    output PIN_17,
    output PIN_18
    );

    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;
    assign LED = 1'b1;

    assign PIN_14 = 1'b0;
    assign PIN_15 = 1'b1;
    assign PIN_16 = 1'b0;
    assign PIN_17 = 1'b1;
    assign PIN_18 = 1'b0;
endmodule
