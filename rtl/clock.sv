module clock (
    input logic [3:0] limit, //Not sure how this input will be given yet, may be unnecessary
    output logic hzX
);
    logic counter;
    always_comb begin
        if (limit == 0) begin
            hzX = 0;
        end else if (counter == limit) begin
            counter = 0;
            hzX = ~hzX;
        end else begin
            counter = counter + 1;
        end
    end
endmodule