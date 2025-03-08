import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, NextTimeStep

async def test_decode(dut, ins, ext=None, *, 
                      imm_en, arg_imm, read_a, arg_a, read_b, src_b, 
                      set_pc, add_pc, inc_pc, cmp_b, pc_src, out_regs, 
                      alu_en, sh_off_imm, truth_table, alu_op, dst,
                      mem_en, mem_write):
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
    assert dut.imm_en.value == imm_en
    assert dut.arg_imm.value == arg_imm
    assert dut.read_a.value == read_a
    assert dut.arg_a.value == arg_a
    assert dut.read_b.value == read_b
    assert dut.src_b.value == src_b
    assert dut.set_pc.value == set_pc
    assert dut.add_pc.value == add_pc
    assert dut.inc_pc.value == inc_pc
    assert dut.cmp_b.value == cmp_b
    assert dut.pc_src.value == pc_src
    assert dut.out_regs.value == out_regs
    assert dut.alu_en.value == alu_en
    assert dut.sh_off_imm.value == sh_off_imm
    assert dut.truth_table.value == truth_table
    assert dut.alu_op.value == alu_op
    assert dut.dst.value == dst
    assert dut.mem_en.value == mem_en
    assert dut.mem_write.value == mem_write


@cocotb.test
async def reset_works(dut):
    await test_decode(dut, True, 
                      imm_en=0,
                      arg_imm=0,
                      read_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def jmpimm_works(dut):
    # jmpimm
    await test_decode(dut, 0x7B99, 
                      imm_en=0,
                      arg_imm=0,
                      read_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)
    # jmpimm.ext
    await test_decode(dut, 0x7B99, 0xDEAD, 
                      imm_en=0,
                      arg_imm=0,
                      read_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def jmp_works(dut):
    await test_decode(dut, 0x7E6C,
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x0B,
                      read_b=1,
                      src_b=0x09,
                      set_pc=1,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0b11,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def bn_works(dut):
    # bn src, simm5, f1
    # bn.z
    await test_decode(dut, 0x719E,
                      imm_en=1,
                      arg_imm=0x0F,
                      read_a=0,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x06,
                      set_pc=0,
                      add_pc=1,
                      inc_pc=1,
                      cmp_b=0b001,
                      pc_src=0b01,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

    # bn.nz
    await test_decode(dut, 0x71BF,
                      imm_en=1,
                      arg_imm=0x1F,
                      read_a=0,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x06,
                      set_pc=0,
                      add_pc=1,
                      inc_pc=1,
                      cmp_b=0b011,
                      pc_src=0b01,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def b_works(dut):
    # b src, tgt, f2
    # b.z
    await test_decode(dut, 0x75D8,
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      inc_pc=1,
                      cmp_b=0b001,
                      pc_src=0b01,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)
    # b.nz
    await test_decode(dut, 0x75D9,
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      inc_pc=1,
                      cmp_b=0b011,
                      pc_src=0b01,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)
    # b.gtz
    await test_decode(dut, 0x75DA,
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      inc_pc=1,
                      cmp_b=0b101,
                      pc_src=0b01,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)
    # b.ltz
    await test_decode(dut, 0x75DB,
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x06,
                      read_b=1,
                      src_b=0x07,
                      set_pc=0,
                      add_pc=1,
                      inc_pc=1,
                      cmp_b=0b111,
                      pc_src=0b01,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def test_default_case(dut):
    await test_decode(dut, 0x6A56, 
                      imm_en=0,
                      arg_imm=0,
                      read_a=0,
                      arg_a=0,
                      read_b=0,
                      src_b=0,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0,
                      dst=0,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def add_works(dut):
    await test_decode(dut, 0x32D0, 
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x04,
                      read_b=1,
                      src_b=0xB,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b11,
                      alu_en=1,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0b00001,
                      dst=0xB,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def sub_works(dut):
    await test_decode(dut, 0x3169, 
                      imm_en=0,
                      arg_imm=0,
                      read_a=1,
                      arg_a=0x0A,
                      read_b=1,
                      src_b=0x5,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b11,
                      alu_en=1,
                      sh_off_imm=0,
                      truth_table=0,
                      alu_op=0b00011,
                      dst=0x5,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def rorimm_works(dut):
    await test_decode(dut, 0x3651, 
                      imm_en=1,
                      arg_imm=0x04,
                      read_a=1,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x9,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b10,
                      alu_en=1,
                      sh_off_imm=1,
                      truth_table=0b1110,
                      alu_op=0b00100,
                      dst=0x9,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def rolimm_works(dut):
    await test_decode(dut, 0x3650, 
                      imm_en=1,
                      arg_imm=0x04,
                      read_a=1,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x9,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b10,
                      alu_en=1,
                      sh_off_imm=1,
                      truth_table=0b1110,
                      alu_op=0b00000,
                      dst=0x9,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def shrimm_works(dut):
    await test_decode(dut, 0x3A21, 
                      imm_en=1,
                      arg_imm=0x08,
                      read_a=1,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x8,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b10,
                      alu_en=1,
                      sh_off_imm=1,
                      truth_table=0b1110,
                      alu_op=0b00110,
                      dst=0x8,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def shlimm_works(dut):
    await test_decode(dut, 0x3A20, 
                      imm_en=1,
                      arg_imm=0x08,
                      read_a=1,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x8,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b10,
                      alu_en=1,
                      sh_off_imm=1,
                      truth_table=0b1110,
                      alu_op=0b00010,
                      dst=0x8,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def sarimm_works(dut):
    await test_decode(dut, 0x398F, 
                      imm_en=1,
                      arg_imm=0x03,
                      read_a=1,
                      arg_a=0x0,
                      read_b=1,
                      src_b=0x6,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b10,
                      alu_en=1,
                      sh_off_imm=1,
                      truth_table=0b1110,
                      alu_op=0b01110,
                      dst=0x6,
                      mem_en=0,
                      mem_write=0)

@cocotb.test
async def ld3_works(dut):
    await test_decode(dut, 0x12AF,
                      imm_en=0,
                      arg_imm=0x00,
                      read_a=1,
                      arg_a=0x7,
                      read_b=1,
                      src_b=0x5,
                      set_pc=0,
                      add_pc=0,
                      inc_pc=0,
                      cmp_b=0,
                      pc_src=0,
                      out_regs=0b00,
                      alu_en=0,
                      sh_off_imm=0,
                      truth_table=0x0,
                      alu_op=0b00000,
                      dst=0xA,
                      mem_en=1,
                      mem_write=0)
