module alu #(
    parameter ADD = 2'b00;
    parameter SUB = 2'b01;
    parameter AND = 2'b10;
    parameter OR = 2'b11;
)(
    input logic en, clk, rst, 
    input logic [2:0] operation,
    input logic [7:0] a, b,
    output logic [7:0] out,  
    output logic flag_zero, flag_carry  
);
    logic [7:0] out_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end else if (en) begin
            case(op)
                ADD: {flag_carry, out_n} = a + b;
                SUB: {flag_carry, out_n} = a - b;
                AND: {flag_carry, out_n} = a & b;
                OR: {flag_carry, out_n} = a | b;
            endcase
        end 
    end
    assign out = out_n;
endmodule