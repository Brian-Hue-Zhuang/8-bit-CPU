module alu #(
    parameter ADD = ;
    parameter SUB = ;
    parameter AND = ;
    parameter OR = ;
)(
    input logic en, clk, rst, 
    input logic [1:0] operation
    input logic [7:0] a, b,
    output logic [7:0] out,    
);
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end else if (en) begin
            case(op)
                ADD: out = a + b;
                SUB: out = a - b;
                AND: out = a & b;
                OR: out = a | b;
            endcase
        end 
    end
endmodule