`include "opcodes.svh"

module decode(
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
    output logic [1:0] pc_src,
    output logic set_pc,
    output logic add_pc,
    output logic inc_pc,
    output logic [2:0] cmp_b,
    output logic [1:0] out_regs,
    output logic alu_en,
    output logic sh_off_imm,
    output logic [3:0] truth_table,
    output logic [4:0] alu_op,
    output logic [3:0] dst,
    output logic mem_en,
    output logic mem_write
);

`define REG_A(bus) bus[5:2]
`define REG_A3(bus) bus[2:0]
`define REG_B(bus) bus[9:6]
`define REG_B3(bus) bus[5:3]
`define REG_DST(bus) bus[9:6]
`define IMM5(bus) bus[5:1]
`define IMM4(bus) bus[5:2]
`define FN1(bus) bus[0]
`define FN2(bus) bus[1:0]

always_ff @(posedge cpu_clk) begin
    if (cpu_rst) begin
        imm_en <= 1'b0;
        arg_imm <= 5'b00000;
        arg_a <= 4'h0;
        read_a <= 1'b0;
        src_b <= 4'h0;
        read_b <= 1'b0;
        set_pc <= 1'b0;
        add_pc <= 1'b0;
        inc_pc <= 1'b0;
        cmp_b <= 3'b000;
        pc_src <= 2'b00;
        out_regs <= 2'b00;
        alu_en <= 1'b0;
        sh_off_imm <= 1'b0;
        truth_table <= 4'b0000;
        alu_op <= 5'b00000;
        dst <= 4'h0;
        mem_en <= 1'b0;
        mem_write <= 1'b0;
    end else if (ins_en) begin
        case (`OPCODE(ins)) 
            `OPCODE_JMPIMM: begin
                imm_en <= 1'b0;
                arg_imm <= 5'b00000;
                arg_a <= 4'h0;
                read_a <= 1'b0;
                src_b <= 4'h0;
                read_b <= 1'b0;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b000;
                pc_src <= 2'b00;
                out_regs <= 2'b00;
                alu_en <= 1'b0;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= 5'b00000;
                dst <= 4'h0;
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_JMP: begin
                imm_en <= 1'b0;
                arg_imm <= 5'b00000;
                arg_a <= `REG_A(ins);
                read_a <= 1'b1;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b1;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b000;
                pc_src <= 2'b11;
                out_regs <= 2'b00;
                alu_en <= 1'b0;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= 5'b00000;
                dst <= 4'h0;
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_BN: begin
                imm_en <= 1'b1;
                arg_imm <= `IMM5(ins);
                arg_a <= 4'h0;
                read_a <= 1'b0;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b1;
                inc_pc <= 1'b1;
                cmp_b <= { 1'b0, `FN1(ins), 1'b1 };
                pc_src <= 2'b01;
                out_regs <= 2'b00;
                alu_en <= 1'b0;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= 5'b00000;
                dst <= 4'h0;
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_B: begin
                imm_en <= 1'b0;
                arg_imm <= 5'b00000;
                arg_a <= `REG_A(ins);
                read_a <= 1'b1;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b1;
                inc_pc <= 1'b1;
                cmp_b <= { `FN2(ins), 1'b1 };
                pc_src <= 2'b01;
                out_regs <= 2'b00;
                alu_en <= 1'b0;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= 5'b00000;
                dst <= 4'h0;
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_ADDSUB: begin
                imm_en <= 1'b0;
                arg_imm <= 5'b00000;
                arg_a <= `REG_A(ins);
                read_a <= 1'b1;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b0;
                pc_src <= 2'b00;
                out_regs <= 2'b11;
                alu_en <= 1'b1;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= { 3'b000, `FN1(ins), 1'b1 };
                dst <= `REG_B(ins);
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_ROTIMM: begin
                imm_en <= 1'b1;
                arg_imm <= { 1'b0, `IMM4(ins) };
                arg_a <= 4'h0;
                read_a <= 1'b1;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b0;
                pc_src <= 2'b00;
                out_regs <= 2'b10;
                alu_en <= 1'b1;
                sh_off_imm <= 1'b1;
                truth_table <= 4'b1110;
                alu_op <= { 2'b00, `FN1(ins), 2'b00 };
                dst <= `REG_B(ins);
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_SHIMM: begin
                imm_en <= 1'b1;
                arg_imm <= { 1'b0, `IMM4(ins) };
                arg_a <= 4'h0;
                read_a <= 1'b1;
                src_b <= `REG_B(ins);
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b0;
                pc_src <= 2'b00;
                out_regs <= 2'b10;
                alu_en <= 1'b1;
                sh_off_imm <= 1'b1;
                truth_table <= 4'b1110;
                alu_op <= { 1'b0, `FN2(ins), 2'b10 };
                dst <= `REG_B(ins);
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
            `OPCODE_LD3: begin
                imm_en <= 1'b0;
                arg_imm <= 5'b00000;
                arg_a <= { 1'b0, `REG_A3(ins) };
                read_a <= 1'b1;
                src_b <= { 1'b0, `REG_B3(ins) };
                read_b <= 1'b1;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b0;
                pc_src <= 2'b00;
                out_regs <= 2'b00;
                alu_en <= 1'b0;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= 5'b00000;
                dst <= `REG_DST(ins);
                mem_en <= 1'b1;
                mem_write <= 1'b0;
            end
            default: begin
                imm_en <= 1'b0;
                arg_imm <= 5'b00000;
                arg_a <= 4'h0;
                read_a <= 1'b0;
                src_b <= 4'h0;
                read_b <= 1'b0;
                set_pc <= 1'b0;
                add_pc <= 1'b0;
                inc_pc <= 1'b0;
                cmp_b <= 3'b000;
                pc_src <= 2'b00;
                out_regs <= 2'b00;
                alu_en <= 1'b0;
                sh_off_imm <= 1'b0;
                truth_table <= 4'b0000;
                alu_op <= 5'b00000;
                dst <= 4'h0;
                mem_en <= 1'b0;
                mem_write <= 1'b0;
            end
        endcase
    end
end

endmodule
