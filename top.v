`default_nettype none

// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input PIN_CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    output USBPU,  // USB pull-up resistor

    output PIN_14,
    output PIN_15,
    output PIN_16,
    output PIN_17,
    output PIN_18
    );


    // To change output mode, only these parameters and the PLL need to be changed.
    // PLL output should be set to the pixel clock
    // See also http://tinyvga.com/vga-timing
    localparam SCREEN_WIDTH = 640;
    localparam LINE_LENGTH = 800;
    localparam H_SYNC_START = SCREEN_WIDTH + 16;
    localparam H_SYNC_SIZE = 96;

    localparam SCREEN_HEIGHT= 480;
    localparam NUMBER_LINES = 525;
    localparam V_SYNC_START = SCREEN_HEIGHT + 10;
    localparam V_SYNC_SIZE  = 2;



    wire unused_clk;
    wire CLK;
    top_pll top_pll_inst(.REFERENCECLK(PIN_CLK),
                         .PLLOUTCORE(unused_clk),
                         .PLLOUTGLOBAL(CLK),
                         .RESET(1'b1));

    wire on_screen = (pixel_counter < SCREEN_WIDTH) && (line_counter < SCREEN_HEIGHT);
    assign PIN_14 = red && on_screen;
    assign PIN_15 = green && on_screen;
    assign PIN_16 = blue && on_screen;
    assign PIN_17 = h_sync;
    assign PIN_18 = v_sync;

    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;
    assign LED = 1'b1;

    reg red;
    reg green;
    reg blue;
    reg h_sync = 1'b1;
    reg v_sync = 1'b1;

    reg [15:0] pixel_counter = 0;





    always @ ( posedge CLK ) begin
      pixel_counter <= pixel_counter + 1;
      if (pixel_counter == LINE_LENGTH-1) begin
        pixel_counter <= 0;
      end
    end

    always @ ( posedge CLK ) begin
      if (pixel_counter == H_SYNC_START-1)
        h_sync <= 1'b0;
      if (pixel_counter == (H_SYNC_START+H_SYNC_SIZE)-1)
        h_sync <= 1'b1;
    end

    reg [15:0] line_counter = 0;

    always @ ( posedge CLK ) begin
      if (pixel_counter == LINE_LENGTH-1) begin
        line_counter <= line_counter + 1;
        if (line_counter == 525) begin
          line_counter <= 0;
        end
      end
    end

    always @ ( posedge CLK ) begin
      if (line_counter == (V_SYNC_START))
        v_sync <= 1'b0;
      if (line_counter == (V_SYNC_START+V_SYNC_SIZE))
        v_sync <= 1'b1;
    end

    always @ ( * ) begin
      red = line_counter[0] == 1'b1 && pixel_counter[0] == 1'b1;
      green = line_counter[1] == 1'b1 && pixel_counter[1] == 1'b1;
      blue = line_counter[2] == 1'b1 && pixel_counter[2] == 1'b1;

    end

endmodule
