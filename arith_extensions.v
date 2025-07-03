
module sqrt (
    input[7:0] in,
    output[7:0] out
);
    reg[3:0] temp = 4'b0001;

    always @(*) begin
        if ((temp * temp) == in) begin
            out <= temp;
        end else begin
            if (temp == 4'b1111) begin
                out <= 4'bzzzz;
            end else begin
                temp <= temp + 1'b1;
            end
        end
    end
endmodule

module mul (
    input[7:0] in_1,
    input[7:0] in_2,

    output[7:0] out_hi,
    output[7:0] out_lo,

    output carry
);
    wire[15:0] res;

    assign res = in_1 * in_2;
    assign {carry, out_hi, out_lo} = {|res[15:8], res[15:8], res[7:0]};
endmodule
