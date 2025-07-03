`include "symbols.vh"

module decoder (
    input wire[7:0] instruction,
    
    output wire[2:0] operand_1,
    output wire[2:0] operand_2,
    
    output reg[7:0] opcode,
    output reg[2:0] iaddr,
    output reg[2:0] oaddr,
    output reg[3:0] alu_mode
);
    assign operand_1 = instruction[5:3];
    assign operand_2 = instruction[2:0];

    // Opcode decoder
    always @(*) begin
        casez (instruction)
            `PATTERN_NOP:  opcode <= `OP_NOP;
            `PATTERN_HLT:  opcode <= `OP_HLT;
            `PATTERN_CALL: opcode <= `OP_CALL;
            `PATTERN_RET:  opcode <= `OP_RET;
            `PATTERN_CMP:  opcode <= `OP_CMP;
            `PATTERN_ALU:  opcode <= `OP_ALU;
            `PATTERN_LDI:  opcode <= `OP_LDI;
            `PATTERN_LDX:  opcode <= `OP_LDX;
            `PATTERN_STX:  opcode <= `OP_STX;
            `PATTERN_PUSH: opcode <= `OP_PUSH;
            `PATTERN_POP:  opcode <= `OP_POP;
            `PATTERN_JMP:  opcode <= `OP_JMP;
            `PATTERN_MOV:  opcode <= `OP_MOV;
            default: opcode <= instruction;
        endcase
    end

    // ALU-Mode decoder
    always @(*) begin
        case (opcode)
            `OP_CMP: alu_mode <= `ALU_SUB;
            `OP_ALU: alu_mode <= {operand_1[0], operand_2[2:0]}; // Erweiterung: alu_mode has 4 bits now

            default: alu_mode <= 4'bx;
        endcase
    end

    // iaddr decoder
    always @(*) begin
        case (opcode)
            `OP_MOV:  iaddr <= operand_1;
            `OP_LDI:  iaddr <= operand_2;
            `OP_LDX:  iaddr <= operand_2;
            `OP_ALU:  iaddr <= `REG_A;
            `OP_POP:  iaddr <= operand_2;
            `OP_CALL: iaddr <= `REG_H;

            default: iaddr <= 3'bx; 
        endcase
    end

    // oaddr decoder
    always @(*) begin
        case (opcode)
            `OP_MOV:  oaddr <= operand_2;
            `OP_STX:  oaddr <= operand_2;
            `OP_PUSH: oaddr <= operand_2;
            `OP_CALL: oaddr <= `REG_H;
            
            default: oaddr <= 3'bx;
        endcase
    end
endmodule
