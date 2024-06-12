//==============================================================================
// Datapath Module for Sequential Multiplier
//==============================================================================

module MultiplierDatapath #(parameter WIDTH = 4)(

    // External Inputs
    input   clk,       // Clock 
    input wire [WIDTH - 1:0] multiplier,
    input wire [WIDTH - 1:0] multiplicand,

    // External Output
    output wire [WIDTH*2 - 1:0] product,

    // Inputs from Controller
    input rsload,
    input rsclear,
    input rsshr,
    input mrld,
    input mdld,

    // Outputs to Controller
    output reg [WIDTH - 1:0] multiplierReg,

    // debug outputs
    output reg [WIDTH*2:0] runningSumReg,
    output reg [WIDTH*2:0] multiplicandReg
);

// Sequential Logic
always @( posedge clk) begin
    
    // init registers
    if (mdld) begin
        multiplicandReg <= multiplicand << WIDTH;
    end
    if (mrld) begin
        multiplierReg <= multiplier;
    end
    if (rsclear) begin
        runningSumReg <= 0;
    end

    // load running sum
    if (rsload) begin
        runningSumReg <= multiplicandReg + runningSumReg; 
    end
    // how do we know what to shift in here for sign?
    if(rsshr) begin
        runningSumReg <= runningSumReg >>> 1; 
    end
end 
    assign product = runningSumReg;

endmodule