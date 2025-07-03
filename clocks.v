
module clocks(
    input  wire clk,
    input  wire halt,
    input  wire reset,
    output reg  cycle_clock = 0,
    output reg  ram_clock = 0,
    output reg  internal_clock = 0
);

    reg[2:0] cnt = 'b100;

    always @(posedge clk) begin
    if (~halt & ~reset) begin
        {cycle_clk, ram_clk, internal_clk} <= cnt;
        case (cnt)
        'b100 : cnt <= 'b010;
        'b010 : cnt <= 'b001;
        'b001 : cnt <= 'b100;
        endcase
    end else begin
        {cycle_clk, ram_clk, internal_clk} <= 3'b0;
    end
    end
endmodule
