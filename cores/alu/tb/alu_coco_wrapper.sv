module alu_coco_wrapper(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] sh_off,
    input wire [3:0] truth_table,
    input wire [4:0] op,
    output wire flag_carry,
    output wire flag_overflow,
    output wire [15:0] out
);

alu dut(
    .a(a),
    .b(b),
    .sh_off(sh_off),
    .truth_table(truth_table),
    .op(op),
    .flag_carry(flag_carry),
    .flag_overflow(flag_overflow),
    .out(out)
);

initial begin
    $dumpfile("alu.fst");
    $dumpvars(0,dut);
end

endmodule
