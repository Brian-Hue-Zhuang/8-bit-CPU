// ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
//    Sends output to FSM for proper distribution and utilization of information
//    Currently only accounts for 4 registers, will need to increase in size or instantiate multiple times in order to handle more complex cpus
//    Takes instructions and does the following:
//      o Uses instructions to find the right data and operations
//      o Takes the data from the correct registers (data bus)
//      o Send relevent information to the ALU
// ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
module fsm #(
    parameter S_START = 8'h00;
    parameter S_FETCH = 8'h01;
    parameter S_DECO = 8'h02;
    parameter S_ONE_DECO = 8'h03;
    parameter S_STOP = 8'h04;
    parameter S_LOAD = 8'h05;
    parameter S_STORE = 8'h06;
    parameter S_ALU = 8'h07;
    parameter S_ONE = 8'h08;
    parameter S_ADD = 8'h09;
    parameter S_SUB = 8'h0a;
    parameter S_SWAP = 8'h0b;
    parameter S_MATH = 8'h0c;
    parameter S_EXEC = 8'h0d;
    parameter S_EXEC = 8'h0e;
    parameter S_NEXT = 8'h0f;
    
    parameter OP_NOP = 0_0000;
    parameter OP_LDI = 1_0001;
    parameter OP_RDI = 1_0010;
    parameter OP_JMP = 1_0011;
    parameter OP_HLT = 1_0100;
    parameter OP_ADD = 1_1000;
    parameter OP_SUB = 1_1001;
    parameter OP_NOT = 1_1010;
    parameter OP_AND = 1_1011;
    parameter OP_OR = 1_1100;
    parameter OP_XOR = 1_1101;
    parameter OP_INC = 1_1110;
    parameter OP_DEC = 1_1111;
)(
    input logic [7:0] instr,
    input logic clk, rst, 
    output logic [7:0] state,
    output logic flag_zero
);
    // Operation Information Conditionals
    assign addrBus_a = instr[5:3];
    assign addrBus_b = instr[2:0];
    logic [2:0] op_n;
    logic [2:0] state, state_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            cpu_stage = 3'b001;
            flag_zero <= 0;
        end else if (addrBus_a == 0 || addrBus_b == 0) begin
            state <= state_n;
            cpu_stage = cpu_stage_n;
            flag_zero <= 1;
        end else begin
            state <= state_n;
            cpu_stage = cpu_stage_n;
            flag_zero <= 0;
        end
    end

    // Instructions for ALU 
    always_comb begin
        case (state)
            // FETCH STAGE
            S_START: state_n = S_FETCH;
            S_FETCH: state_n = S_DECO;

            // DECODE STAGE
            S_DECO : state_n = (op == ADD) ? S_ADD:
                               (op == SUB) ? S_SUB:
                               (op == AND) ? S_SWAP:
                               S_ONE;
            S_ONE: state_n = S_ONE_DECO;
            S_ADD, S_SUB, S_SWAP, S_ONE_DECO: state_n = S_ALU;
            
            // EXECUTE STAGE
            S_ALU: state_n = S_EXEC;
            S_EXEC: state_n = S_NEXT;
            default: state_n = state;
        endcase
    end
endmodule