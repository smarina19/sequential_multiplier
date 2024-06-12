//==============================================================================
// Multiplier Tester Module
//==============================================================================

`include "Multiplier.v"

module MultiplierTester #(parameter WIDTH = 4)(
	input   clk,
	input   rst,
    input   start,
    input [WIDTH - 1:0] multiplierOne,
    input [WIDTH - 1:0] multiplicandOne,
    input [WIDTH - 1:0] multiplierTwo,
    input [WIDTH - 1:0] multiplicandTwo,

    // these outputs assume the public inputs (multiplicand) are held constant
    // between both multipliers through an assumption
    output timingLeak,
    output timingLeakDone
);

// internal wires
wire [2 * WIDTH - 1:0] productOne;
wire [2 * WIDTH - 1:0] productTwo;
wire productDoneOne;
wire productDoneTwo;

Multiplier #(WIDTH) multOne(
	.clk(clk),
	.rst(rst),
    .start(start),
    .multiplier(multiplierOne),
    .multiplicand(multiplicandOne),
	.product(productOne),
    .productDone(productDoneOne)
);

Multiplier #(WIDTH) multTwo(
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