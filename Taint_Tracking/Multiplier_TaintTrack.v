//==============================================================================
// Multiplier Module with Taint Tracking
//==============================================================================

`include "MultiplierControl_TaintTrack.v"
`include "MultiplierDatapath_TaintTrack.v"

module Multiplier_TaintTrack #(parameter WIDTH = 4)(
	input   clk,
	input   rst,
    input   start,
    input   start_t,
    input [WIDTH - 1:0] multiplier,
    input [WIDTH - 1:0] multiplier_t,
    input [WIDTH - 1:0] multiplicand,
    input [WIDTH - 1:0] multiplicand_t,

	output [2*WIDTH - 1:0] product,
    output [2*WIDTH - 1:0] product_t,
    output productDone,
    output productDone_t
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
	MultiplierDatapath_TaintTrack #(WIDTH) dpath(
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
	MultiplierControl_TaintTrack #(WIDTH) ctrl(
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
