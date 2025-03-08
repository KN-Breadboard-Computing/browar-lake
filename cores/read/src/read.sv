module read(
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

    input wire [3:0] i_dst,
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

    output logic [3:0] o_dst,
    output logic o_alu_en,
    output logic [3:0] o_truth_table,
    output logic [4:0] o_alu_op,
    output logic [3:0] sh_off,

    output logic o_mem_en,
    output logic o_mem_write,
    output logic [31:0] mem_addr
);

wire [15:0] a_bus;
wire [15:0] b_bus;

assign a_bus = (exe_en && exe_dst_reg == reg_a) ? exe_out :
               ( wb_en &&  wb_dst_reg == reg_a) ? wb_out  : reg_a_value;
assign b_bus = (exe_en && exe_dst_reg == reg_b) ? exe_out : 
               ( wb_en &&  wb_dst_reg == reg_b) ? wb_out  : reg_b_value;

assign reg_a_read = read_a;
assign reg_a = arg_a[3:0];
assign reg_b_read = read_b;
assign reg_b = arg_b[3:0];

wire [14:0] pc_lo;
wire [15:0] pc_hi;

wire b_zero;
wire b_neg;
wire cond;
assign b_zero = reg_b_value[0] | reg_b_value[1] | reg_b_value[2] | reg_b_value[3] | reg_b_value[4] | reg_b_value[5] | reg_b_value[6] | reg_b_value[7] | reg_b_value[8] | reg_b_value[9] | reg_b_value[10] | reg_b_value[11] | reg_b_value[12] | reg_b_value[13] | reg_b_value[14] | reg_b_value[15];
assign b_neg = reg_b_value[15];
assign cond = (cmp_b[2] ? (~b_neg ^ cmp_b[1]) : (~b_zero ^ cmp_b[1]));

assign pc_lo = pc_src[0] ? (read_a ? reg_a_value[15:1] : (imm_en ? { {10{arg_imm[4]}}, arg_imm } : 15'h0)) : 15'h0;
assign pc_hi = pc_src[1] ? reg_b_value : { 16{pc_lo[14]} };
assign pc = { pc_hi, pc_lo };
assign o_pc_set = pc_set & (~cmp_b[0] | cond);
assign o_pc_add = pc_add & (~cmp_b[0] | cond);
assign o_pc_inc = pc_inc & (~cmp_b[0] | ~cond);

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
        if (read_a) begin
            src_a <= a_bus;
            src_a_en <= en_regs[0];
        end
        if (read_b) begin
            src_b <= b_bus;
            src_b_en <= en_regs[1];
        end
    end
end

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
        o_dst <= i_dst;

        o_alu_en <= i_alu_en;
        o_truth_table <= i_truth_table;
        o_alu_op <= i_alu_op;
        if (sh_off_imm) sh_off <= arg_imm[3:0];
        else sh_off <= reg_a_value[3:0];

        o_mem_en <= i_mem_en;
        o_mem_write <= i_mem_write;
        mem_addr <= { reg_b_value, reg_a_value };
    end
end


endmodule
