module sklansky(
    input wire cin,
    input wire [15:0] a,
    input wire [15:0] b,
    output wire cout,
    output wire cint,
    output wire [15:0] sum
);

`define G(g, p, i, off) (g[i+off] | (p[i+off] & g[i]))
`define P(p, i, off) (p[i+off] & p[i])
`define G1(g, p, i) `G(g, p, i, 1)
`define P1(p, i) `P(p, i, 1)
`define G2(g, p, i) {`G(g, p, i, 2), `G(g, p, i, 1)}
`define P2(p, i) {`P(p, i, 2), `P(p, i, 1)}
`define G3(g, p, i) {`G(g, p, i, 4), `G(g, p, i, 3), `G(g, p, i, 2), `G(g, p, i, 1)}
`define P3(p, i) {`P(p, i, 4), `P(p, i, 3), `P(p, i, 2), `P(p, i, 1)}

// Stage 0
wire [15:0] g0;
wire [15:0] h0;

assign g0 = a & b;
assign h0 = a ^ b;

// Stage 1

wire [15:0] g1;
wire [15:0] p1;

assign g1 = { `G1(g0, h0, 14), g0[14], `G1(g0, h0, 12), g0[12], `G1(g0, h0, 10), g0[10], `G1(g0, h0, 8), g0[8], `G1(g0, h0, 6), g0[6], `G1(g0, h0, 4), g0[4], `G1(g0, h0, 2), g0[2], `G1(g0, h0, 0), g0[0] };
assign p1 = { `P1(h0, 14), h0[14], `P1(h0, 12), h0[12], `P1(h0, 10), h0[10], `P1(h0, 8), h0[8], `P1(h0, 6), h0[6], `P1(h0, 4), h0[4], `P1(h0, 2), h0[2], `P1(h0, 0), h0[0] };

// Stage 2

wire [15:0] g2;
wire [15:0] p2;

assign g2 = { `G2(g1, p1, 13), g1[13], g1[12], `G2(g1, p1, 9), g1[9], g1[8], `G2(g1, p1, 5), g1[5], g1[4], `G2(g1, p1, 1), g1[1], g1[0] };
assign p2 = { `P2(p1, 13), p1[13], p1[12], `P2(p1, 9), p1[9], p1[8], `P2(p1, 5), p1[5], p1[4], `P2(p1, 1), p1[1], p1[0] };

// Stage 3

wire [15:0] g3;
wire [15:0] p3;

assign g3 = { `G3(g2, p2, 11), g2[11:8], `G3(g2, p2, 3), g2[3:0] };
assign p3 = { `P3(p2, 11), p2[11:8], `P3(p2, 3), p2[3:0] };

// Stage 4

wire [15:0] g4;
wire [15:0] p4;

assign g4 = { `G(g3, p3, 7, 8), `G(g3, p3, 7, 7), `G(g3, p3, 7, 6), `G(g3, p3, 7, 5), `G(g3, p3, 7, 4), `G(g3, p3, 7, 3), `G(g3, p3, 7, 2), `G(g3, p3, 7, 1), g3[7:0] };
assign p4 = { `P(p3, 7, 8), `P(p3, 7, 7), `P(p3, 7, 6), `P(p3, 7, 5), `P(p3, 7, 4), `P(p3, 7, 3), `P(p3, 7, 2), `P(p3, 7, 1), p3[7:0] };

// Stage 5

wire [15:0] c;
assign c = ({16{cin}} & p4) | g4;

assign sum = { c[14:0], cin } ^ h0;
assign cout = c[15];
assign cint = c[14];

endmodule
