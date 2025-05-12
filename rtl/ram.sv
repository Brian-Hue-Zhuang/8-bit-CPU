module ram (
    input logic clk,
    input logic [7:0] addr,
);
    logic [7:0] ram [0:255];
endmodule