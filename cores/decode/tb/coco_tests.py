import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, NextTimeStep

async def test_decode(dut, ins, ext=None, *, 
                      read_a, imm5_a, arg_a, read_b, src_b, set_pc, add_pc, cmp_b):
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_cpu.start())

    dut.cpu_rst.value = 0
    if type(ins) == bool:
        dut.cpu_rst.value = ins
    else:
        assert type(ins) == int
        dut.ins.value = ins & 0xFFFF
        dut.ins_en.value = 1
        if ext is not None:
            dut.ext.value = ext
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert dut.read_a.value == read_a
    assert dut.imm5_a.value == imm5_a
    assert dut.arg_a.value == arg_a
    assert dut.read_b.value == read_b
    assert dut.src_b.value == src_b
    assert dut.set_pc.value == set_pc
    assert dut.add_pc.value == add_pc
    assert dut.cmp_b.value == cmp_b


@cocotb.test
async def reset_works(dut):
    await test_decode(dut, True, 
                      read_a=0,
                      imm5_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      cmp_b=0)

@cocotb.test
async def jmpimm_works(dut):
    await test_decode(dut, 0x7B99, 
                      read_a=0,
                      imm5_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      cmp_b=0)
    await test_decode(dut, 0x7B99, 0xDEAD, 
                      read_a=0,
                      imm5_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      cmp_b=0)

@cocotb.test
async def jmp_works(dut):
    await test_decode(dut, 0x7E6C,
                      read_a=1,
                      imm5_a=0,
                      arg_a=0x0B,
                      read_b=1,
                      src_b=0x09,
                      set_pc=1,
                      add_pc=0,
                      cmp_b=0)

@cocotb.test
async def bn_works(dut):
    # bn.z
    await test_decode(dut, 0x719E,
                      read_a=0,
                      imm5_a=1,
                      arg_a=0x0F,
                      read_b=1,
                      src_b=0x06,
                      set_pc=0,
                      add_pc=1,
                      cmp_b=0b001)
    # bn.nz
    await test_decode(dut, 0x71BF,
                      read_a=0,
                      imm5_a=1,
                      arg_a=0x1F,
                      read_b=1,
                      src_b=0x06,
                      set_pc=0,
                      add_pc=1,
                      cmp_b=0b011)

@cocotb.test
async def b_works(dut):
    # b.z
    await test_decode(dut, 0x75D8,
                      read_a=1,
                      imm5_a=0,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      cmp_b=0b001)
    # b.nz
    await test_decode(dut, 0x75D9,
                      read_a=1,
                      imm5_a=0,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      cmp_b=0b011)
    # b.gtz
    await test_decode(dut, 0x75DA,
                      read_a=1,
                      imm5_a=0,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      cmp_b=0b101)
    # b.ltz
    await test_decode(dut, 0x75DB,
                      read_a=1,
                      imm5_a=0,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      cmp_b=0b111)
