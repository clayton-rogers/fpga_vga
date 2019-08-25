`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 1 ns / 1 ns


module top_tb ();

reg clk = 1'b0;
always #31 clk = ~clk;

wire LED;
wire USBPU;

wire [4:0] pins;

top t (
    .CLK(clk),    // 16MHz clock
    .LED(LED),   // User/boot LED next to power LED
    .USBPU(USBPU),  // USB pull-up resistor

    .PIN_14(pins[0]),
    .PIN_15(pins[1]),
    .PIN_16(pins[2]),
    .PIN_17(pins[3]),
    .PIN_18(pins[4])
);

initial begin
$dumpfile(`DUMPSTR(`VCD_OUTPUT));
$dumpvars(0, top_tb);

// This is to make the first clock tick at t + 1
// This makes it easier to test modules where you want to verify the iniitial state
#50000000

$display("end of simulation");
$finish;
end


endmodule // top_tb
