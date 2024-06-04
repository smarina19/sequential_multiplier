//==============================================================================
// Control Module for Sequential Multiplier
//==============================================================================

module MultiplierControl(
	// External Inputs
	input   clk,           // Clock
    input   rst,           // reset
	input   start,

	// Outputs to Datapath
	output reg  rsload,
	output reg  rsclear,
	output reg  rsshr,
    output reg  mrld,
    output reg  mdld,

	// Inputs from Datapath
	input   mr0,
	input	mr1,
	input	mr2,
    input   mr3 // coloring off?
);
	// Local Vars
	reg [3:0] state;
	reg [3:0] next_state;

	// State Names 
	localparam START = 4'd0;
	localparam INIT = 4'd1;
	localparam BIT_ZERO = 4'd2;
	localparam BIT_ZERO_TRUE = 4'd3;
    localparam BIT_ONE = 4'd4;
    localparam BIT_ONE_TRUE = 4'd5;
    localparam BIT_TWO = 4'd6;
    localparam BIT_TWO_TRUE = 4'd7;
    localparam BIT_THREE = 4'd8;
    localparam BIT_THREE_TRUE = 4'd9;
    localparam FINAL = 4'd10;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
        rsload = 0;
        rsclear = 0;
        rsshr = 0;
        mrld = 0;
        mdld = 0;

		case (state)
			INIT: begin
				mdld = 1;
                mrld = 1;
                rsclear = 1;
			end
			BIT_ZERO_TRUE: begin
                rsload = 1;
			end
            BIT_ONE: begin
                rsshr = 1;
            end
            BIT_ONE_TRUE: begin
                rsload = 1;
            end
            BIT_TWO: begin
                rsshr = 1;
            end
            BIT_TWO_TRUE: begin
                rsload = 1;
            end
            BIT_THREE: begin
                rsshr = 1;
            end
            BIT_THREE_TRUE: begin
                rsload = 1;
            end
            FINAL: begin
                rsshr = 1;
            end
		endcase
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;
		
		case (state)
		START: begin
			if (start) begin
				next_state = INIT;
			end
		end
		INIT: begin
			next_state = BIT_ZERO;
		end
		BIT_ZERO: begin
			if (mr0) begin
				next_state = BIT_ZERO_TRUE;
			end
			else begin
				next_state = BIT_ONE;
			end
		end
        BIT_ZERO_TRUE: begin
            next_state = BIT_ONE;
        end
        BIT_ONE: begin
            if (mr1) begin
                next_state = BIT_ONE_TRUE;
            end
            else begin
                next_state = BIT_TWO;
            end
        end
        BIT_ONE_TRUE: begin
            next_state = BIT_TWO;
        end
        BIT_TWO: begin
            if (mr2) begin
                next_state = BIT_TWO_TRUE;
            end
            else begin
                next_state = BIT_THREE;
            end
        end
        BIT_TWO_TRUE: begin
            next_state = BIT_THREE;
        end
        BIT_THREE: begin
            if (mr3) begin
                next_state = BIT_THREE_TRUE;
            end
            else begin
                next_state = FINAL;
            end
        end
        BIT_THREE_TRUE: begin
            next_state = FINAL;
        end
        FINAL: begin
            next_state = START;
        end
		endcase
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
