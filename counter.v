
module tristate_buffer (
    input wire oe,
    input wire[7:0] in,
    output wire[7:0] out
);
    assign out = oe ? in : 8'bz;
endmodule



module counter (
    input wire clk,
    output wire [7:0] out,
    input wire down,
    input wire reset,
    input wire set,
    input wire [7:0] in,
    
    input wire oe
);
    reg [7:0] r_out = 8'b0;

    tristate_buffer tb(
        .oe(oe),
        .in(r_out),
        .out(out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_out <= 8'b0;
        end else if (set) begin
            r_out <= in;
        end else if (down) begin
            r_out <= counter - 1'b1;
        end else begin
            r_out <= counter + 1'b1;
        end
    end
endmodule
