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
    localparam COUNTER_WIDTH = $clog2(WIDTH);
    reg [COUNTER_WIDTH:0] bitCounter;
    reg bitCounter_t;

    // predicates
    reg p_START;
    reg p_INIT;
    reg p_SHIFT;
    reg p_NOP;
    reg p_LOAD;
    reg p_FINAL;
    reg p_COUNT_DONE;
    reg p_LN;

    // predicate taints
    reg p_START_t;
    reg p_INIT_t;
    reg p_SHIFT_t;
    reg p_NOP_t;
    reg p_LOAD_t;
    reg p_FINAL_t;
    reg p_COUNT_DONE_t;
    reg p_LN_t;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
        rsload = 0;
        rsclear = 0;
        rsshr = 0;
        mrld = 0;
        mdld = 0;
        productDone = 0;

        p_COUNT_DONE = (bitCounter == WIDTH);

        p_LN = p_LOAD | p_NOP;

        if (p_INIT) begin
            mdld = 1;
            mrld = 1;
            rsclear = 1;
        end
        else if (p_FINAL) begin
            rsshr = 1;
            productDone = 1;
        end
        else if (p_SHIFT) begin
            rsshr = 1;
        end
        else if (p_LOAD) begin
            rsload = 1;
        end

        p_COUNT_DONE_t = bitCounter_t;

        mdld_t = p_INIT_t;
        mrld_t = p_INIT_t;
        rsclear_t = p_INIT_t;

        rsshr_t = p_FINAL_t;
        productDone_t = p_FINAL_t;

        rsshr_t = p_SHIFT_t;

        rsload_t = p_LOAD_t;
	end

	// Next State Logic
	always @(posedge clk) begin

        if (rst) begin
			p_START <= 1;
            p_INIT <= 0;
            p_SHIFT <= 0;
            p_FINAL <= 0;
            p_COUNT_DONE <= 0;
            p_LN <= 0;
            p_LOAD <= 0;
            p_NOP <= 0;
		end
		
		if (p_START) begin
			if (start) begin
				p_INIT <= 1;
                p_START <= 0;
			end
		end
		if (p_INIT) begin
			p_SHIFT <= 1;
            p_INIT <= 0;
            bitCounter <= 0;
		end
        if (p_FINAL) begin
            p_START <= 1;
            p_FINAL <= 0;
        end
        if (p_SHIFT) begin
            p_SHIFT <= 0;

            if (multiplierReg[bitCounter]) begin
                p_LOAD <= 1;
            end
            else begin
                p_NOP <= 1;
            end
            bitCounter <= bitCounter + 1;
        end
        if (p_LN) begin
            if (p_COUNT_DONE) begin
                p_FINAL <= 1;
                p_LOAD <= 0;
                p_NOP <= 0;
            end
            else begin
                p_SHIFT <= 1;
                p_LOAD <= 0;
                p_NOP <= 0;
            end
        end

        p_INIT_t <= p_INIT_t | (p_START_t & start_t) | (p_START_t & start) | (p_START & start_t);
        p_SHIFT_t <= p_SHIFT_t | p_INIT_t;
        p_START_t <= p_START_t | p_FINAL_t;
        bitCounter_t <= bitCounter_t | p_SHIFT_t;
        p_LOAD_t <= p_LOAD_t | (p_SHIFT_t & (multiplierReg_t | bitCounter_t)) | (p_SHIFT_t & multiplierReg[bitCounter]) | (p_SHIFT & (multiplierReg_t | bitCounter_t));
        p_NOP_t <= p_NOP_t | (p_SHIFT_t & (multiplierReg_t | bitCounter_t)) | (p_SHIFT_t & multiplierReg[bitCounter]) | (p_SHIFT & (multiplierReg_t | bitCounter_t));
        p_LN_t <= p_LN_t | p_SHIFT_t;
        p_FINAL_t <= p_FINAL_t | (p_LN_t & p_COUNT_DONE_t) | (p_LN_t & p_COUNT_DONE) | (p_LN | p_COUNT_DONE_t);
        p_SHIFT_t <= p_SHIFT_t | (p_LN_t & p_COUNT_DONE_t) | (p_LN_t & p_COUNT_DONE) | (p_LN | p_COUNT_DONE_t);
	end

endmodule
