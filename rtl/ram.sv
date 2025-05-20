// ───────────────────────────────────────
//    RAM for the CPU to communicate with
// ───────────────────────────────────────
module ram (
    input logic clk,
    input logic [7:0] addr,
    input logic rEN, wEN   
    inout tri [7:0] data_bus 
);
    logic [7:0] ram [0:255];
    logic [7:0] buffer;

    // Tri-state Buffer
    assign data_bus = (!wEN && rEN) ? data_bus : 8'bz;

    always_ff @(posedge clk) begin
        if (o) begin
            ram[addr] <= data_bus;
        end else begin
            data_bus <= ram[addr];
        end
    end
endmodule