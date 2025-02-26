module read(
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

assign pc_lo = pc_src[0] ? (read_a ? reg_a_value[15:1] : (imm5_a ? { {10{arg_a[4]}}, arg_a } : 15'h0)) : 15'h0;
assign pc_hi = pc_src[1] ? reg_b_value : { 16{pc_lo[14]} };
assign pc = { pc_hi, pc_lo };
assign o_pc_set = pc_set & (~cmp_b[0] | cond);
assign o_pc_add = pc_add & (~cmp_b[0] | cond);
assign o_pc_inc = pc_inc & (~cmp_b[0] | ~cond);

endmodule
