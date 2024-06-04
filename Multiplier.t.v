//===============================================================================
// Testbench Module for Multiplier
//===============================================================================
`timescale 1ns/100ps

`include "Multiplier.v"

`define ASSERT_EQ(ONE, TWO, MSG)               \
	begin                                      \
		if ((ONE) !== (TWO)) begin             \
			$display("\t[FAILURE]:%s", (MSG)); \
			errors = errors + 1;               \
		end                                    \
	end #0

`define SET(VAR, VALUE) $display("Setting %s to %s...", "VAR", "VALUE"); #1; VAR = (VALUE); #1

`define CLOCK $display("Pressing uclk..."); #1; clk = 1; #1; clk = 0; #1

`define SHOW_STATE(STATE) $display("\nEntering State: %s\n-----------------------------------", STATE)

module MultiplierTest;

	// Local Vars
	reg clk = 0;
	reg rst = 0;
	reg start = 0;
	reg [3:0] multiplier = 4'd0;
	reg [3:0] multiplicand = 4'd0;
    wire [7:0] product;

	// Error Counts
	reg [7:0] errors = 0;

	// VCD Dump
	initial begin
		$dumpfile("MultiplierTest.vcd");
		$dumpvars;
	end

	// Multiplier Module
	Multiplier multipliertester(
        .clk    (clk),
		.rst    (rst),
        .start  (start),
        .multiplier (multiplier),
        .multiplicand (multiplicand),
        .product (product)
	);

	// Main Test Logic
	initial begin
        // 0110 x 0011
        `SET(multiplier, 4'b0110)
        `SET(multiplicand, 4'b0011)

		// Reset the multiplier
		`SET(rst, 1);
		`CLOCK;

		// START State
		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        // INIT State - should take at most 10 clock cycles to get back to START
        `SET(start, 0);
		`CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `CLOCK;
        `ASSERT_EQ(product, 8'b00010010, "Product is incorrect");
		$display("\nTESTS COMPLETED (%d FAILURES)", errors);
		$finish;
	end

endmodule
