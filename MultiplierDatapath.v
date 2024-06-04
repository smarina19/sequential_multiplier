//==============================================================================
// Data Path Module for Sequential Multiplier
//==============================================================================

module MultiplierDatapath(

    //External Inputs
        input   clk,           // Clock 
        input wire [3:0] multiplier,
        input wire [3:0] multiplicand,

    // External Output
        output wire [7:0] product,

    //Inputs from Controller
        input rsload,
        input rsclear,
        input rsshr,
        input mrld,
        input mdld,

    //Outputs to Controller
        output wire   mr0,
        output wire   mr1,
        output wire   mr2,    
        output wire   mr3
);

//Local Registers 
   
    reg [3:0] multiplierReg;
    reg [7:0] runningSumReg;
    reg [3:0] muliplicandReg;

//Local Wires
    wire [3:0] rsAddEnd;
    wire [3:0] fourBitAddEnd;
    wire[4:0] fourBitAdder;

   

//Output Wires
    assign mr3 = multiplierReg[3];
    assign mr2 = multiplierReg[2];
    assign mr1 = multiplierReg[1];
    assign mr0 = multiplierReg[0];

//Sequential Logic
always @( posedge clk) begin
  
    if(mdld) begin

        muliplicandReg <= multiplicand; //look up need for <

        end

    if(mrld) begin

        multiplierReg <= multiplier; //look up need for <

        end

    if(rsload) begin

        runningSumReg[7:4] <= fourBitAdder; //look up need for <

        end
    if(rsclear) begin

        runningSumReg <= 0;

    end

    if(rsshr) begin
        runningSumReg <= runningSumReg >> 1'b1; 
    end
end 

//Computational Logic
    assign product = runningSumReg;
    assign rsAddEnd = runningSumReg[3:0];
    assign fourBitAddEnd = runningSumReg[7:4];
    assign fourBitAdder = (muliplicandReg + fourBitAddEnd); // How do we do the ANDing for partial sum? Would we just keep another varaible for the current bit in the 
                                                            // muliplicandReg, AND that bit with the multiplierReg and then add it the fourBit AddEnd?
                                                            // ex: fourBitAdder = (muliplicandReg[currBit] & multiplierReg) + fourBitAddEnd

endmodule