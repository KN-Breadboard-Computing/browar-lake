import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, NextTimeStep, ReadOnly, ReadWrite

@cocotb.test
async def jmp_works(dut):
    dut.cpu_clk.value = 0
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
async def bz_works(dut):
    await cocotb.start(Clock(dut.cpu_clk, 4, 'ns').start())
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
    dut.read_a.value = 1
    dut.imm5_a.value = 0
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
