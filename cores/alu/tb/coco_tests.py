import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge, NextTimeStep

@cocotb.test
async def add_works(dut):
    dut.a.value = 0x010F
    dut.b.value = 0x0101
    dut.sh_off.value = 4
    dut.truth_table.value = 0x3
    dut.op.value = 0b00001
    dut.i_dst.value = 0xD
    dut.en.value = 1
    await ReadOnly()
    assert dut.flag_carry.value == 0
    assert dut.out.value == 0x0210
    assert dut.o_dst.value == 0xD
    assert dut.out_en.value == 1

@cocotb.test
async def sub_works(dut):
    dut.a.value = 0x0110
    dut.b.value = 0x0101
    dut.sh_off.value = 4
    dut.truth_table.value = 0x3
    dut.op.value = 0b00011
    dut.i_dst.value = 0x2
    dut.en.value = 1
    await ReadOnly()
    assert dut.flag_overflow.value == 0
    assert dut.out.value == 0x000F
    assert dut.o_dst.value == 0x2
    assert dut.out_en.value == 1

@cocotb.test
async def shl_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0x0001
    dut.sh_off.value = 7
    dut.truth_table.value = 0xE
    dut.op.value = 0b00010
    dut.i_dst.value = 0x4
    dut.en.value = 1
    await ReadOnly()
    assert dut.out.value == 0x0080
    assert dut.o_dst.value == 0x4
    assert dut.out_en.value == 1

@cocotb.test
async def shr_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0x0080
    dut.sh_off.value = 7
    dut.truth_table.value = 0xE
    dut.op.value = 0b00110
    dut.i_dst.value = 0x5
    dut.en.value = 1
    await ReadOnly()
    assert dut.out.value == 0x0001
    assert dut.o_dst.value == 0x5
    assert dut.out_en.value == 1

@cocotb.test
async def rol_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0xABCD
    dut.sh_off.value = 4
    dut.truth_table.value = 0xE
    dut.op.value = 0b00000
    dut.i_dst.value = 0x7
    dut.en.value = 1
    await ReadOnly()
    assert dut.out.value == 0xBCDA
    assert dut.o_dst.value == 0x7
    assert dut.out_en.value == 1

@cocotb.test
async def ror_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0xABCD
    dut.sh_off.value = 4
    dut.truth_table.value = 0xE
    dut.op.value = 0b00100
    dut.i_dst.value = 0xB
    dut.en.value = 1
    await ReadOnly()
    assert dut.out.value == 0xDABC
    assert dut.o_dst.value == 0xB
    assert dut.out_en.value == 1

@cocotb.test
async def sar_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0x8AAA
    dut.sh_off.value = 4
    dut.truth_table.value = 0xE
    dut.op.value = 0b01110
    dut.i_dst.value = 0xA
    dut.en.value = 1
    await ReadOnly()
    assert dut.out.value == 0xF8AA
    assert dut.i_dst.value == 0xA
    assert dut.out_en.value == 1
