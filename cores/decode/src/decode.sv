`include "opcodes.svh"

module decode(
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
    output logic [1:0] pc_src,
    output logic set_pc,
    output logic add_pc,
    output logic inc_pc,
    output logic [2:0] cmp_b,
    output logic [1:0] out_regs
);

`define REG_A(bus) bus[5:2]
`define REG_B(bus) bus[9:6]
`define IMM5(bus) bus[5:1]
`define FN1(bus) bus[0]
`define FN2(bus) bus[1:0]

always_ff @(posedge cpu_clk) begin
    if (cpu_rst) begin
        arg_a <= 5'b00000;
        read_a <= 1'b0;
        imm5_a <= 1'b0;
        src_b <= 4'h0;
        read_b <= 1'b0;
        set_pc <= 1'b0;
        add_pc <= 1'b0;
        inc_pc <= 1'b0;
        cmp_b <= 3'b000;
        pc_src <= 2'b00;
        out_regs <= 2'b00;
    end else if (ins_en) begin
        case (`OPCODE(ins)) 
            `OPCODE_JMPIMM: begin
                arg_a <= 5'b00000;
                read_a <= 1'b0;
                imm5_a <= 1'b0;
                src_b <= 4'h0;
                read_b <= 1'b0;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b000;
                pc_src <= 2'b00;
                out_regs <= 2'b00;
            end
            `OPCODE_JMP: begin
                arg_a <= { 1'b0, `REG_A(ins) };
                read_a <= 1'b1;
                imm5_a <= 1'b0;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b1;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b000;
                pc_src <= 2'b11;
                out_regs <= 2'b00;
            end
            `OPCODE_BN: begin
                arg_a <= `IMM5(ins);
                read_a <= 1'b0;
                imm5_a <= 1'b1;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b1;
                inc_pc <= 1'b1;
                cmp_b <= { 1'b0, `FN1(ins), 1'b1 };
                pc_src <= 2'b01;
                out_regs <= 2'b00;
            end
            `OPCODE_B: begin
                arg_a <= { 1'b0, `REG_A(ins) };
                read_a <= 1'b1;
                imm5_a <= 1'b0;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b1;
                inc_pc <= 1'b1;
                cmp_b <= { `FN2(ins), 1'b1 };
                pc_src <= 2'b01;
                out_regs <= 2'b00;
            end
            default: begin
                arg_a <= 5'b00000;
                read_a <= 1'b0;
                imm5_a <= 1'b0;
                src_b <= 4'h0;
                read_b <= 1'b0;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b000;
                pc_src <= 2'b00;
                out_regs <= 2'b00;
            end
        endcase
    end
end

endmodule
