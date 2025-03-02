module mux8 (
    /* verilator lint_off ASCRANGE */
    input wire [0:7] x,
    /* verilator lint_on ASCRANGE */
    input wire [2:0] sel,
    input wire g, // active low
    output wire y
);

assign y = x[sel] & ~g;

endmodule
