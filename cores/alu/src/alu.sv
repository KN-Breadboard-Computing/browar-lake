module alu(
    input wire en,
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] sh_off,
    input wire [3:0] truth_table,
    input wire [4:0] op,
    input wire [3:0] i_dst,
    output logic flag_carry,
    output logic flag_overflow,
    output logic [3:0] o_dst,
    output logic out_en,
    output logic [15:0] out
);

wire [15:0] roller_out;
wire [15:0] adder_out;
wire [15:0] logic_out;

wire add_en;
wire shift_en;
assign add_en = op[0];

roller roller(
    .x(b | { 15'h0, op[4] }),
    .off(sh_off),
    .shift(op[1]),
    .right(op[2]),
    .arith(op[3]),
    .y(roller_out)
);

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        assign logic_out[i] = truth_table[{ a[i], roller_out[i] }];
    end
endgenerate

adder adder(
    .c_in(op[2]),
    .sub(op[1]),
    .a(a),
    .b(b),
    .c_out(flag_carry),
    .b_out(flag_overflow),
    .sum(adder_out)
);

assign out = en ? (add_en ? adder_out : logic_out) : 16'hZZZZ;
assign out_en = en;
assign o_dst = i_dst;

endmodule
