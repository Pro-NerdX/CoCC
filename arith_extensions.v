
module sqrt (
    input  wire[7:0] in,
    output wire[7:0] out
);
    assign out =
        (in >= (15 * 15)) ? 15 :
        (in >= (14 * 14)) ? 14 :
        (in >= (13 * 13)) ? 13 :
        (in >= (12 * 12)) ? 12 :
        (in >= (11 * 11)) ? 11 :
        (in >= (10 * 10)) ? 10 :
        (in >= (9  *  9)) ? 9  :
        (in >= (8  *  8)) ? 8  :
        (in >= (7  *  7)) ? 7  :
        (in >= (6  *  6)) ? 6  :
        (in >= (5  *  5)) ? 5  :
        (in >= (4  *  4)) ? 4  :
        (in >= (3  *  3)) ? 3  :
        (in >= (2  *  2)) ? 2  :
        (in >= (1  *  1)) ? 1  :
        0;


endmodule

module mul (
    input[7:0] in_a,
    input[7:0] in_b,

    output[7:0] out_hi,
    output[7:0] out_lo,

    output carry
);
    wire[16:0] res;

    assign res = in_a * in_b;
    assign {carry, out_hi, out_lo} = {res[16], res[15:8], res[7:0]};
endmodule
