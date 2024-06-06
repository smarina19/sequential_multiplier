//===============================================================================
// Testbench Module for Multiplier
// some code adapted from ECE206 testing material
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
    wire [8:0] product;

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

    integer i;
	// Main Test Logic
	initial begin
        // 0110 x 0011
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

        // 15 x 15
        `SET(multiplier, 4'd15)
        `SET(multiplicand, 4'd15)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 10; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 8'd225, "Product is incorrect");

        // 0 x 12
        `SET(multiplier, 4'd0)
        `SET(multiplicand, 4'd12)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 10; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 8'd0, "Product is incorrect");

        // 1 x 2
        `SET(multiplier, 4'd1)
        `SET(multiplicand, 4'd2)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 10; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 8'd2, "Product is incorrect");

        // 0 x 0 
        `SET(multiplier, 4'd0)
        `SET(multiplicand, 4'd0)

		`SET(rst, 1);
		`CLOCK;

		`SET(rst, 0);
        `SET(start, 1);
        `CLOCK;

        `SET(start, 0);

        for (i = 0; i < 10; i = i + 1) begin
            `CLOCK;
        end
        `ASSERT_EQ(product, 8'd0, "Product is incorrect");

		$display("\nTESTS COMPLETED (%d FAILURES)", errors);
		$finish;
	end

endmodule
