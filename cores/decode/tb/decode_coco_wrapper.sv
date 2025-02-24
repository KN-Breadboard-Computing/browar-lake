module decode_coco_wrapper(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire [15:0] ins,
    input wire ins_en,
    input wire [15:0] ext,
    output logic read_a,
    output logic imm5_a,
    output logic [4:0] arg_a,
    output logic read_b,
    output logic [3:0] src_b,
    output logic set_pc,
    output logic add_pc,
    output logic [2:0] cmp_b
);

decode dut(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .ins(ins),
    .ins_en(ins_en),
    .ext(ext),
    .read_a(read_a),
    .imm5_a(imm5_a),
    .arg_a(arg_a),
    .read_b(read_b),
    .src_b(src_b),
    .set_pc(set_pc),
    .add_pc(add_pc),
    .cmp_b(cmp_b)
);

initial begin
    $dumpfile("dec_test.fst");
    $dumpvars(0,decode_coco_wrapper);
end

endmodule
