// ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
//    Combines various modules to make up the CPU, will be instantiated by the machine to simualte what a cpu would do (assuming it works)
// ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
module cpu #(
    parameter S_START = 8'h00;
    parameter S_FETCH = 8'h01;
    parameter S_DECO = 8'h02;
    parameter S_MATH_DECO = 8'h03;
    parameter S_STOP = 8'h04;
    parameter S_LOAD = 8'h05;
    parameter S_STORE = 8'h06;
    parameter S_JUMP = 8'h07;
    parameter S_ALU = 8'h08;
    parameter S_XOR = 8'h09;
    parameter S_OR = 8'h0a;
    parameter S_AND = 8'h0b;
    parameter S_MATH = 8'h0c;
    parameter S_EXEC = 8'h0d;
    parameter S_EXEC = 8'h03e;
    parameter S_NEXT = 8'h0f;
    
    parameter ONE = 2'b00;
    parameter ADD = 2'b01;
    parameter SUB = 2'b10;
    parameter SWAP = 2'b11;

    parameter STORE = 8'b00_000_xxx;
    parameter LOAD = 8'b00_001_xxx;
    parameter STOP = 8'b00_010_xxx;
    parameter JUMP = 8'b00_011_xxx;
    parameter M_STORE = 8'b00_100_xxx; //STORE INTO MEMORY
    parameter INC = 8'b00_101_xxx;
    parameter DEC = 8'b00_110_xxx;
)(
    input logic clk, rst, 
    output logic o_clk, nomem_flag,
    output logic [7:0] addr_bus,
    inout tri [7:0] data_bus
);
    // ────────────────
    //  BUS Framework
    // ────────────────
    logic [7:0] instr_bus, bus_fsm, bus_alu, bus_reg;
    logic [2:0] bus_addr;
    logic flag_zero, flag_carry;

    // ──────────────────────
    //  CPU's Internal CLock
    // ──────────────────────
    logic [2:0] cpu_stage = 0; // Simply follows the fetch->decode->execute cycle {execute, decode, fetch}
    logic [2:0] cpu_stage_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            cpu_stage <= 0;
        end else begin
            cpu_stage <= cpu_stage_n;
        end
    end
    logic stop;
    logic cpu_clk;
    clock cpu_clk(.en(clk), .delay(0), .clk(cpu_clk), .not_clk());

    // ───────────
    //  Registers
    // ───────────
    // CPU STAGE NEEDS MORE SPECIFICATIONS SO THAT REN AND WEN ARE NOT ON AT THE SAME TIME
    // Memory Register
    logic [7:0] memory_reg;
    // Register File
    logic [7:0] reg_a, reg_b, reg_c; //a +/- b = c
    // CPU Registers
    cpu_reg regs(.clk(cpu_clk), .rst(rst), .rEN(cpu_stage[0]), .wEN(cpu_stage[2]), .in(bus_reg), .select(bus_addr), .data_bus(data_bus));

    // ─────────────────
    //  FSM State Logic
    // ─────────────────
    logic [7:0] state; 
    fsm cpu_fsm(.instr(instr_bus), .clk(clk), .rst(rst), .state(state), .flag_zero(flag_zero));

    logic [2:0] cpu_stage_n;
    always_comb begin
        case (state)
            S_START, S_FETCH: cpu_stage_n = 3'b001;
            S_DECO, S_ONE, S_ADD, S_SUB, S_SWAP, S_ONE_DECO: cpu_stage_n = 3'b010;
            S_ALU, S_EXEC: cpu_stage_n = 3'b100;
            default: cpu_stage_n = cpu_stage;
        endcase
    end

    // ────────────────────
    //  Transition to ALU
    // ────────────────────
    logic [7:0] n_a, n_b;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            bus_a = 0;
            bus_b = 0;
            flag_zero = 0;
        end else begin
            bus_a = n_a;
            bus_b = n_b;
            flag_zero = 0;
        end
    end

    // ───────────
    //  ALU Logic
    // ───────────
    logic [7:0] result, result_n, bus_a, bus_b; 
    alu ALU(.en(cpu_stage[2]), .clk(clk), .rst(rst), .operation(instr_bus[7:6]), .a(addr_a), .b(addr_b), .out(result_n), .flag_zero(flag_zero), .flag_carry(flag_carry));
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            bus_reg = 0;
        end else if (S_EXEC) begin
            bus_reg = result;
        end else begin
            bus_reg = bus_reg;
        end
    end

    // ─────────────────
    //  Non-ALU Logic
    // ─────────────────
    // ADD NON ALU LOGIC FOR ALL THE PROCESSES THAT AREN'T MATH RELATED
    always_comb begin
        if (instr_bus[7:6] == ONE) begin
            n_a = instr_bus;
            n_b = bus_b;
        end else begin
            n_a = bus_a;
            n_b = bus_b;
        end
    end
endmodule