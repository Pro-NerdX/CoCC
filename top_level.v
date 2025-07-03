
module top_level ();
    reg clk = 1;
    reg reset = 1;
    wire[7:0] oport;

    always
        #20 clk = ~clk;

    computer pc_mk2(
        .clk(clk),
        .reset(reset),
        .oport(oport)
    );

    // "test_bench"
    always @(pc_mk5.c_halt) begin
        $display(
            "Registers:\nREG_A: %h\nREG_B: %h\nREG_C: %h\nREG_D: %h\nREG_E: %h\nREG_F: %h\nREG_G: %h\nREG_H: %h\n",
            pc_mk2.CPU_Register.registers[0],
            pc_mk2.CPU_Register.registers[1],
            pc_mk2.CPU_Register.registers[2],
            pc_mk2.CPU_Register.registers[3],
            pc_mk2.CPU_Register.registers[4],
            pc_mk2.CPU_Register.registers[5],
            pc_mk2.CPU_Register.registers[6],
            pc_mk2.CPU_Register.registers[7]
        );
    end
endmodule
