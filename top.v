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

    assign PIN_14 = red;
    assign PIN_15 = green;
    assign PIN_16 = blue;
    assign PIN_17 = h_sync;
    assign PIN_18 = v_sync;

    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;
    assign LED = 1'b1;

    reg red = 1'b0;
    reg green = 1'b0;
    reg blue = 1'b0;
    reg h_sync = 1'b1;
    reg v_sync = 1'b1;

    reg [15:0] pixel_counter = 0;

    always @ ( posedge CLK ) begin
      pixel_counter <= pixel_counter + 1;
      if (pixel_counter == 454) begin
        pixel_counter <= 0;
      end
    end

    always @ ( posedge CLK ) begin
      if (pixel_counter == 366)
        h_sync <= 1'b0;
      if (pixel_counter == 398)
        h_sync <= 1'b1;
    end

    reg [15:0] line_counter = 0;

    always @ ( posedge CLK ) begin
      if (pixel_counter == 454) begin
        line_counter <= line_counter + 1;
        if (line_counter == 625) begin
          line_counter <= 0;
        end
      end
    end

    always @ ( posedge CLK ) begin
      if (line_counter == 601)
        v_sync <= 1'b0;
      if (line_counter == 603)
        v_sync <= 1'b1;
    end

endmodule
