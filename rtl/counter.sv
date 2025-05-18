/*
    Informs the CPU as to which instruction address it is on
    Mainly for debugging purposes
*/
module counter (
    input logic clk, rst, wEN,
    input logic [7:0] in, 
    output logic [7:0] out, count
);
    initial count = 0;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 0;
            out <= out;
        end else if (wEN) begin
            count <= count + 1;
            out <= in;
        end
    end
endmodule