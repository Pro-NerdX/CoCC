
module clocks(
    input  wire clk,
    input  wire halt,
    input  wire reset,
    output reg  cycle_clock = 0,
    output reg  ram_clock = 0,
    output reg  internal_clock = 0
);

    reg[2:0] cnt = 3'b100;

    always @(posedge clk) begin
        if (~halt & ~reset) begin
            {cycle_clock, ram_clock, internal_clock} <= cnt;
            case (cnt)
                3'b100 : cnt <= 3'b010;
                3'b010 : cnt <= 3'b001;
                3'b001 : cnt <= 3'b100;
            endcase
        end else begin
            {cycle_clock, ram_clock, internal_clock} <= 3'b0;
        end
    end
endmodule
