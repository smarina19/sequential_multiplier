//==============================================================================
// Datapath Module for Sequential Multiplier
//==============================================================================

module MultiplierDatapath_TaintTrack1Bit #(parameter WIDTH = 1024)(

    // External Inputs
    input   clk,       // Clock 
    input wire [WIDTH - 1:0] multiplier,
    input wire  multiplier_t,
    input wire [WIDTH - 1:0] multiplicand,
    input wire  multiplicand_t,

    // External Output
    output wire [WIDTH*2 - 1:0] product,
    output wire  product_t,

    // Inputs from Controller
    input rsload,
    input rsload_t,
    input rsclear,
    input rsclear_t,
    input rsshr,
    input rsshr_t,
    input mrld,
    input mrld_t,
    input mdld,
    input mdld_t,

    // Outputs to Controller
    output reg [WIDTH - 1:0] multiplierReg,
    output reg  multiplierReg_t,

    // debug outputs
    output reg [WIDTH*2:0] runningSumReg,
    output reg  runningSumReg_t,
    output reg [WIDTH*2:0] multiplicandReg,
    output reg  multiplicandReg_t
);

// Sequential Logic
always @( posedge clk) begin
    
    // init registers
    if (mdld) begin
        multiplicandReg <= multiplicand << WIDTH;
        multiplicandReg_t <= multiplicand_t || mdld_t;
    end
    else begin
        multiplicandReg_t <= multiplicandReg_t || mdld_t;
    end

    if (mrld) begin
        multiplierReg <= multiplier;
        multiplierReg_t <= multiplier_t || mrld_t;
    end
    else begin
        multiplierReg_t <= multiplierReg_t || mrld_t;
    end

    if (rsclear) begin
        runningSumReg <= 0;
        runningSumReg_t <= 0 || rsclear;
    end

    // load running sum
    else if (rsload) begin
        runningSumReg <= multiplicandReg + runningSumReg; 
        runningSumReg_t <= multiplicandReg_t || runningSumReg_t || rsload_t || rsshr_t;
    end

    else if (rsshr) begin
        runningSumReg <= runningSumReg >>> 1; 
        runningSumReg_t <= runningSumReg_t || rsclear_t || rsload_t || rsshr_t;
    end

    else begin
        runningSumReg_t <= runningSumReg_t || rsclear_t || rsload_t || rsshr_t;
    end 
end

    assign product = runningSumReg;
    assign product_t = runningSumReg_t;

endmodule