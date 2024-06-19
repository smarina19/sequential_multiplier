//==============================================================================
// Datapath Module for Sequential Multiplier
//==============================================================================

module MultiplierDatapath_TaintTrack #(parameter WIDTH = 4)(

    // External Inputs
    input   clk,       // Clock 
    input wire [WIDTH - 1:0] multiplier,
    input wire [WIDTH - 1:0] multiplier_t,
    input wire [WIDTH - 1:0] multiplicand,
    input wire [WIDTH - 1:0] multiplicand_t,

    // External Output
    output wire [WIDTH*2 - 1:0] product,
    output wire [WIDTH*2 - 1:0] product_t,

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
    output reg [WIDTH - 1:0] multiplierReg_t,

    // debug outputs
    output reg [WIDTH*2:0] runningSumReg,
    output reg [WIDTH*2:0] runningSumReg_t,
    output reg [WIDTH*2:0] multiplicandReg,
    output reg [WIDTH*2:0] multiplicandReg_t
);

// Sequential Logic
always @( posedge clk) begin
    
    // init registers
    if (mdld && mdld_t) begin
        multiplicandReg <= multiplicand << WIDTH;
        // do we have to perform shifts or addtion for taint registers if we only care if their bits carry any 1s?
        multiplicandReg_t <= multiplicand_t | {WIDTH{mdld_t}};
    end
    if (!mdld_t && mdld) begin
        multiplicandReg <= multiplicand << WIDTH; 
        multiplicandReg_t <= multiplicand_t;
    end
    if (mrld && mrld_t) begin
        multiplierReg <= multiplier;
        multiplierReg_t <= multiplier_t | {WIDTH{mrld_t}};
    end

    if(mrld && !mrld_t) begin
        multiplierReg <= multiplier;
        multiplierReg_t <= multiplier_t;
    end

    if (rsclear && rsclear_t) begin
        runningSumReg <= 0;
        runningSumReg_t <= {WIDTH{rsclear_t}};
    end

    if(rsclear && !rsclear_t) begin
        runningSumReg <= 0;
        runningSumReg_t <= 0:
    end


    // load running sum
    if (rsload && rsload_t) begin
        runningSumReg <= multiplicandReg + runningSumReg; 
        runningSumReg_t <= multiplicandReg_t | runningSumReg_t | {WIDTH{rsload_t}};
    end

    if(rsload && !rsload_t) begin
        runningSumReg <= multiplicandReg + runningSumReg; 
        runningSumReg_t <= multiplicandReg_t | runningSumReg_t
    end

    // how do we know what to shift in here for sign?
    if (rsshr && rsshr_t) begin
        runningSumReg <= runningSumReg >>> 1; 
        runningSumReg_t <= runningSumReg_t | {WIDTH{rsshr_t}};
    end

    if(rsshr && !rsshr_t) begin
        runningSumReg_t <= runningSumReg_t
    end

    // taint logic depends on control bits
    // multiplicandReg_t <= multiplicandReg_t | {WIDTH{mdld_t}};
    // multiplierReg_t <= multiplierReg_t | {WIDTH{mrld_t}};
    // runningSumReg_t <= runningSumReg_t | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
end 
    assign product = runningSumReg;
    assign product_t = runningSumReg_t;

endmodule