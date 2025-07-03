
/* Neuronal Network: 4-275 */
module ALU (
    input wire [7:0] in_a,
    input wire [7:0] in_b,
    input wire [3:0] mode,
    input wire ee, eo,

    output wire [7:0] out,
    output reg flag_zero = 0,
    output reg flag_carry = 0
);

    reg [7:0] r_out = 8'b0;
    reg temp_carry = 1'b0;

    assign out = eo ? r_out : 8'bz;

    wire[7:0] out_hi;
    wire[7:0] out_lo;
    wire carry;
    mul mul0(
        .in_a(in_a),
        .in_b(in_b),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .carry(carry)
    );

    wire[7:0] out_sqrt;
    sqrt sqrt0(
        .in(in_a),
        .out(out_sqrt)
    );

    always @(*) begin
        if (ee) begin
            case (mode)
                4'b0000: {flag_carry, r_out} <= in_a + in_b;                 // ALU_ADD
                4'b0001: {flag_carry, r_out} <= in_a + in_b + flag_carry;    // ALU_ADC
                4'b0010: {flag_carry, r_out} <= in_a - in_b - (~flag_carry); // ALU_SUB
                4'b0011: {flag_carry, r_out} <= in_a + 1'b1;                 // ALU_INC
                4'b0100: {flag_carry, r_out} <= {1'b0, in_a} - 1'b1;         // ALU_DEC
                4'b0101: {flag_carry, r_out} <= {1'b0, in_a & in_b};         // ALU_AND
                4'b0110: {flag_carry, r_out} <= {1'b0, in_a | in_b};         // ALU_OR
                4'b0111: {flag_carry, r_out} <= {1'b0, in_a ^ in_b};         // ALU_XOR

                // Erweiterungen
                4'b1000: {flag_carry, r_out} <= {1'b0, in_a << in_b};                           // ALU_SHL
                4'b1001: {flag_carry, r_out} <= {1'b0, in_a >> in_b};                           // ALU_SHR
                4'b1010: {flag_carry, r_out} <= {1'b0, in_a[6:0],in_a[7]};  // ALU_ROL fixed: rotate left by 1
                4'b1011: {flag_carry, r_out} <= {1'b0, in_a[0], in_a[7:1]};  // ALU_ROR TODO: Check for correctness
                4'b1100: {flag_carry, r_out} <= {1'b0, ~in_a};                          // ALU_NOT

                4'b1101: {flag_carry, r_out} <= {carry, out_lo};  // ALU_MLO
                4'b1110: {flag_carry, r_out} <= {carry, out_hi};  // ALU_MHI
                4'b1111: {flag_carry, r_out} <= {1'b0, out_sqrt}; // ALU_SQRT
            endcase

            // flag_zero checks, whether last execution returned 0
            flag_zero <= r_out == 8'b0;
            // ALU_ADC
            temp_carry <= flag_carry;
        end
    end

    
endmodule
