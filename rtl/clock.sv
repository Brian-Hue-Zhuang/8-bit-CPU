/*
    Synced Clock for the entire program
*/
module clock (
    input logic clk, rst,
    input logic [3:0] limit, //Not sure how this input will be given yet, may be unnecessary
    output logic hzX
);
    logic [3:0] counter;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            hzX <= 0;
        end else if (limit == 0) begin
            hzX <= 0;
        end else if (counter == limit) begin
            counter <= 0;
            hzX <= ~hzX;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule