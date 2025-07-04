`include "symbols.vh"

module FSM (
    input clk,
    
    input[7:0] opcode,
    input reset,

    output reg[7:0] state = `STATE_NEXT
);
    assign reset_cycle = (state == `STATE_NEXT);
    reg[3:0] cycle;

    always @(negedge clk) begin
        if (reset_cycle) begin
            cycle <= 4'b0;
        end else begin
            cycle <= cycle + 1'b1;
        end
    end

    always @(posedge clk) begin
        case (cycle)
            `T0: state <= `STATE_FETCH_PC;
            `T1: state <= `STATE_FETCH_INST;

            `T2: case (opcode)
                `OP_HLT:  state <= `STATE_HALT;
                `OP_NOP:  state <= `STATE_NEXT;
                `OP_MOV:  state <= `STATE_MOVE_REG;
                `OP_LDI:  state <= `STATE_FETCH_PC;
                `OP_LDX:  state <= `STATE_FETCH_PC;
                `OP_STX:  state <= `STATE_FETCH_PC;
                `OP_CMP:  state <= `STATE_ALU_EXEC;
                `OP_ALU:  state <= `STATE_ALU_EXEC;
                `OP_PUSH: state <= `STATE_FETCH_SP;
                `OP_POP:  state <= `STATE_INC_SP;
                `OP_JMP:  state <= `STATE_FETCH_PC;
                `OP_CALL: state <= `STATE_FETCH_PC;
                `OP_RET:  state <= `STATE_INC_SP;
                // IO-Schnittstelle
                `OP_MOUT: state <= `STATE_FETCH_PC;
                `OP_ROUT: state <= `STATE_ROUT_STORE;
                // Dynamische Adressierung
                `OP_LDA:  state <= `STATE_SET_MAR;
                `OP_STA:  state <= `STATE_SET_MAR;

                default: state <= `STATE_NEXT;
            endcase

            `T3: case (opcode)
                `OP_MOV:  state <= `STATE_NEXT;
                `OP_LDI:  state <= `STATE_SET_REG;
                `OP_LDX:  state <= `STATE_LOAD_ADDR;
                `OP_STX:  state <= `STATE_LOAD_ADDR;
                `OP_CMP:  state <= `STATE_NEXT;
                `OP_ALU:  state <= `STATE_ALU_OUT;
                `OP_PUSH: state <= `STATE_STACK_REG;
                `OP_POP:  state <= `STATE_FETCH_SP;
                `OP_JMP:  state <= `STATE_JUMP;
                `OP_CALL: state <= `STATE_SET_REG;
                `OP_RET:  state <= `STATE_FETCH_SP;
                // IO-Schnittstelle
                `OP_MOUT: state <= `STATE_LOAD_ADDR;
                // Dynamische Adressierung
                `OP_LDA:  state <= `STATE_SET_REG;
                `OP_STA:  state <= `STATE_SET_MEM;

                default: state <= `STATE_NEXT;
            endcase

            `T4: case (opcode)
                `OP_LDI:  state <= `STATE_NEXT;
                `OP_LDX:  state <= `STATE_SET_REG;
                `OP_STX:  state <= `STATE_SET_MEM;

                `OP_ALU:  state <= `STATE_NEXT;
                `OP_PUSH: state <= `STATE_NEXT;
                `OP_POP:  state <= `STATE_SET_REG;
                `OP_JMP:  state <= `STATE_NEXT;
                `OP_CALL: state <= `STATE_FETCH_PC;
                `OP_RET:  state <= `STATE_RET;
                // IO-Schnittstelle
                `OP_MOUT: state <= `STATE_MOUT_STORE;
                // Dynamische Adressierung
                `OP_LDA:  state <= `STATE_NEXT;
                `OP_STA:  state <= `STATE_NEXT;

                default: state <= `STATE_NEXT;
            endcase

            `T5: case (opcode)
                `OP_LDX: state <= `STATE_NEXT;
                `OP_STX: state <= `STATE_NEXT;

                `OP_POP: state <= `STATE_NEXT;

                `OP_CALL: state <= `STATE_STORE_PC;
                `OP_RET: state <= `STATE_NEXT;

                default: state <= `STATE_NEXT;
            endcase

            `T6: state <= `STATE_TMP_JUMP;
            `T7: state <= `STATE_NEXT;
        endcase
    end

endmodule
