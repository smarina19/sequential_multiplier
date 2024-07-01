 //==============================================================================
// Control Module for Sequential Multiplier
//==============================================================================

module MultiplierControl_StateBranch #(parameter WIDTH = 4)(
	// External Inputs
	input   clk,           // Clock
    input   rst,           // reset
	input   start,

    // External Output
    output reg productDone,

	// Outputs to Datapath
	output reg  rsload,
	output reg  rsclear,
	output reg  rsshr,
    output reg  mrld,
    output reg  mdld,

	// Inputs from Datapath
    input [WIDTH - 1:0] multiplierReg
);
	// Local Vars
	// # of states = 2 * WIDTH + 3
    localparam STATE_WIDTH = $clog2(3 * WIDTH + 3);
    reg [STATE_WIDTH - 1:0] state;
	reg [STATE_WIDTH - 1:0] next_state;

	localparam START = 4'd0;
	localparam INIT = 4'd1;
    localparam FINAL = 3 * WIDTH + 2;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
        rsload = 0;
        rsclear = 0;
        rsshr = 0;
        mrld = 0;
        mdld = 0;
        productDone = 0;
        if (state == START) begin
        end
        else if (state == INIT) begin
            mdld = 1;
            mrld = 1;
            rsclear = 1;
        end
        else if (state == FINAL) begin
            rsshr = 1;
            productDone = 1;
        end
        else if (state >= 2 * WIDTH + 2) begin
            rsshr = 1;
        end
        else if (state[0] == 1) begin
            rsload = 1;
        end
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;
		
		if (state == START) begin
			if (start) begin
				next_state = INIT;
			end
		end
		else if (state == INIT) begin
            next_state = 2 * WIDTH + 2;
		end
        else if (state == FINAL) begin
            next_state = START;
        end
        else if (state >= 2 * WIDTH + 2) begin
            if (multiplierReg[state - (2 * WIDTH) - 2]) begin
                next_state = (state - (2 * WIDTH) - 1) * 2 + 1;
            end
            else begin
                next_state = (state - (2 * WIDTH) - 1) * 2;
            end
        end
        else if (state[0] == 0) begin
            next_state = 2 * WIDTH + 2 + (state / 2);
        end
        else begin
            next_state = 2 * WIDTH + 2 + ((state - 1) / 2);
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
		end
	end

endmodule
