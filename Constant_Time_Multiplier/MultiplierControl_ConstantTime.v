//==============================================================================
// Control Module for Sequential Multiplier
//==============================================================================

module MultiplierControl_ConstantTime #(parameter WIDTH = 4)(
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
    localparam STATE_WIDTH = $clog2(2 * WIDTH + 2);
    reg [STATE_WIDTH - 1:0] state;
	reg [STATE_WIDTH - 1:0] next_state;

	localparam START = 4'd0;
	localparam INIT = 4'd1;
    localparam FINAL = 2 * WIDTH + 1;

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
        else if (state[0] == 0) begin
            if (multiplierReg[(state >> 1) - 1]) begin
                rsload = 1;
            end
        end
        else begin
            rsshr = 1;
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
		end
	end

endmodule
