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
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;
    parameter S6 = 3'b110;
    parameter S7 = 3'b111;
    
    // parameter MATH = 3'b000;
    parameter XOR = 8'b001_00_000;
    parameter OR = 8'b010_00_000;
    parameter AND = 8'b011_00_000;
    parameter SAVE = 8'b100_00_000;
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

    logic [3:0] rEN_n, wEN_n, addBus_n; 
    logic [2:0] op_n;
    logic [2:0] state, state_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            op <= 0;
            rEN <= 0;
            wEN <= 0;
            addBus <= 0;
            op <= 0;
            state <= INIT;
            flag_zero <= 0;
        end else if (addBus_n == 0) begin
            op <= op_n;
            rEN <= rEN_n;
            wEN <= wEN_n;
            addBus <= addBus_n;
            op <= op_n;
            state <= state_n;
            flag_zero <= 1;
        end else begin
            op <= op_n;
            rEN <= rEN_n;
            wEN <= wEN_n;
            addBus <= addBus_n;
            op <= op_n;
            state <= state_n;
            flag_zero <= 0;
        end
    end

    always_comb begin
        case(state)
            //FETCH STAGE
            S0: state_n = S1;
            S1: state_n = S2;
            S2: state_n = S3;
            S3: state_n = S4;
            S4: state_n = S5;
            S5: state_n = S6;
            S6: state_n = S7;
            S7: state_n = S0;
            default: state_n = state;
        endcase
    end
endmodule