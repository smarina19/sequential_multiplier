//==============================================================================
// Multiplier Tester Module
//==============================================================================

`include "Multiplier.v"

module MultiplierTester(
	input   clk,
	input   rst,
    input   start,
    input [3:0] multiplierOne,
    input [3:0] multiplicandOne,
    input [3:0] multiplierTwo,
    input [3:0] multiplicandTwo,

    // these outputs assume the public inputs (multiplicand) are held constant
    // between both multipliers through an assumption
    output timingLeak,
    output timingLeakDone
);

// internal wires
wire [8:0] productOne;
wire [8:0] productTwo;
wire productDoneOne;
wire productDoneTwo;

Multiplier multOne(
	.clk(clk),
	.rst(rst),
    .start(start),
    .multiplier(multiplierOne),
    .multiplicand(multiplicandOne),
	.product(productOne),
    .productDone(productDoneOne)
);

Multiplier multTwo(
    .clk(clk),
	.rst(rst),
    .start(start),
    .multiplier(multiplierTwo),
    .multiplicand(multiplicandTwo),
	.product(productTwo),
    .productDone(productDoneTwo)
);

assign timingLeakDone = productDoneOne || productDoneTwo;
assign timingLeak = ~(productDoneOne && productDoneTwo);

endmodule