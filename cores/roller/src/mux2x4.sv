module mux2x4(
    /* verilator lint_off ASCRANGE */
    input wire [0:1] a, // aA, aB
    input wire [0:1] b,
    input wire [0:1] c,
    input wire [0:1] d,
    /* verilator lint_on ASCRANGE */
    input wire sel,
    input wire g,
    output wire a_y,
    output wire b_y,
    output wire c_y,
    output wire d_y
);

assign a_y = (sel ? a[1] : a[0]) & ~g;
assign b_y = (sel ? b[1] : b[0]) & ~g;
assign c_y = (sel ? c[1] : c[0]) & ~g;
assign d_y = (sel ? d[1] : d[0]) & ~g;

endmodule
