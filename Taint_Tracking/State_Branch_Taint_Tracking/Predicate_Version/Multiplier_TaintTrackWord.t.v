//===============================================================================
// Testbench Module for Constant Time state branch Multiplier w/ taint tracking
// some code adapted from ECE206 testing material
//===============================================================================
`timescale 1ns/100ps

`include "Multiplier_TaintTrackWord.v"

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
    parameter NUM_BITS = 7;

	// Local Vars
	reg clk = 0;
	reg rst = 0;
	reg start = 0;
	reg [NUM_BITS - 1:0] multiplier = 7'd0;
	reg [NUM_BITS - 1:0] multiplicand = 7'd0;
    wire [2 * NUM_BITS - 1:0] product;
    reg start_t = 0;
    reg multiplier_t = 0;
    reg multiplicand_t = 0;

	// Error Counts
	reg [7:0] errors = 0;

	// VCD Dump
	initial begin
		$dumpfile("MultiplierTest.vcd");
		$dumpvars;
	end

	// Multiplier Module
	Multiplier_TaintTrackWord #(NUM_BITS) multipliertester(
        .clk    (clk),
		.rst    (rst),
        .start  (start),
        .multiplier (multiplier),
        .multiplicand (multiplicand),
        .product (product),
        .start_t (start_t),
        .multiplier_t (multiplier_t),
        .multiplicand_t (multiplicand_t)
	);

    integer i;
	// Main Test Logic
	initial begin
        // 0110 x 0011
        /*
        `SET(multiplier, 4'b0011)
        `SET(multiplicand, 4'b0110)

		// Reset the multiplier
		`SET(rst, 1);
		`CLOCK;

		// START State
		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        // INIT State - should take at most 10 clock cycles to get back to START
        `SET(start, 0);
        for (i = 0; i < 10; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 8'b00010010, "Product is incorrect");
        */

        // 15 x 15
        `SET(multiplier, 15)
        `SET(multiplicand, 15)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 100; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 225, "Product is incorrect");
        $display("%b", product);

        // 0 x 12
        `SET(multiplier, 0)
        `SET(multiplicand, 12)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 10; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 0, "Product is incorrect");

        // 1 x 2
        `SET(multiplier, 1)
        `SET(multiplicand, 2)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 100; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 2, "Product is incorrect");
        $display("%b", product);

        // 0 x 0 
        `SET(multiplier, 0)
        `SET(multiplicand, 0)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 100; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 0, "Product is incorrect");

        // 92 * 75
        `SET(multiplier, 92)
        `SET(multiplicand, 75)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 100; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 6900, "Product is incorrect");

        // 42 * 78
        `SET(multiplier, 42)
        `SET(multiplicand, 78)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 100; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 3276, "Product is incorrect");


		$display("\nTESTS COMPLETED (%d FAILURES)", errors);
		$finish;
	end

endmodule
