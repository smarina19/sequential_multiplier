//==============================================================================
// Multiplier Module
//==============================================================================

`include "MultiplierControl.v"
`include "MultiplierDatapath.v"

module Multiplier(
	input   clk,
	input   rst,
    input   start,
    input [3:0] multiplier,
    input [3:0] multiplicand,

	output [7:0] product,
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
    wire [3:0] multiplierReg;
    wire [8:0] runningSumReg;
    wire [8:0] multiplicandReg;

	// Datapath -- check port connections/rename
	MultiplierDatapath dpath(
		.clk    (clk),
        .multiplier (multiplier),
        .multiplicand (multiplicand),
        .rsload (rsload),
        .rsclear (rsclear),
        .rsshr (rsshr),
        .mrld (mrld),
        .mdld (mdld),
        .mr0 (mr0),
        .mr1 (mr1),
        .mr2 (mr2),
        .mr3 (mr3),
        .product (product),
        .multiplierReg(multiplierReg),
        .runningSumReg(runningSumReg),
        .multiplicandReg(multiplicandReg)
	);

	// Control
	MultiplierControl ctrl(
		.clk  (clk),
		.rst  (rst),
        .start (start),
        .rsload (rsload),
        .rsclear (rsclear),
        .rsshr (rsshr),
        .mrld (mrld),
        .mdld (mdld),
        .mr0 (mr0),
        .mr1 (mr1),
        .mr2 (mr2),
        .mr3 (mr3),
        .productDone (productDone)
	);

endmodule
