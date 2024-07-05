//==============================================================================
// Multiplier Module (runs in constant time for all inputs, with state branch)
//==============================================================================

`include "MultiplierControl_TaintTrackWord.v"
`include "../MultiplierDatapath_TaintTrack1Bit.v"

module Multiplier_TaintTrackWord #(parameter WIDTH = 4096)(
	input   clk,
	input   rst,
    input   start,
    input   start_t,
    input [WIDTH - 1:0] multiplier,
    input multiplier_t,
    input [WIDTH - 1:0] multiplicand,
    input multiplicand_t,

	output [2*WIDTH - 1:0] product,
    output product_t,
    output productDone,
    output productDone_t
);

	wire rsload;
    wire rsload_t;
	wire rsclear;
    wire rsclear_t;
	wire rsshr;
    wire rsshr_t;
	wire mrld;
    wire mrld_t;
	wire mdld;
    wire mdld_t;
    wire [WIDTH - 1:0] multiplierReg;
    wire multiplierReg_t;
    wire [WIDTH * 2:0] runningSumReg;
    wire runningSumReg_t;
    wire [WIDTH * 2:0] multiplicandReg;
    wire  multiplicandReg_t;

	MultiplierDatapath_TaintTrack1Bit #(WIDTH) dpath(
		.clk    (clk),
        .multiplier (multiplier),
        .multiplier_t (multiplier_t),
        .multiplicand (multiplicand),
        .multiplicand_t (multiplicand_t),
        .rsload (rsload),
        .rsload_t (rsload_t),
        .rsclear (rsclear),
        .rsclear_t (rsclear_t),
        .rsshr (rsshr),
        .rsshr_t (rsshr_t),
        .mrld (mrld),
        .mrld_t (mrld_t),
        .mdld (mdld),
        .mdld_t (mdld_t),
        .product (product),
        .product_t (product_t),
        .multiplierReg (multiplierReg),
        .multiplierReg_t (multiplierReg_t),
        .runningSumReg (runningSumReg),
        .runningSumReg_t (runningSumReg_t),
        .multiplicandReg (multiplicandReg),
        .multiplicandReg_t (multiplicandReg_t)
	);

	// Control
	MultiplierControl_TaintTrackWord #(WIDTH) ctrl(
		.clk  (clk),
		.rst  (rst),
        .start (start),
        .start_t (start_t),
        .rsload (rsload),
        .rsload_t (rsload_t),
        .rsclear (rsclear),
        .rsclear_t (rsclear_t),
        .rsshr (rsshr),
        .rsshr_t (rsshr_t),
        .mrld (mrld),
        .mrld_t (mrld_t),
        .mdld (mdld),
        .mdld_t (mdld_t),
        .multiplierReg (multiplierReg),
        .multiplierReg_t (multiplierReg_t),
        .productDone (productDone),
        .productDone_t (productDone_t)
	);

endmodule
