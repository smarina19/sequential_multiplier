//==============================================================================
// Multiplier Tester Module
//==============================================================================

`include "Multiplier.v"

module MultiplierTester #(parameter WIDTH = 1024)(
	input   clk,
	input   rst,
    input   start,
    input [WIDTH - 1:0] multiplierOne,
    input [WIDTH - 1:0] multiplicandOne,
    input [WIDTH - 1:0] multiplierTwo,
    input [WIDTH - 1:0] multiplicandTwo,
    input [WIDTH - 1:0] multiplierThree,
    input [WIDTH - 1:0] multiplicandThree,
    input [WIDTH - 1:0] multiplierFour,
    input [WIDTH - 1:0] multiplicandFour,

    // these outputs assume the public inputs (multiplicand) are held constant
    // between both multipliers through an assumption
    output timingLeak,
    output timingLeakDone,

    output commutativeProp,
    output assocProp
);

// internal wires
wire [2 * WIDTH - 1:0] productOne;
wire [2 * WIDTH - 1:0] productTwo;
wire [2 * WIDTH - 1:0] productThree;
wire [2 * WIDTH - 1:0] productFour;
wire productDoneOne;
wire productDoneTwo;
wire productDoneThree;
wire productDoneFour;



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

Multiplier #(WIDTH) multThree(
    .clk(clk),
	.rst(rst),
    .start(start),
    .multiplier(multiplierThree),
    .multiplicand(multiplicandThree),
	.product(productThree),
    .productDone(productDoneThree)
);

Multiplier #(WIDTH) multFour(
    .clk(clk),
	.rst(rst),
    .start(start),
    .multiplier(multiplierFour),
    .multiplicand(multiplicandFour),
	.product(productFour),
    .productDone(productDoneFour)
);

assign oneDone = productDoneOne || productDoneTwo;
assign bothDone = productDoneOne && productDoneTwo;

// assign commutativeProp = ~(productOne & productTwo);
// assign assocProp = ~(productTwo & productFour);


endmodule
