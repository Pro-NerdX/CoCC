`include "symbols.vh"

module control (
    input wire[7:0] state,
    input wire[2:0] operand_1,
    input wire[2:0] operand_2,
    input wire flag_zero,
    input wire flag_carry,

    output wire c_ii, c_ci, c_co, c_cs, c_rfi, c_rfo, c_eo, c_ee, c_mi, c_ro, c_ri, c_so, c_sd, c_si, c_halt,
    // IO-Schnittstelle
    output wire c_go,
    // Dynamische Adressierung
    output wire c_da
);
    // Dynamische Adressierung
    assign c_da = (state == `STATE_SET_MAR);

    // jump allowed
    assign ja = (operand_2 == `JMP_JMP) |
                ((operand_2 == `JMP_JC)  &  flag_carry) |
                ((operand_2 == `JMP_JNC) & ~flag_carry) |
                ((operand_2 == `JMP_JZ)  &  flag_zero)  |
                ((operand_2 == `JMP_JNZ) & ~flag_zero);

    // IR
    assign c_ii = (state == `STATE_FETCH_INST);
    
    // PC
    assign c_ci =   (state == `STATE_FETCH_PC)    |
                    ((state == `STATE_JUMP) & ja) |
                    (state == `STATE_TMP_JUMP)    |
                    (state == `STATE_RET);
    assign c_co =   (state == `STATE_FETCH_PC) |
                    (state == `STATE_STORE_PC);
    assign c_cs =   ((state == `STATE_JUMP) & ja) |
                    (state == `STATE_TMP_JUMP)    |
                    (state == `STATE_RET);

    // CPU-Register
    assign c_rfi =  (state == `STATE_ALU_OUT) |
                    (state == `STATE_SET_REG) |
                    (state == `STATE_MOVE_REG);
    assign c_rfo =  (state == `STATE_SET_MEM) |
                    (state == `STATE_MOVE_REG) |
                    (state == `STATE_STACK_REG) |
                    (state == `STATE_TMP_JUMP) |
                    /* IO-Schnittstelle */
                    (state == `STATE_ROUT_STORE);

    // ALU
    assign c_eo = (state == `STATE_ALU_EXEC);
    assign c_ee = (state == `STATE_ALU_OUT);

    // MAR
    assign c_mi =   (state == `STATE_FETCH_PC) |
                    (state == `STATE_LOAD_ADDR) |
                    (state == `STATE_FETCH_SP);

    // RAM
    assign c_ri =   (state == `STATE_STORE_PC) |
                    (state == `STATE_SET_MEM) |
                    (state == `STATE_STACK_REG);
    assign c_ro =   (state == `STATE_STORE_PC) |
                    (state == `STATE_LOAD_ADDR) |
                    (state == `STATE_SET_REG) |
                    ((state == `STATE_JUMP) & ja) |
                    (state == `STATE_RET) |
                    /* IO-Schnittstelle */
                    (state == `STATE_MOUT_STORE);

    // SP
    assign c_si =   (state == `STATE_STACK_REG) |
                    (state == `STATE_INC_SP) |
                    (state == `STATE_TMP_JUMP);
    assign c_so =   (state == `STATE_FETCH_SP);
    assign c_sd =   (state == `STATE_STACK_REG) |
                    (state == `STATE_TMP_JUMP);

    // System
    assign c_halt = (state == `STATE_HALT);

    // IO-Schnittstelle
    assign c_go =   (state == `STATE_MOUT_STORE) |
                    (state == `STATE_ROUT_STORE);
endmodule
