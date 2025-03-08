module read_coco_wrapper(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire imm_en,
    input wire [4:0] arg_imm,
    input wire read_a,
    input wire [3:0] arg_a,
    input wire read_b,
    input wire [3:0] arg_b,
    input wire [2:0] cmp_b,
    input wire pc_set,
    input wire pc_add,
    input wire pc_inc,
    input wire [1:0] pc_src,
    input wire [1:0] en_regs,

    input wire i_alu_en,
    input wire [3:0] i_truth_table,
    input wire [4:0] i_alu_op,
    input wire sh_off_imm,

    input wire i_mem_en,
    input wire i_mem_write,

    input wire [15:0] exe_out,
    input wire [3:0] exe_dst_reg,
    input wire exe_en,
    input wire [15:0] wb_out,
    input wire [3:0] wb_dst_reg,
    input wire wb_en,

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
    output logic [30:0] pc,

    output logic o_alu_en,
    output logic [3:0] o_truth_table,
    output logic [4:0] o_alu_op,
    output logic [3:0] sh_off,

    output logic o_mem_en,
    output logic o_mem_write,
    output logic [31:0] mem_addr
);

read dut(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .imm_en(imm_en),
    .arg_imm(arg_imm),
    .read_a(read_a),
    .arg_a(arg_a),
    .read_b(read_b),
    .arg_b(arg_b),
    .cmp_b(cmp_b),
    .pc_set(pc_set),
    .pc_add(pc_add),
    .pc_inc(pc_inc),
    .pc_src(pc_src),
    .en_regs(en_regs),

    .i_alu_en(i_alu_en),
    .i_truth_table(i_truth_table),
    .i_alu_op(i_alu_op),
    .sh_off_imm(sh_off_imm),

    .i_mem_en(i_mem_en),
    .i_mem_write(i_mem_write),
    
    .exe_out(exe_out),
    .exe_dst_reg(exe_dst_reg),
    .exe_en(exe_en),
    .wb_out(wb_out),
    .wb_dst_reg(wb_dst_reg),
    .wb_en(wb_en),

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
    .pc(pc),

    .o_alu_en(o_alu_en),
    .o_truth_table(o_truth_table),
    .o_alu_op(o_alu_op),
    .sh_off(sh_off),
    
    .o_mem_en(o_mem_en),
    .o_mem_write(o_mem_write),
    .mem_addr(mem_addr)
);

initial begin
    $dumpfile("read.fst");
    $dumpvars(0, dut);
end

endmodule
