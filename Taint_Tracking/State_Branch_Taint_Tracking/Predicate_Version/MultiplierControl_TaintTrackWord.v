//==============================================================================
// Control Module for Sequential Multiplier
//==============================================================================

module MultiplierControl_TaintTrackWord #(parameter WIDTH = 4)(
	// External Inputs
	input   clk,           // Clock
    input   rst,           // reset
	input   start,
    input   start_t,

    // External Output
    output reg productDone,
    output reg productDone_t,

	// Outputs to Datapath
	output reg  rsload,
    output reg  rsload_t,
	output reg  rsclear,
    output reg  rsclear_t,
	output reg  rsshr,
    output reg  rsshr_t,
    output reg  mrld,
    output reg  mrld_t,
    output reg  mdld,
    output reg  mdld_t,

	// Inputs from Datapath
    input [WIDTH - 1:0] multiplierReg,
    input multiplierReg_t
);
	// Local Vars
	// # of states = 6
    reg [2:0] state;
    reg state_t;
	reg [2:0] next_state;
    reg next_state_t;
    localparam COUNTER_WIDTH = $clog2(WIDTH);
    reg [COUNTER_WIDTH - 1:0] bitCounter;
    reg bitCounter_t;

    // predicates
    reg p_START;
    reg p_INIT;
    reg p_SHIFT;
    reg p_NOP;
    reg p_LOAD;
    reg p_FINAL;

    // predicate taints
    reg p_START_t;
    reg p_INIT_t;
    reg p_SHIFT_t;
    reg p_NOP_t;
    reg p_LOAD_t;
    reg p_FINAL_t;

	localparam START = 4'd0;
	localparam INIT = 4'd1;
    localparam SHIFT = 4'd2;
    localparam NOP = 4'd3;
    localparam LOAD = 4'd4;
    localparam FINAL = 4'd5;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
        rsload = 0;
        rsclear = 0;
        rsshr = 0;
        mrld = 0;
        mdld = 0;
        productDone = 0;

        // is this taint logic correct?
        if (p_INIT) begin
            mdld = 1;
            mrld = 1;
            rsclear = 1;

            mdld_t = p_INIT_t;
            mrld_t = p_INIT_t;
            rsclear_t = p_INIT_t;
        end
        else if (p_FINAL) begin
            rsshr = 1;
            productDone = 1;

            rsshr_t = p_FINAL_t;
            productDone_t = p_FINAL_t;
        end
        else if (p_SHIFT) begin
            rsshr = 1;

            rsshr_t = p_SHIFT_t;
        end
        else if (p_LOAD) begin
            rsload = 1;

            rsload_t = p_LOAD_t;
        end
	end

	// Next State Logic
    // this taint logic seems fishy
	always @(posedge clk) begin

        if (rst) begin
			p_START <= 1
            bitCounter <= 0;
		end
		
		else if (p_START) begin
			if (start) begin
				p_INIT <= 1;
                p_START <= 0;
			end
            p_INIT_t <= p_START_t | start_t;
		end
		else if (p_INIT) begin
			p_SHIFT <= 1;
            p_INIT <= 0;

            p_SHIFT_t <= p_INIT_t;
		end
        else if (p_FINAL) begin
            p_START <= 1;
            p_FINAL <= 0;

            p_START_t <= p_FINAL_t;
        end
        else if (p_SHIFT) begin
            bitCounter <= bitCounter + 1;
            bitCounter_t <= p_SHIFT_t;
            p_SHIFT <= 0;
            
            if (multiplierReg[bitCounter]) begin
                p_LOAD <= 1;
            end
            else begin
                p_NOP <= 1;
            end
            p_LOAD_t <= p_SHIFT_t | multiplierReg_t | bitCounter_t;
            p_NOP_T <= p_SHIFT_t | multiplierReg_t | bitCounter_t;
        end
        else begin
            if (bitCounter == WIDTH) begin
                p_FINAL <= 1;
                p_LOAD <= 0;
                p_NOP <= 0;
            end
            else begin
                p_SHIFT <= 1;
                p_LOAD <= 0;
                p_NOP <= 0;
            end
            p_FINAL_t <= bitCounter_t;
            p_SHIFT_t <= bitCounter_t;
        end
	end

endmodule
