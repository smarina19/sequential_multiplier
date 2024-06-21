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

integer i;
integer carry;
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
        // addition logic - I don't know how to implement w/o using this weird loop logic
        runningSumReg_t <= multiplicandReg_t | runningSumReg_t | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
        carry = 0;
        for (i = 0; i < WIDTH - 1; i = i + 1) begin
            if (((multiplicandReg[i] & runningSumReg[i]) | 
                 (multiplicandReg[i] & carry) |
                  (runningSumReg[i] & carry))) 
            begin
                  carry = 1;
                  if (multiplicandReg_t[i] | runningSumReg_t[i]) begin
                    runningSumReg_t[i + 1] <= 1; // Propagate taint to the next bit if carry occurs in addition, should it be one or runningSumReg_t[i]
                  end
            end
            else begin
                carry = 0;
            end
        end
    end

    else if (rsshr) begin
        runningSumReg <= runningSumReg >>> 1; 
    end

    else begin 
        runningSumReg_t <= runningSumReg_t | {WIDTH{rsclear_t}} | {WIDTH{rsload_t}} | {WIDTH{rsshr_t}};
    end

    end 
    assign product = runningSumReg;
    assign product_t = runningSumReg_t;
endmodule