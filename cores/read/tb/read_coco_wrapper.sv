module read_coco_wrapper(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire read_a,
    input wire imm5_a,
    input wire [4:0] arg_a,
    input wire read_b,
    input wire [3:0] arg_b,
    input wire [2:0] cmp_b,
    input wire pc_set,
    input wire pc_add,
    input wire pc_inc,
    input wire [1:0] pc_src,

    input wire [15:0] reg_a_value,
    input wire [15:0] reg_b_value,
    output logic reg_a_read,
    output logic [3:0] reg_a,
    output logic reg_b_read,
    output logic [3:0] reg_b,

    output logic src_a_en,
    output logic [15:0] src_a,
    output logic src_b_en,
    output logic [15:0] src_b,

    output logic o_pc_set,
    output logic o_pc_add,
    output logic o_pc_inc,
    output logic [30:0] pc
);

read dut(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .read_a(read_a),
    .imm5_a(imm5_a),
    .arg_a(arg_a),
    .read_b(read_b),
    .arg_b(arg_b),
    .cmp_b(cmp_b),
    .pc_set(pc_set),
    .pc_add(pc_add),
    .pc_inc(pc_inc),
    .pc_src(pc_src),

    .reg_a_value(reg_a_value),
    .reg_b_value(reg_b_value),
    .reg_a_read(reg_a_read),
    .reg_a(reg_a),
    .reg_b_read(reg_b_read),
    .reg_b(reg_b),

    .src_a_en(src_a_en),
    .src_a(src_a),
    .src_b_en(src_b_en),
    .src_b(src_b),

    .o_pc_set(o_pc_set),
    .o_pc_add(o_pc_add),
    .o_pc_inc(o_pc_inc),
    .pc(pc)
);

initial begin
    $dumpfile("read.fst");
    $dumpvars(0, dut);
end

endmodule
