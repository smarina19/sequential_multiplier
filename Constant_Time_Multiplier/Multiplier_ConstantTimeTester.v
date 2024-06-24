//==============================================================================
// Multiplier Constant time 2 Copy Tester Module
//==============================================================================

`include "Multiplier_ConstantTime.v"

module Mutliplier_ConstantTimeTester #(parameter WIDTH = 4)(
    input   clk,
	input   rst,
    input   start,
    input [WIDTH - 1:0] multiplierone,
    input [WIDTH - 1:0] multiplicandone,
    input [WIDTH - 1:0] multipliertwo,
    input [WIDTH - 1:0] multiplicandtwo,

    output timingLeak,
    output timingLeakDone

);

// internal wires
wire [2 * WIDTH - 1:0] productOne;
wire [2 * WIDTH - 1:0] productTwo;
wire productDoneOne;
wire productDoneTwo;

Multiplier_ConstantTime #(WIDTH) multOne(
	.clk(clk),
	.rst(rst),
    .start(start),
    .multiplier(multiplierOne),
    .multiplicand(multiplicandOne),
	.product(productOne),
    .productDone(productDoneOne)
);

Multiplier_ConstantTime #(WIDTH) multTwo(
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