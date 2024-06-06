//==============================================================================
// Datapath Module for Sequential Multiplier
//==============================================================================

module MultiplierDatapath(

    // External Inputs
    input   clk,       // Clock 
    input wire [3:0] multiplier,
    input wire [3:0] multiplicand,

    // External Output
    output wire [7:0] product,

    // Inputs from Controller
    input rsload,
    input rsclear,
    input rsshr,
    input mrld,
    input mdld,

    // Outputs to Controller
    output wire   mr0,
    output wire   mr1,
    output wire   mr2,    
    output wire   mr3,

    // debug outputs
    output reg [3:0] multiplierReg,
    output reg [8:0] runningSumReg,
    output reg [8:0] multiplicandReg
);

// Output Wires
    assign mr3 = multiplierReg[3];
    assign mr2 = multiplierReg[2];
    assign mr1 = multiplierReg[1];
    assign mr0 = multiplierReg[0];

// Sequential Logic
always @( posedge clk) begin
    
    // init registers
    if (mdld) begin
        multiplicandReg <= multiplicand << 3'd4;
    end
    if (mrld) begin
        multiplierReg <= multiplier;
    end
    if (rsclear) begin
        runningSumReg <= 8'd0;
    end

    // load running sum
    if (rsload) begin
        runningSumReg <= multiplicandReg + runningSumReg; 
    end
    if(rsshr) begin
        runningSumReg <= runningSumReg >> 1'b1; 
    end
end 
    assign product = runningSumReg;

endmodule