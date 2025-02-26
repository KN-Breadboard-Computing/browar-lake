import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, NextTimeStep, ReadOnly

@cocotb.test
async def r0_read(dut):
    dut.src_a.value = 0x00
    dut.src_b.value = 0x00
    await ReadOnly()
    assert dut.a_out.value == 0x0000
    assert dut.b_out.value == 0x0000

@cocotb.test
async def r0_write(dut):
    clk_cpu = Clock(dut.cpu_clk, 2, 'ns')
    await cocotb.start(clk_cpu.start(start_high=False))
    dut.src_w.value = 0x00
    dut.we.value = 1
    dut.val.value = 0xDEAD
    await RisingEdge(dut.cpu_clk)
    dut.src_a.value = 0x00
    dut.src_b.value = 0x00
    await ReadOnly()
    assert dut.a_out.value == 0x0000
    assert dut.b_out.value == 0x0000

@cocotb.test
async def read_write(dut):
    clk_cpu = Clock(dut.cpu_clk, 2, 'ns')
    await cocotb.start(clk_cpu.start(start_high=False))

    for reg in range(1, 16):
        dut.src_w.value = reg
        dut.we.value = 1
        dut.val.value = 0x7E00 | reg
        await RisingEdge(dut.cpu_clk)
        dut.we.value = 0
        dut.src_a.value = reg
        dut.src_b.value = reg
        await ReadOnly()
        assert dut.a_out.value == (0x7E00 | reg)
        assert dut.b_out.value == (0x7E00 | reg)
        await NextTimeStep()
        if reg >= 2:
            dut.src_a.value = reg - 1
            dut.src_b.value = reg - 1
            await ReadOnly()
            assert dut.a_out.value == (0x7E00 | (reg - 1))
            assert dut.b_out.value == (0x7E00 | (reg - 1))
            await NextTimeStep()
