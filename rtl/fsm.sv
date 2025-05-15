/*
    Input an 8-bit Instruction
    Outputs the proper Read/Write enables and outputs the address bus
    Sends output to FSM for proper distribution and utilization of information
    Currently only accounts for 4 registers, will need to increase in size or instantiate multiple times in order to handle more complex cpus
    Takes instructions and does the following:
       o Uses instructions to find the right data and operations
       o Takes the data from the correct registers (data bus)
       o Send relevent information to the ALU
*/
module fsm #(
    parameter S_START = 8'h00;
    parameter S_FETCH = 8'h00;
    parameter S_DECO = 8'h00;
    parameter S_MATH_DECO = 8'h00;
    parameter S_STOP = 8'h00;
    parameter S_LOAD = 8'h00;
    parameter S_STORE = 8'h00;
    parameter S_JUMP = 8'h00;
    parameter S_ALU = 8'h00;
    parameter S_XOR = 8'h00;
    parameter S_OR = 8'h00;
    parameter S_AND = 8'h00;
    parameter S_MATH = 8'h00;
    parameter S_EXEC = 8'h00;
    parameter S_EXEC = 8'h00;
    parameter S_NEXT = 8'h00;
    parameter S_FIN = 8'h00;
    
    // parameter MATH = 3'b000;
    parameter XOR = 8'b001_00_000;
    parameter OR = 8'b010_00_000;
    parameter AND = 8'b011_00_000;
    parameter STOP = 8'b100_00_000;
    parameter LOAD = 8'b101_00_000;
    parameter STORE = 8'b110_00_000;
    parameter JUMP = 8'b111_00_000;
    // parameter ADD = 2'b00;
    // parameter SUB = 2'b01;
    // parameter INC = 2'b10;
    // parameter DEC = 2'b11;
)(
    input logic [7:0] instr,
    input logic clk, rst,
    output logic [7:0] addBus, op, 
    output logic flag_zero
);
    //Operation Information Conditionals
    always_comb begin
        case(instr)
            8'b001_xx_xxx: op = XOR;
            8'b010_xx_xxx: op = OR;
            8'b011_xx_xxx: op = AND;
            8'b100_xx_xxx: op = SAVE;
            8'b101_xx_xxx: op = LOAD;
            8'b110_xx_xxx: op = STORE;
            8'b111_xx_xxx: op = JUMP;
            default: op = instr;
        endcase
    end

    logic [2:0] op_n;
    logic [2:0] state, state_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            flag_zero <= 0;
        end else if (addBus_n == 0) begin
            state <= state_n;
            flag_zero <= 1;
        end else begin
            state <= state_n;
            flag_zero <= 0;
        end
    end

    //Instructions for ALU 
    always_comb begin
        case(state)
            //FETCH STAGE
            S_START: state_n = S_FETCH;
            S_FETCH: state_n = S_DECE;

            //DECODE STAGE
            S_DECO : state_n = (op == XOR) ? S_XOR:
                               (op == OR) ? S_OR:
                               (op == AND) ? S_AND:
                               (op == STOP) ? S_STOP:
                               (op == LOAD) ? S_LOAD:
                               (op == STORE) ? S_STORE:
                               (op == JUMP) ? S_JUMP:
                               S_MATH;
            S_MATH: state_n = S_MATH_DECO;
            S_XOR, S_OR, S_ANDS, S_MATH_DECO: state_n = S_ALU;
            
            //EXECUTE STAGE
            S_ALU, S_STOP, S_LOAD, S_STORE: state_n = S_EXEC;
            S_EXEC: state_n = S_FIN;
            default: state_n = state;
        endcase
    end
endmodule