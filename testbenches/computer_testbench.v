module top_level ();
	
	reg clk;
	reg reset;
	wire[7:0] oport;

	computer cpu(
		.clk(clk),
		.reset(reset),
		.oport(oport)
	);

    initial clk = 0; // Initialize clock

    always #1 clk = ~clk; // Toggle clock every 1 time units

    initial begin
        $dumpfile("computer.vcd");
        $dumpvars();

        $monitor(
            "Time: %0t, instr: %b, operand1: %b, operand2: %b, opcode: %b, iaddr: %b, oaddr: %b, alu_mode: %b, state: %b",
            $time,
            cpu.instruction,
            cpu.operand_1,
            cpu.operand_2,
            cpu.opcode,
            cpu.iaddr,
            cpu.oaddr,
            cpu.alu_mode,
            cpu.state
        );

        #10000 $finish; // Stop simulation after 50 time units
    end

endmodule

