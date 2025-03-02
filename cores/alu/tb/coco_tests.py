import cocotb
from cocotb.triggers import ReadOnly

@cocotb.test
async def add_works(dut):
    dut.a.value = 0x010F
    dut.b.value = 0x0101
    dut.sh_off.value = 4
    dut.truth_table.value = 0x3
    dut.op.value = 0b00001
    await ReadOnly()
    assert dut.flag_carry.value == 0
    assert dut.out.value == 0x0210

@cocotb.test
async def sub_works(dut):
    dut.a.value = 0x0110
    dut.b.value = 0x0101
    dut.sh_off.value = 4
    dut.truth_table.value = 0x3
    dut.op.value = 0b00011
    await ReadOnly()
    assert dut.flag_overflow.value == 0
    assert dut.out.value == 0x000F

@cocotb.test
async def shl_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0x0001
    dut.sh_off.value = 7
    dut.truth_table.value = 0xE
    dut.op.value = 0b00010
    await ReadOnly()
    assert dut.out.value == 0x0080

@cocotb.test
async def shr_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0x0080
    dut.sh_off.value = 7
    dut.truth_table.value = 0xE
    dut.op.value = 0b00110
    await ReadOnly()
    assert dut.out.value == 0x0001

@cocotb.test
async def rol_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0xABCD
    dut.sh_off.value = 4
    dut.truth_table.value = 0xE
    dut.op.value = 0b00000
    await ReadOnly()
    assert dut.out.value == 0xBCDA

@cocotb.test
async def ror_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0xABCD
    dut.sh_off.value = 4
    dut.truth_table.value = 0xE
    dut.op.value = 0b00100
    await ReadOnly()
    assert dut.out.value == 0xDABC

@cocotb.test
async def sar_works(dut):
    dut.a.value = 0x0000
    dut.b.value = 0x8AAA
    dut.sh_off.value = 4
    dut.truth_table.value = 0xE
    dut.op.value = 0b01110
    await ReadOnly()
    assert dut.out.value == 0xF8AA
