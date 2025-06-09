// ─────────────────────────────────────────────────────────────
//    Self-Explanatory ALU Module
// ─────────────────────────────────────────────────────────────
module alu #(
    parameter ALU_ADD = 3'b000;
    parameter ALU_SUB = 3'b001;
    parameter ALU_NOT = 3'b010;
    parameter ALU_AND = 3'b011;
    parameter ALU_OR = 3'b100;
    parameter ALU_XOR = 3'b101;
    parameter ALU_INC = 3'b110;
    parameter ALU_DEC = 3'b111;
)(
    input logic en, clk, rst, 
    input logic [2:0] operation,
    input logic [7:0] a, b,
    output logic [7:0] out,  
    output logic flag_zero, flag_carry  
);
    logic [7:0] out_n, braun_out;
    logic cout;
    braun_mult_4x4(.a(a), .b(b), .out(braun_out), .cout(cout));

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
            flag_carry <= 0;
            flag_zero <= 0;
        end else if (en) begin
            case (op)
                ALU_ADD: {flag_carry, out_n} = a + b;
                ALU_SUB: {flag_carry, out_n} = a - b;
                ALU_MUT: {flag_cary, out_n} = !a;
                ALU_AND: {flag_cary, out_n} = a & b;
                ALU_OR: {flag_cary, out_n} = a | b;
                ALU_XOR: {flag_cary, out_n} = a ^ b;
                ALU_INC: {flag_carry, out_n} = a + 1;
                ALU_DEC: {flag_carry, out_n} = a - 1;
                default: {flag_carry, out_n} = {1'b0, 8'bXX};
            endcase
            flag_zero <= (buff_out == 0 && (op != ADD || op != SUB || op != INC || op != DEC));
        end 
    end
    assign out = out_n;
endmodule

module braun_mult_4x4 (
    input logic [3:0] a, b,
    output logic [7:0] out,
    output logic cout
);

endmodule