module alu #(
    parameter XOR = 8'b001_00_000;
    parameter OR = 8'b010_00_000;
    parameter AND = 8'b011_00_000;
    parameter ADD = 2'b00;
    parameter SUB = 2'b01;
    parameter INC = 2'b10;
    parameter DEC = 2'b11;
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
            flag_carry <= 0;
            flag_zero <= 0;
        end else if (en) begin
            case(op)
                ADD: {flag_carry, out_n} = a + b;
                SUB: {flag_carry, out_n} = a - b;
                INC: {flag_carry, buff_out} <= in_a + 1;
                DEC: {flag_carry, buff_out} <= in_a - 1;
                AND: {flag_carry, out_n} = a & b; flag_carry <= 1'b0;
                OR: {flag_carry, out_n} = a | b; flag_carry <= 1'b0;
                XOR: {flag_carry, out_n} = a ^ b; flag_carry <= 1'b0;
            endcase
            flag_zero <= (buff_out == 0);
        end 
    end
    assign out = out_n;
endmodule