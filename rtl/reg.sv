module reg (
    input logic clk, rst, 
    input logic wEN, rEN
    input logic [7:0] in,
    output logic [7:0] out
);
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 0;
        end else if ((|wEN) || (|rEN)) begin
            out <= in;
        end
    end
endmodule