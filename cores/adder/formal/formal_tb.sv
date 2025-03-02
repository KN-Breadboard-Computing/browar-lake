module formal_tb();

reg cin;
reg sub;
reg [15:0] a;
reg [15:0] b;
wire cout;
wire bout;
wire [15:0] y;

adder dut(
    .sub(sub),
    .c_in(cin),
    .a(a),
    .b(b),
    .b_out(bout),
    .c_out(cout),
    .sum(y)
);

always_comb begin
    assert (sub  || { 1'b0, a } + { 1'b0, b } + { 16'h0, cin } == { cout, y });
    assert (!sub || (a - b - { 15'h0, cin } == y));
end

endmodule
