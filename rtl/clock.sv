// ─────────────────────────────────────────────────────────────
//    Easily configurable clock
// ─────────────────────────────────────────────────────────────
module clock (
    input logic en, 
    input logic [7:0] delay, // For the sake of the current implementation this will always be 0
    output logic clk, not_clk
);
    logic clk_n;
    logic [7:0] counter;
    always_comb begin
        if (en) begin
            if (counter == delay) begin
                clk_n = ~clk;
                counter = 0;
            end else begin
                clk_n = clk;
                counter = counter + 1;
            end
        end else begin
            clk_n = clk;
        end
    end
    assign clk = clk_n;
    assign not_clock = !clk_n;
endmodule