module cpu_wb(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire clk_i,
    input wire [31:0] dat_i,
    input wire rst_i,
    input wire ack_i,
    output wire [31:0] dat_o,
    output wire [29:0] adr_o,
    output wire cyc_o,
    output wire [3:0] sel_o,
    output wire stb_o,
    output wire we_o
);

wire [29:0] ins_addr;
wire [31:0] ins_data;
wire ins_req;
wire ins_res;
wire fetch_stall;

wire [31:0] mem_addr;
wire [7:0] mem_data_in;
wire [7:0] mem_data_out;
wire mem_en;
wire mem_req;
wire mem_we;
wire mem_res;
wire mem_stall;

mru mru(
    .ins_en(ins_req),
    .ins_addr({ ins_addr, 1'b0 }),
    .ins_ext(1'b1),
    .mem_en(mem_en),
    .mem_addr(mem_addr),
    .mem_we(mem_we),
    .mem_data_i(mem_data_in),
    .clk_i(clk_i),
    .dat_i(dat_i),
    .rst_i(rst_i),
    .ack_i(ack_i),
    .ins_stl(fetch_stall),
    .ins_ack(ins_res),
    .ins_data(ins_data),
    .mem_stl(mem_stall),
    .mem_ack(mem_res),
    .mem_data_o(mem_data_out),
    .dat_o(dat_o),
    .adr_o(adr_o),
    .cyc_o(cyc_o),
    .sel_o(sel_o),
    .stb_o(stb_o),
    .we_o(we_o)
);

wire [15:0] dec_in;
wire [15:0] dec_ext;
wire dec_en;

wire [30:0] pc_bus;
wire pc_add;
wire pc_set;
wire pc_inc;

fetch fetch(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .stall(fetch_stall),
    .ins_res(ins_res),
    .data(ins_data),
    .ins_req(ins_req),
    .addr(ins_addr),
    .ins(dec_in),
    .ins_en(dec_en),
    .ext(dec_ext),
    .pc_en(pc_set),
    .pc_add(pc_add),
    .pc_inc(pc_inc),
    .pc(pc_bus)
);

wire sig_read_a;
wire sig_imm5_a;
wire sig_read_b;
wire sig_read_c;
wire sig_pc_set;
wire sig_pc_add;
wire sig_pc_inc;
wire sig_imm_en;
wire sig_alu_en;
wire sig_sh_off_imm;
wire [1:0] sig_pc_src;
wire [1:0] sig_en_regs;
wire [2:0] sig_cmp_b;
wire [3:0] sig_arg_a;
wire [3:0] sig_arg_b;
wire [3:0] sig_arg_c;
wire [3:0] sig_dst;
wire [3:0] sig_truth_table;
wire [4:0] sig_arg_imm;
wire [4:0] sig_alu_op;
wire sig_mem_en;
wire sig_mem_write;

decode decode(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .ins(dec_in),
    .ins_en(dec_en),
    .ext(dec_ext),
    .imm_en(sig_imm_en),
    .arg_imm(sig_arg_imm),
    .read_a(sig_read_a),
    .arg_a(sig_arg_a),
    .read_b(sig_read_b),
    .src_b(sig_arg_b),
    .read_c(sig_read_c),
    .src_c(sig_arg_c),
    .pc_src(sig_pc_src),
    .set_pc(sig_pc_set),
    .add_pc(sig_pc_add),
    .inc_pc(sig_pc_inc),
    .cmp_b(sig_cmp_b),
    .out_regs(sig_en_regs),
    .alu_en(sig_alu_en),
    .sh_off_imm(sig_sh_off_imm),
    .truth_table(sig_truth_table),
    .alu_op(sig_alu_op),
    .dst(sig_dst),
    .mem_en(sig_mem_en),
    .mem_write(sig_mem_write)
);

wire exe_a_en;
wire exe_b_en;
wire [15:0] exe_a_bus;
wire [15:0] exe_b_bus;
wire [15:0] exe_out;
wire [3:0] exe_dst;
wire exe_out_en;
wire reg_a_read;
wire reg_b_read;
wire [3:0] reg_a;
wire [3:0] reg_b;
wire [15:0] reg_a_out;
wire [15:0] reg_b_out;
wire [3:0] wb_dst;
wire [15:0] wb_out;
wire [3:0] alu_dst;
wire wb_we;
wire alu_en;

read read(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .imm_en(sig_imm_en),
    .arg_imm(sig_arg_imm),
    .read_a(sig_read_a),
    .arg_a(sig_arg_a),
    .read_b(sig_read_b),
    .arg_b(sig_arg_b),
    .read_c(sig_read_c),
    .arg_c(sig_arg_c),
    .cmp_b(sig_cmp_b),
    .pc_set(sig_pc_set),
    .pc_add(sig_pc_add),
    .pc_inc(sig_pc_inc),
    .pc_src(sig_pc_src),
    .en_regs(sig_en_regs),

    .reg_a_value(reg_a_out),
    .reg_b_value(reg_b_out),
    .reg_a_read(reg_a_read),
    .reg_a(reg_a),
    .reg_b_read(reg_b_read),
    .reg_b(reg_b),
   
    .exe_out(exe_out),
    .exe_dst_reg(exe_dst),
    .exe_en(exe_out_en),
    .wb_out(wb_out),
    .wb_dst_reg(wb_dst),
    .wb_en(wb_we),

    .i_dst(sig_dst),
    .i_alu_en(sig_alu_en),
    .i_truth_table(sig_truth_table),
    .i_alu_op(sig_alu_op),
    .sh_off_imm(sig_sh_off_imm),

    .i_mem_en(sig_mem_en),
    .i_mem_write(sig_mem_write),

    .src_a_en(exe_a_en),
    .src_a(exe_a_bus),
    .src_b_en(exe_b_en),
    .src_b(exe_b_bus),

    .o_pc_set(pc_set),
    .o_pc_add(pc_add),
    .o_pc_inc(pc_inc),
    .pc(pc_bus),

    .o_dst(alu_dst),
    .o_alu_en(alu_en),
    .o_truth_table(alu_truth_table),
    .o_alu_op(alu_op),
    .sh_off(alu_sh_off),

    .o_mem_en(mem_en),
    .o_mem_write(mem_we),
    .mem_addr(mem_addr)
);

regs regs(
    .cpu_clk(cpu_clk),
    .src_a_en(reg_a_read),
    .src_a_pop(1'b0),
    .src_a(reg_a),
    .src_b_en(reg_b_read),
    .src_b(reg_b),
    .we(wb_we),
    .src_w(wb_dst),
    .val(wb_out),
    .a_out(reg_a_out),
    .b_out(reg_b_out)
);

wire [3:0] alu_sh_off;
wire [3:0] alu_truth_table;
wire [4:0] alu_op;
wire [3:0] alu_dst_reg;
wire [15:0] alu_out;
wire alu_out_en;

alu alu(
    .a(exe_a_bus),
    .b(exe_b_bus),
    .i_dst(alu_dst),
    .en(alu_en),
    .sh_off(alu_sh_off),
    .truth_table(alu_truth_table),
    .op(alu_op),
    .flag_carry(),
    .flag_overflow(),
    .out(alu_out),
    .out_en(alu_out_en),
    .o_dst(alu_dst_reg)
);

wire [15:0] mau_out;
wire [3:0] mau_dst_reg;
wire mau_out_en;

mau mau(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .write_data(exe_a_bus),
    .data_in(mem_data_out),
    .data_out(mem_data_in),
    .en(mem_en),
    .we(mem_we),
    .mem_res(mem_res),
    .out_en(mau_out_en),
    .i_dst(alu_dst),
    .out(mau_out),
    .o_dst(mau_dst_reg)
);

write write(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .alu_en(alu_out_en),
    .alu_out(alu_out),
    .alu_dst(alu_dst_reg),
    .mau_en(mau_out_en),
    .mau_out(mau_out),
    .mau_dst(mau_dst_reg),
    .exe_en(exe_out_en),
    .exe_out(exe_out),
    .exe_dst(exe_dst),
    .out(wb_out),
    .dst(wb_dst),
    .we(wb_we)
);

endmodule
