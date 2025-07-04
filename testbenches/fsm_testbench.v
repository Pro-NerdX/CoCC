
module top_level ();
(
	reg clk = 0,
	reg opcode = 8'b00000000, // Example opcode
	reg reset = 1'b0,
	wire[7:0] state;

	always #1 clk = ~clk; // Toggle clock every 1 time units

	FSM fsm_inst (
		.clk(clk),
		.opcode(opcode),
		.reset(reset),
		.state(state)
	);
	RAM ram_inst (
		.clk(clk),
		.reset(reset),
		.state(state),
		.opcode(opcode)
);

	initial begin
		// Initialize the reset signal
		reset = 1'b1;
		#5; // Wait for 5 time units
		reset = 1'b0; // Deassert reset

		// Example test case: Set opcode and observe state changes
		#5opcode = 8'b00000001; // Example opcode for MOV
		#10; // Wait for some time to observe state changes
		opcode = 8'b00000010; // Change opcode to another instruction
		#10; // Wait again to observe changes
	end
endmodule