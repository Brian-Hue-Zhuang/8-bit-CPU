// ─────────────────────────────────────────────────────────────
//    Self-Explanatory ALU Module
// ─────────────────────────────────────────────────────────────
module alu #(
    parameter ONE = 2'b00;
    parameter ADD = 2'b01;
    parameter SUB = 2'b10;
    parameter SWAP = 2'b11;

    parameter STORE = 8'b00000001;
    parameter LOAD = 8'b00000010;
    parameter STOP = 8'b00000100;
    parameter JUMP = 8'b00001000;
    parameter M_STORE = 8'b00010000; //STORE INTO MEMORY
    parameter INC = 8'b00100000;
    parameter DEC = 8'b01000000;
)(
    input logic en, clk, rst, 
    input logic [1:0] operation,
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
            case (op)
                ADD: {flag_carry, out_n} = a + b;
                SUB: {flag_carry, out_n} = a - b;
                ONE:begin
                        case (a)
                            DEC: {flag_carry, out_n} = b - 1;
                            INC: {flag_carry, out_n} = b + 1;
                            default: {flag_carry, out_n} = 9'b0;
                        endcase
                    end
                default: {flag_carry, out_n} = 9'b0;
            endcase
            flag_zero <= (buff_out == 0);
        end 
    end
    assign out = out_n;
endmodule