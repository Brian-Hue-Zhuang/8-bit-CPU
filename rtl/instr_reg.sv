/*
    Input an 8-bit Instruction
    Outputs the proper Read/Write enables and outputs the adress bus
    Sends output to FSM for proper distribution and utilization of information
    Currently only accounts for 4 registers, will need to increase in size or instantiate multiple times in order to handle more complex cpus
*/
module instr_reg (
    input logic [7:0] in,
    input logic r, w, clk, rst,
    output logic [3:0] rEN, wEN, addBus,
    output logic [2:0] op,
    output logic flag_zero
);
    logic [3:0] rEN_n, wEN_n, addBus_n; 
    logic [2:0] op_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            op <= 0;
            rEN <= 0;
            wEN <= 0;
            addBus <= 0;
            op <= 0;
            flag_zero <= 0;
        end else if (addBus_n == 0) begin
            op <= op_n;
            rEN <= rEN_n;
            wEN <= wEN_n;
            addBus <= addBus_n;
            op <= op_n;
            flag_zero <= 1;
        end else begin
            op <= op_n;
            rEN <= rEN_n;
            wEN <= wEN_n;
            addBus <= addBus_n;
            op <= op_n;
            flag_zero <= 0;
        end
    end
    assign addBus_n = in[3:0];
    assign op_n = [7:6];
    logic [3:0] decode; //Output of binary Decoder
    assign decode[3] = ~in[5] && ~in[4];
    assign decode[2] = ~in[5] && in[4];
    assign decode[1] = in[5] && ~in[4];
    assign decode[0] = in[5] && in[4];
    assign rEN_n = {r && decode[3], r && decode[2], r && decode[1], r && decode[0]}; //Binary Decoder AND Read/Write, each bit represents a register
    assign wEN_n = {w && decode[3], w && decode[2], w && decode[1], w && decode[0]}; //Determines whether rEN or wEN should be on, prevents simultaneous toggles
endmodule