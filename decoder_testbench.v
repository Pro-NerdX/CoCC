`include "symbols.vh"

module top_level ();
	
	reg[7:0] instr = 8'b00_011_111;

	wire[2:0] operand_1;
	wire[2:0] operand_2;

	wire[7:0] opcode;
	wire[2:0] iaddr;
	wire[2:0] oaddr;
	wire[3:0] alu_mode;

	decoder decoder0(
		.instruction(instr),
		.operand_1(operand_1),
		.operand_2(operand_2),
		.opcode(opcode),
		.iaddr(iaddr),
		.oaddr(oaddr),
		.alu_mode(alu_mode)
	);

	initial begin
		$monitor(
			"Time: %0t, instr: %b, operand1: %b, operand2: %b, opcode: %b, iaddr: %b, oaddr: %b, alu_mode: %b",
			$time,
			instr,
			operand_1,
			operand_2,
			opcode,
			iaddr,
			oaddr,
			alu_mode
		);

		#50 $finish; // Stop simulation after 50 time units
	end

endmodule
