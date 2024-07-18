//==============================================================================
// Multiplier Module (runs in constant time for all inputs)
//==============================================================================

`include "MultiplierControl_StateBranch.v"
`include "../MultiplierDatapath.v"

module Multiplier_StateBranch #(parameter WIDTH = 128)(
	input   clk,
	input   rst,
    input   start,
    input [WIDTH - 1:0] multiplier,
    input [WIDTH - 1:0] multiplicand,

	output [2*WIDTH - 1:0] product,
    output productDone
);
	// Declare local connections here
	wire rsload;
	wire rsclear;
	wire rsshr;
	wire mrld;
	wire mdld;
    wire mr0;
    wire mr1;
    wire mr2;
    wire mr3;
    wire [WIDTH - 1:0] multiplierReg;
    wire [WIDTH * 2:0] runningSumReg;
    wire [WIDTH * 2:0] multiplicandReg;

	// Datapath -- check port connections/rename
	MultiplierDatapath #(WIDTH) dpath(
		.clk    (clk),
        .multiplier (multiplier),
        .multiplicand (multiplicand),
        .rsload (rsload),
        .rsclear (rsclear),
        .rsshr (rsshr),
        .mrld (mrld),
        .mdld (mdld),
        .product (product),
        .multiplierReg(multiplierReg),
        .runningSumReg(runningSumReg),
        .multiplicandReg(multiplicandReg)
	);

	// Control
	MultiplierControl_StateBranch #(WIDTH) ctrl(
		.clk  (clk),
		.rst  (rst),
        .start (start),
        .rsload (rsload),
        .rsclear (rsclear),
        .rsshr (rsshr),
        .mrld (mrld),
        .mdld (mdld),
        .multiplierReg(multiplierReg),
        .productDone (productDone)
	);

endmodule
