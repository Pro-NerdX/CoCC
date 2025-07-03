`include "symbols.vh"

module computer (
    input wire clk,
    input wire reset,
    // IO-Schnittstelle
    output[7:0] oport
);

    wire[7:0] data_bus;
    assign data_bus = 8'bz;
    wire internal_clk;
    wire cycle_clk;
    wire ram_clk;
    wire[7:0] instruction;
    wire c_ii;

    wire c_halt;
    clocks clocks0(
        .clk(clk),
        .halt(c_halt),

        .cycle_clock(cycle_clk),
        .ram_clock(ram_clk),
        .internal_clock(internal_clk)
    );
    
    // Instruction Register
    register IR(
        .clk(internal_clk),
        .en(c_ii),
        .in(data_bus),
        .out(instruction)
    );

    wire[7:0] addr_bus;
    wire c_mi;

    // Memory Address Register
    register MAR(
        .clk(internal_clk),
        .en(c_mi),
        .in(data_bus),
        .out(addr_bus)
    );

    wire c_ci, c_co, c_cs;

    // Program Counter
    counter PC(
        .clk(c_ci & internal_clk),
        .out(data_bus),
        .down(1'b0),
        .reset(reset),
        .set(c_cs),
        .in(data_bus),

        .oe(c_co)
    );

    wire c_si, c_so, c_sd;

    // Stack Pointer
    counter SP(
        .clk(reset | (c_si & internal_clk)),
        .out(data_bus),
        .down(c_sd),
        .reset(1'b0),
        .set(reset),
        .in(8'hFF),

        .oe(c_so)
    );

    wire[2:0] operand_1;
    wire[2:0] operand_2;
    wire[7:0] opcode;
    wire[2:0] iaddr;
    wire[2:0] oaddr;
    wire[3:0] alu_mode;

    // Decoder
    decoder Decoder(
        .instruction(instruction),

        .operand_1(operand_1),
        .operand_2(operand_2),

        .opcode(opcode),
        .iaddr(iaddr),
        .oaddr(oaddr),
        .alu_mode(alu_mode),

        .c_da(c_da)
    );

    wire[7:0] state = `STATE_NEXT;

    // Finite State Machine
    FSM FSM0(
        .clk(cycle_clk),

        .opcode(opcode),
        .reset(reset),

        .state(state)
    );

    wire c_ro, c_ri;

    // RAM
    RAM RAM0(
        .clk(ram_clk),

        .data_bus(data_bus),

        .we(c_ri),
        .oe(c_ro),
        .addr(addr_bus)
    );

    wire c_rfi, c_rfo;
    wire[7:0] reg_a;
    wire[7:0] reg_b;

    // CPU-Register
    regblock CPU_Register(
        .clk(internal_clk),
        .idata(data_bus),
        .odata(data_bus),

        .we(c_rfi),
        .oe(c_rfo),
        .oaddr(oaddr),
        .iaddr(iaddr),

        .rega(reg_a),
        .regb(reg_b)
    );

    wire c_go, c_da;

    // Signal-Controller
    control Signal_Controller(
        .state(),
        .operand_1(),
        .operand_2(),
        .flag_zero(),
        .flag_carry(),

        .c_ii(c_ii), .c_ci(c_ci), .c_co(c_co), .c_cs(c_cs), .c_rfi(c_rfi), .c_rfo(c_rfo), .c_eo(c_eo), .c_ee(c_ee), .c_mi(c_mi), .c_ro(c_ro), .c_ri(c_ri), .c_so(c_so), .c_sd(c_sd), .c_si(c_si), .c_halt(c_halt),
        // IO-Schnittstelle
        .c_go(c_go),
        // Dynamische Adressierung
        .c_da(c_da)
    );

    // IO-Schnittstelle
    register out0(
        .clk(internal_clk),
        .en(c_go),
        .in(data_bus),
        .out(oport)
    );
endmodule
