module decode_coco_wrapper(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire [15:0] ins,
    input wire ins_en,
    input wire [15:0] ext,
    output logic imm_en,
    output logic [4:0] arg_imm,
    output logic read_a,
    output logic [3:0] arg_a,
    output logic read_b,
    output logic [3:0] src_b,
    output logic read_c,
    output logic [3:0] src_c,
    output logic set_pc,
    output logic add_pc,
    output logic inc_pc,
    output logic [1:0] pc_src,
    output logic [2:0] cmp_b,
    output logic [2:0] out_regs,
    output logic alu_en,
    output logic sh_off_imm,
    output logic [3:0] truth_table,
    output logic [4:0] alu_op,
    output logic [3:0] dst,
    output logic mem_en,
    output logic mem_write
);

decode dut(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .ins(ins),
    .ins_en(ins_en),
    .ext(ext),
    .imm_en(imm_en),
    .arg_imm(arg_imm),
    .read_a(read_a),
    .arg_a(arg_a),
    .read_b(read_b),
    .src_b(src_b),
    .read_c(read_c),
    .src_c(src_c),
    .set_pc(set_pc),
    .add_pc(add_pc),
    .inc_pc(inc_pc),
    .pc_src(pc_src),
    .cmp_b(cmp_b),
    .out_regs(out_regs),
    .alu_en(alu_en),
    .sh_off_imm(sh_off_imm),
    .truth_table(truth_table),
    .alu_op(alu_op),
    .dst(dst),
    .mem_en(mem_en),
    .mem_write(mem_write)
);

initial begin
    $dumpfile("dec_test.fst");
    $dumpvars(0,decode_coco_wrapper);
end

endmodule
