//==============================================================================
// Datapath Module for Sequential Multiplier
//==============================================================================

module MultiplierDatapath_TaintTrack #(parameter WIDTH = 1024)(

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

reg [WIDTH*2:0] carryIn;
reg [WIDTH*2:0] carryIn_t;
integer i;

// Sequential Logic
always @( posedge clk) begin
    
    // init registers
    if (mdld) begin
        multiplicandReg <= multiplicand << WIDTH;
        multiplicandReg_t <= multiplicand_t << WIDTH | {WIDTH{mdld_t}};
    end
    else begin
        multiplicandReg_t <= multiplicandReg_t | {WIDTH{mdld_t}};
    end

    if (mrld) begin
        multiplierReg <= multiplier;
        multiplierReg_t <= multiplier_t | {WIDTH{mrld_t}};
    end
    else begin
        multiplierReg_t <= multiplierReg_t | {WIDTH{mrld_t}};
    end

    if (rsclear) begin
        runningSumReg <= 0;
        runningSumReg_t <= 0 | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
    end

    // load running sum
    else if (rsload) begin
        runningSumReg <= multiplicandReg + runningSumReg; 

        // carry taint logic
        carryIn[0] = 0;
        carryIn_t[0] = 0;
        for (i = 0; i < 2 * WIDTH; i = i + 1) begin
            // check if there is a carry-out from i
            carryIn[i + 1] = (multiplicandReg[i] & runningSumReg[i]) | 
                 (multiplicandReg[i] & carryIn[i]) |
                  (runningSumReg[i] & carryIn[i]);
        end
        // check if the carry-out from i should be tainted
        carryIn_t = carryIn & ((multiplicandReg_t | runningSumReg_t) << 1);
        runningSumReg_t <= carryIn_t | runningSumReg_t | multiplicandReg_t | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
    end

    else if (rsshr) begin
        runningSumReg <= runningSumReg >>> 1; 
        runningSumReg_t <= runningSumReg_t | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
    end

    else begin 
        runningSumReg_t <= runningSumReg_t | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
    end

    end 
    assign product = runningSumReg;
    assign product_t = runningSumReg_t;
endmodule