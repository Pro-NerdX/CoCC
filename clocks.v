
module clocks (
    input wire clk,
    input wire halt,

    output reg cycle_clock = 0,
    output reg ram_clock = 0,
    output reg internal_clock = 0
);
    /* MAJOR CHANGE: Changed to 2-bit reg! */
    reg[1:0] cnt = 2'b00;

    /* MAJOR CHANGE: See upper major change! */
    always @(posedge clk) begin
        cycle_clock <=      halt ? cycle_clock    : (cnt == 2'b00);
        ram_clock   <=      halt ? ram_clock      : (cnt == 2'b01);
        internal_clock <= halt ? internal_clock   : (cnt == 2'b10);

        case (cnt)
            2'b00: cnt <= 2'b01;
            2'b01: cnt <= 2'b10;
            2'b10: cnt <= 2'b00;
            default: cnt <= 2'b00;
        endcase
    end
endmodule
