//==============================================================================
// Control Module for Sequential Multiplier
//==============================================================================

module MultiplierControl_TaintTrackBitwise #(parameter WIDTH = 4)(
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
    input [WIDTH - 1:0] multiplierReg_t
);
	// Local Vars
	// # of states = 2 * WIDTH + 3
    localparam STATE_WIDTH = $clog2(2 * WIDTH + 3);
    reg [STATE_WIDTH - 1:0] state;
    reg [STATE_WIDTH - 1:0] state_t;
	reg [STATE_WIDTH - 1:0] next_state;
    reg [STATE_WIDTH - 1:0] next_state_t;

	localparam START = 4'd0;
	localparam INIT = 4'd1;
    localparam FINAL = 2 * (WIDTH + 1);
    // BIT_n = 2*n, BIT_n_TRUE = 2*n + 1, FINAL = 2*(N+1)

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
        rsload = 0;
        rsload_t = 0;
        rsclear = 0;
        rsclear_t = 0;
        rsshr = 0;
        rsshr_t = 0;
        mrld = 0;
        mrld_t = 0;
        mdld = 0;
        mdld_t = 0;
        productDone = 0;
        if (state == START) begin
        end
        else if (state == INIT) begin
            mdld = 1;
            mrld = 1;
            rsclear = 1;

            mdld_t = |state_t;
            mrld_t = |state_t;
            rsclear_t = |state_t;
        end
        else if (state == FINAL) begin
            rsshr = 1;
            productDone = 1;

            rsshr_t = |state_t;
            productDone_t = |state_t;
        end
        else if (state[0] == 1) begin
            if (multiplierReg[((state - 1) >> 1) - 1]) begin
                rsload = 1;
            end

            rsload_t = (|state_t) | (multiplierReg[((state - 1) >> 1) - 1]);
        end
        else begin
            rsshr = 1;

            rsshr_t = |state_t;
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
            next_state_t = next_state_t | {STATE_WIDTH{start_t}};
		end
		else if (state == INIT) begin
			next_state = 2;
		end
        else if (state == FINAL) begin
            next_state = START;
        end
        else begin
            next_state = next_state + 1;
        end
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			state <= START;
		end
		else begin
			// Update state to next state
			state <= next_state;
            state_t <= next_state_t;
		end
	end

endmodule