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

        p_START = 0;
        p_INIT = 0;
        p_SHIFT = 0;
        p_NOP = 0;
        p_LOAD = 0;
        p_FINAL = 0;
        if (state == START) begin
            p_START = 1;
        end
        else if (state == INIT) begin
            p_INIT = 1;
            mdld = 1;
            mrld = 1;
            rsclear = 1;

            mdld_t = state_t;
            mrld_t = state_t;
            rsclear_t = state_t;
        end
        else if (state == FINAL) begin
            p_FINAL = 1;
            rsshr = 1;
            productDone = 1;

            rsshr_t = state_t;
            productDone_t = state_t;
        end
        else if (state == SHIFT) begin
            p_SHIFT = 1;
            rsshr = 1;

            rsshr_t = state_t;
        end
        else if (state == LOAD) begin
            p_LOAD = 1;
            rsload = 1;

            rsload_t = state_t;
        end
        else begin
            p_NOP = 1;
        end
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;
        next_state_t = state_t;
		
		if (state == START) begin
			if (start) begin
				next_state = INIT;
			end
            next_state_t = next_state_t | start_t;
		end
		else if (state == INIT) begin
			next_state = SHIFT;
		end
        else if (state == FINAL) begin
            next_state = START;
        end
        else if (state == SHIFT) begin
            if (multiplierReg[bitCounter]) begin
                next_state = LOAD;
            end
            else begin
                next_state = NOP;
            end
            next_state_t = next_state_t | multiplierReg_t | bitCounter_t;
        end
        else begin
            if (bitCounter == WIDTH) begin
                next_state = FINAL;
            end
            else begin
                next_state = SHIFT;
            end
        end
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			state <= START;
            bitCounter <= 0;
		end
		else begin
			// Update state to next state
			state <= next_state;
            state_t <= next_state_t;
            if (state == SHIFT) begin
                bitCounter <= bitCounter + 1;
                bitCounter_t <= state_t;
            end
		end
	end

endmodule
