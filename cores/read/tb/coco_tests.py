import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, NextTimeStep, ReadOnly, ReadWrite

@cocotb.test
async def jmp_works(dut):
    dut.cpu_clk.value = 0
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b110
    dut.pc_set.value = 1
    dut.pc_add.value = 0
    dut.pc_src.value = 0b11
    dut.reg_a_value.value = 0x001E
    dut.reg_b_value.value = 0x1001
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set == 1
    assert dut.o_pc_add == 0
    assert dut.pc.value == (0x1001001E >> 1)

@cocotb.test
async def bn_works(dut):
    dut.cpu_clk.value = 0
    dut.imm_en.value = 1
    dut.arg_imm.value = 0x0F
    dut.read_a.value = 0
    dut.arg_a.value = 0x00
    dut.read_b.value = 1
    dut.arg_b.value = 0x6
    dut.cmp_b.value = 0b001
    dut.pc_set.value = 0
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.en_regs = 0b00
    dut.reg_b_value.value = 0x0000
    await ReadOnly()
    assert dut.reg_a_read.value == 0
    assert dut.reg_b_read.value == 1
    assert dut.reg_b.value == 0x6
    assert dut.o_pc_set == 0
    assert dut.o_pc_add == 1
    assert dut.pc.value == (0x0000001E >> 1)

@cocotb.test
async def bz_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b001 # bz
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x001E
    dut.reg_b_value.value = 0x0000
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set == 0
    assert dut.o_pc_add == 1
    assert dut.o_pc_inc == 0
    assert dut.pc.value == (0x0000001E >> 1)

    await NextTimeStep()
    await RisingEdge(dut.cpu_clk)
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b001 # bz
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x001E
    dut.reg_b_value.value = 0x0001
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set.value == 0
    assert dut.o_pc_add.value == 0
    assert dut.o_pc_inc.value == 1
    assert dut.pc.value == (0x0000001E >> 1)

@cocotb.test
async def bnz_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b011
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x0024
    dut.reg_b_value.value = 0x0001
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set == 0
    assert dut.o_pc_add == 1
    assert dut.o_pc_inc == 0
    assert dut.pc.value == (0x00000024 >> 1)

    await NextTimeStep()
    await RisingEdge(dut.cpu_clk)
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b011 # bnz
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x0024
    dut.reg_b_value.value = 0x0000
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set.value == 0
    assert dut.o_pc_add.value == 0
    assert dut.o_pc_inc.value == 1
    assert dut.pc.value == (0x00000024 >> 1)

@cocotb.test
async def bgez_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b101 # gez
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x0052
    dut.reg_b_value.value = 0x7009
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set == 0
    assert dut.o_pc_add == 1
    assert dut.o_pc_inc == 0
    assert dut.pc.value == (0x00000052 >> 1)

    await NextTimeStep()
    await RisingEdge(dut.cpu_clk)
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b101 # gez
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x0052
    dut.reg_b_value.value = 0x8000
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set.value == 0
    assert dut.o_pc_add.value == 0
    assert dut.o_pc_inc.value == 1
    assert dut.pc.value == (0x00000052 >> 1)

@cocotb.test
async def blez_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b111 # lez
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x00F0
    dut.reg_b_value.value = 0x8FF0
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set == 0
    assert dut.o_pc_add == 1
    assert dut.o_pc_inc == 0
    assert dut.pc.value == (0x000000F0 >> 1)

    await NextTimeStep()
    await RisingEdge(dut.cpu_clk)
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0x09
    dut.read_b.value = 1
    dut.arg_b.value = 0x0A
    dut.cmp_b.value = 0b111 # lez
    dut.pc_set.value = 0
    dut.pc_inc.value = 1
    dut.pc_add.value = 1
    dut.pc_src.value = 0b01
    dut.reg_a_value.value = 0x00F0
    dut.reg_b_value.value = 0x7FFF
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x9
    assert dut.reg_b.value == 0xA
    assert dut.o_pc_set.value == 0
    assert dut.o_pc_add.value == 0
    assert dut.o_pc_inc.value == 1
    assert dut.pc.value == (0x000000F0 >> 1)

@cocotb.test
async def add_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.cpu_rst.value = 0
    dut.imm_en.value = 0
    dut.arg_imm.value = 0x00
    dut.read_a.value = 1
    dut.arg_a.value = 0xA
    dut.read_b.value = 1
    dut.arg_b.value = 0x5
    dut.cmp_b.value = 0b000 # bz
    dut.pc_set.value = 0
    dut.pc_inc.value = 0
    dut.pc_add.value = 0
    dut.pc_src.value = 0b00
    dut.en_regs.value = 0b11
    dut.reg_a_value.value = 0x001E
    dut.reg_b_value.value = 0x1E00
    dut.i_alu_en.value = 1
    dut.i_truth_table.value = 0b0000
    dut.i_alu_op.value = 0b00001
    dut.sh_off_imm.value = 0
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0xA
    assert dut.reg_b.value == 0x5

    await NextTimeStep()
    await RisingEdge(dut.cpu_clk)
    await ReadOnly()
    assert dut.src_a.value == 0x001E
    assert dut.src_a_en.value == 1
    assert dut.src_b.value == 0x1E00
    assert dut.src_b_en.value == 1
    assert dut.o_alu_en.value == 1
    assert dut.o_truth_table.value == 0b0000
    assert dut.o_alu_op.value == 0b00001
    assert dut.sh_off_imm.value == 0

@cocotb.test
async def shlimm_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.cpu_rst.value = 0
    dut.imm_en.value = 1
    dut.arg_imm.value = 0x0F
    dut.read_a.value = 1
    dut.arg_a.value = 0x0
    dut.read_b.value = 1
    dut.arg_b.value = 0x7
    dut.cmp_b.value = 0b000 # bz
    dut.pc_set.value = 0
    dut.pc_inc.value = 0
    dut.pc_add.value = 0
    dut.pc_src.value = 0b00
    dut.en_regs.value = 0b11
    dut.reg_a_value.value = 0x0000
    dut.reg_b_value.value = 0x8811
    dut.i_alu_en.value = 1
    dut.i_truth_table.value = 0b1110
    dut.i_alu_op.value = 0b00001
    dut.sh_off_imm.value = 1
    await ReadOnly()
    assert dut.reg_a_read.value == 1
    assert dut.reg_b_read.value == 1
    assert dut.reg_a.value == 0x0
    assert dut.reg_b.value == 0x7

    await NextTimeStep()
    await RisingEdge(dut.cpu_clk)
    await ReadOnly()
    assert dut.src_a.value == 0x0000
    assert dut.src_a_en.value == 1
    assert dut.src_b.value == 0x8811
    assert dut.src_b_en.value == 1
    assert dut.o_alu_en.value == 1
    assert dut.o_truth_table.value == 0b1110
    assert dut.o_alu_op.value == 0b00001
    assert dut.sh_off == 0xF
