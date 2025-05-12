module decoder (
    input logic [7:0] in,
    input logic r, w,
    output logic [3:0] rEN, wEN
    output logic [3:0] addBus
);
    assign addBus = [3:0] in;
    logic [3:0] decode;
    assign decode[3] = ~in[4] && ~in[4];
    assign decode[2] = ~in[4] && w[0];
    assign decode[1] = in[4] && ~w[0];
    assign decode[0] = in[4] && w[0];
    assign rEN = {r && decode[3], r && decode[2], r && decode[1], r && decode[0]};
    assign wEN = {w && decode[3], w && decode[2], w && decode[1], w && decode[0]};
endmodule