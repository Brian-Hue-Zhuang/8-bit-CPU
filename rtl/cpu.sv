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
    
    parameter STOP = 8'b00_000_000;
    parameter LOAD = 8'b01_000_000;
    parameter STORE = 8'b11_000_000;
    parameter JUMP = 8'b11_000_000;
)(
    input logic clk, rst, 
    output logic o_clk, 
    output logic [7:0] addr_bus,
    inout tri [7:0] data_bus
);
    // ────────────────
    //  BUS Framework
    // ────────────────
    logic [7:0] bus_instr, bus_fsm bus_alu, bus_reg;
    logic flag_zero, flag_carry;

    // ──────────────────────
    //  CPU's Internal CLock
    // ──────────────────────
    logic [1:0] clk_cpu = 2'b01; // {alu(everything else) clock, memory clock, control (fsm) clock}
    logic stop;
    // The order should be as follows:
    //   1. Update control (fsm)
    //   2. Perform state relevent tasks
    //   3. Repeat
    always_ff @(posedge clk) begin
        if (!stop) begin
            clk_cpu <= clk_cpu == 1'b10 ? 2'b01:clk_cpu << 1;
        end
    end

    // ───────────
    //  Registers
    // ───────────
    // Instruction Register
    logic [7:0] instr_reg;
    reg instr_reg(.clk(clk_cpu[0]), .rst(rst), .rEN(), .wEN(), .in(), .out(instr_reg));
    // Register File
    logic [7:0] reg_a, reg_b, reg_c; //a +/- b = c
    // CPU Registers
    cpu_reg math_reg(.clk(clk_cpu[1]), .rst(rst), .rEN(), .wEN(), .in(), .store(), .data_bus(data_bus));

    // ─────────────────
    //  FSM State Logic
    // ─────────────────
    logic [7:0] state; 
    logic [4:0] bus_op;
    logic [2:0] addr_a, addr_b;
    fsm cpu_fsm(.instr(bus_instr), .clk(cpu[0]), .rst(rst), .addrBus_a(), .addrBus_b(), .op(bus_op), .state(state), .flag_zero(flag_zero));
endmodule