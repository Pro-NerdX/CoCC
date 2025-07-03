
module top_level;

	reg clk = 0;
	wire [7:0] out;
	reg down = 1'b0;
	reg reset = 1'b0;
	reg set = 1'b0;
	reg [7:0] in = 8'b0;
	reg oe = 1'b1;

	always #1 clk = ~clk; // Toggle clock every 1 time unit

	counter count (
		.clk(clk),
		.out(out),
		.down(down),
		.reset(reset),
		.set(set),
		.in(in),
		.oe(oe)
	);
	initial begin

		$monitor("Time: %0t, clk: %b, out: %b, down: %b, reset: %b, set: %b, in: %b, oe: %b",
			$time, clk, out, down, reset, set, in, oe);

		// Test sequence
		#5 reset = 1'b1; // Reset the counter
		#5 reset = 1'b0; // Release reset
		#5 in = 8'hFF; set = 1'b1; // Set counter to FF
		#5 set = 1'b0; // Release set
		#10 down = 1'b1; // Start counting down
		#10 down = 1'b0; // Stop counting down
		#5 $finish; // End simulation
	end
endmodule