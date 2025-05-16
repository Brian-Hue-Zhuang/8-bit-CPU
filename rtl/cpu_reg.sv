/*
    Primary Registers, will be the ones instructions refer to
*/
module cpu_reg (
    input logic [7:0] in
    input logic [2:0] store,
    input logic r, w, clk, rst, rEN, wEN,
    inout logic [7:0] data_bus
);
    //Tri-state Buffer
    assign data_bus = (rEN) ? registers[store] : 8'bz;
    assign data_bus = (wEN) ? in : data_bus; 

    logic [7:0] registers [0:7];
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            data_bus <= 0;
            for (int i = 0; i < 8; i++) begin
                registers[i] <= 0;
            end
        end else if (wEN) begin
            registers[store] <= data_bus;
            $display("[cpu_reg] loading = %0h into fsm", data_bus);
        end
    end
endmodule