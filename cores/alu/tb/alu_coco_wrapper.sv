module alu_coco_wrapper(
    input wire en,
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] i_dst,
    input wire [3:0] sh_off,
    input wire [3:0] truth_table,
    input wire [4:0] op,
    output wire flag_carry,
    output wire flag_overflow,
    output wire out_en,
    output wire [15:0] out,
    output wire [3:0] o_dst
);

alu dut(
    .en(en),
    .a(a),
    .b(b),
    .i_dst(i_dst),
    .sh_off(sh_off),
    .truth_table(truth_table),
    .op(op),
    .flag_carry(flag_carry),
    .flag_overflow(flag_overflow),
    .out_en(out_en),
    .out(out),
    .o_dst(o_dst)
);

initial begin
    $dumpfile("alu.fst");
    $dumpvars(0,dut);
end

endmodule
