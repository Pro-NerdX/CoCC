
module top_level ();
(
	reg clk = 0,
	reg opcode = 8'h00,
	reg reset = 1'b0,
	wire[7:0] state

	always #1 clk = ~clk; // Toggle clock every 1 time units

);
endmodule