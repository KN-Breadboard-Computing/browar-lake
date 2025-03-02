module roller (
    input wire [15:0] x,
    input wire [3:0] off,
    input wire shift,
    input wire right,
    input wire arith,
    output wire [15:0] y
);

wire [3:0] rot;

assign rot = right ? 5'd16 - { 1'b0, off } : { 1'b0, off };

wire [15:0] mux0_out;
wire [15:0] sh1;
wire [15:0] sh2;
wire [15:0] mask1;
wire [3:0] mask2;
wire [7:0] g1;

wire a;
wire b;
wire c;
wire d;
wire sh;
assign a = off[3];
assign b = off[2];
assign c = off[1];
assign d = off[0];
assign sh = shift;

mux2x4 mg1_0(
    .a({ (b|c|d), 1'b0 }),
    .b({ (b|c), (b&c&d) }),
    .c({ (b|(c&d)), (b&c) }),
    .d({ b, (b&(c|d)) }),
    .sel(right),
    .g(~sh),
    .a_y(g1[0]),
    .b_y(g1[1]),
    .c_y(g1[2]),
    .d_y(g1[3])
);

mux2x4 mg1_4(
    .a({ (b&(c|d)), b }),
    .b({ (b&c), b|(c&d) }),
    .c({ (b&c&d), (b|c) }),
    .d({ 1'b0, (b|c|d) }),
    .sel(right),
    .g(~sh),
    .a_y(g1[4]),
    .b_y(g1[5]),
    .c_y(g1[6]),
    .d_y(g1[7])
);

assign mask1 = { 8'b0, g1 };

assign mask2 = { (sh&a&right), (sh&a&right), (sh&a&~right), (sh&a&~right) };

mux8 m0(
    .x({ x[0], x[15:9] }),
    .sel(rot[2:0]),
    .g(mask1[0]),
    .y(mux0_out[0])
);

mux8 m1(
    .x({ x[1], x[0], x[15:10] }),
    .sel(rot[2:0]),
    .g(mask1[1]),
    .y(mux0_out[1])
);

mux8 m2(
    .x({ x[2], x[1], x[0], x[15:11] }),
    .sel(rot[2:0]),
    .g(mask1[2]),
    .y(mux0_out[2])
);

mux8 m3(
    .x({ x[3], x[2:0], x[15:12] }),
    .sel(rot[2:0]),
    .g(mask1[3]),
    .y(mux0_out[3])
);

mux8 m4(
    .x({ x[4], x[3:0], x[15:13] }),
    .sel(rot[2:0]),
    .g(mask1[4]),
    .y(mux0_out[4])
);

mux8 m5(
    .x({ x[5], x[4:0], x[15:14] }),
    .sel(rot[2:0]),
    .g(mask1[5]),
    .y(mux0_out[5])
);

mux8 m6(
    .x({ x[6], x[5:0], x[15] }),
    .sel(rot[2:0]),
    .g(mask1[6]),
    .y(mux0_out[6])
);

genvar i;
generate
    // generate first shift stage (0..7 left shift)
    for (i = 7; i < 16; i++) begin
        mux8 m0(
            .x({ x[i], x[i - 1], x[i - 2], x[i - 3], x[i - 4], x[i - 5], x[i - 6], x[i - 7] }),
            .sel(rot[2:0]),
            .g(mask1[i]),
            .y(mux0_out[i])
        );
    end
endgenerate

wire m;
assign m = arith & right & x[15];
assign sh1 = (mux0_out | ({ {16{m}} & mask1 }));

generate
    // generate second shift stage (0,8 left shift)
    for (i = 0; i < 4; i++) begin
        mux2x4 m2(
            .a({ sh1[(i * 4)],     sh1[((i * 4) + 8) % 16] }),
            .b({ sh1[(i * 4) + 1], sh1[((i * 4) + 9) % 16] }),
            .c({ sh1[(i * 4) + 2], sh1[((i * 4) + 10) % 16] }),
            .d({ sh1[(i * 4) + 3], sh1[((i * 4) + 11) % 16] }),
            .g(mask2[i]),
            .a_y(sh2[(i * 4) + 0]),
            .b_y(sh2[(i * 4) + 1]),
            .c_y(sh2[(i * 4) + 2]),
            .d_y(sh2[(i * 4) + 3]),
            .sel(rot[3])
        );
    end

endgenerate

assign y = sh2 | ( { {4{mask2[3]}}, {4{mask2[2]}}, {4{mask2[1]}}, {4{mask2[0]}} } & {16{m}} );

endmodule
