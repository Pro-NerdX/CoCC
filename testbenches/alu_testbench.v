
module top_level ();
	
	reg reset = 1;
	wire[7:0] oport;

	reg[7:0] a = 8'b10000000;
	reg[7:0] b = 8'b10000000;

	reg[3:0] mode = 4'b1101; // ALU_MLO

	ALU alu_inst (
		.in_a(a), // Example input A
		.in_b(b), // Example input B
		.mode(mode), // ALU_ROL operation
		.ee(1'b1), // Enable execution
		.eo(1'b1), // Output enable
		.out(oport) // Output port
	);

	initial begin
		$monitor("Time: %0t, reset: %b, oport: %b, flag_carry: %b, flag_zero: %b", $time, reset, oport, alu_inst.flag_carry, alu_inst.flag_zero);
		#2 mode = 4'b1110; 					// Change mode to ALU_MHI
		#2 mode = 4'b1111; a = 8'b00000100; // Change mode to ALU_SQRT

		#50 $finish; // Stop simulation after 50 time units
	end

endmodule
