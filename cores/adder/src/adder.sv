module adder(
    input wire c_in,
    input wire sub,
    input wire [15:0] a,
    input wire [15:0] b,
    output logic c_out,
    output logic b_out,
    output logic [15:0] sum
);

wire cint;

sklansky ppa(
    .cin(c_in ^ sub),
    .a(a),
    .b(b ^ {16{sub}}),
    .cout(c_out),
    .cint(cint),
    .sum(sum)
);

assign b_out = c_out ^ cint;

endmodule
