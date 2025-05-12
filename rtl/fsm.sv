/*
    Takes instructions and does the following:
       o Uses instructions to find the right data and operations
       o Takes the data from the correct registers (data bus)
       o Send relevent information to the ALU
*/
module fsm #(
    parameter S0 = 1; //Would need a way to communicate states to other modules, perhaps an output logic?
    parameter S1 = 2;
    parameter S2 = 3;
    parameter S3 = 4;
    parameter S4 = 5;
    parameter S5 = 6;
    parameter INIT = 0;
    parameter FIN = 7;
)(
    input logic [7:0] instr,
    input logic clk, rst, f_zero
    output logic [7:0] a, b, 
    output logic flag_zero
);
    logic [2:0] state, state_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            a <= 0;
            b <= 0;
            flag_zero <= 0;
        end else begin
            a <= a_n;
            b <= b_n;
            flag_zero <= 0;
        end
    end
    always_comb begin
        case(state)
            INIT: 
        endcase
    end
endmodule