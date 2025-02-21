import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, NextTimeStep

SKIP_1 = False
SKIP_2 = False
SKIP_3 = False
SKIP_4 = False
SKIP_5 = False

# TODO: ins, ins, ins, ins, jmp, ins, ins (use_a issues)

@cocotb.test(skip=SKIP_1)
async def valid_ins_fetch_seq(dut):
    cpu_rst = dut.cpu_rst
    ins_req = dut.ins_req
    ins_res = dut.ins_res
    addr = dut.addr
    stall = dut.stall
    data = dut.data
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_cpu.start())

    cpu_rst.value = 1
    stall.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req == 0

    cpu_rst.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req.value == 1 
    ip = addr.value
    data.value = 0xBEEF8FF1
    ins_res.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert dut.dut.a_mbufa.value == 0x8FF1
    assert dut.dut.a_mbufb.value == 0xBEEF
    assert dut.ins_en == 0
    assert addr.value == ip + 1
    assert ins_req.value == 1

    ip = addr.value
    data.value = 0xDEAD8FF1
    ins_res.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert dut.dut.a_mbufa.value == 0x8FF1
    assert dut.dut.a_mbufb.value == 0xBEEF
    assert dut.ins == 0x8FF1
    assert dut.ins_en == 1
    assert dut.ext == 0xBEEF
    assert dut.dut.b_mbufa.value == 0x8FF1
    assert dut.dut.b_mbufb.value == 0xDEAD
    assert addr.value == ip + 1
    assert ins_req.value == 1

    ip = addr.value
    data.value = 0x8FF16E76
    ins_res.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert dut.dut.a_mbufa.value == 0x6E76
    assert dut.dut.a_mbufb.value == 0x8FF1
    assert dut.ins == 0x8FF1
    assert dut.ins_en == 1
    assert dut.ext == 0xDEAD
    assert dut.dut.b_mbufa.value == 0x8FF1
    assert dut.dut.b_mbufb.value == 0xDEAD
    assert addr.value == ip + 1
    assert ins_req.value == 1

    ip = addr.value
    data.value = 0x4E74BABE
    ins_res.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert dut.dut.a_mbufa.value == 0x6E76
    assert dut.dut.a_mbufb.value == 0x8FF1
    assert dut.ins.value == 0x6E76
    assert dut.ins_en == 1
    assert dut.dut.b_mbufa.value == 0xBABE
    assert dut.dut.b_mbufb.value == 0x4E74
    assert addr.value == ip + 1
    assert ins_req.value == 0

    ip = addr.value
    ins_res.value = 0

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert addr.value == ip
    assert dut.dut.a_mbufb.value == 0x8FF1
    assert dut.ins == 0x8FF1
    assert dut.ins_en == 1
    assert dut.ext == 0xBABE
    assert dut.dut.b_mbufa.value == 0xBABE
    assert dut.dut.b_mbufb.value == 0x4E74
    assert ins_req.value == 1

    data.value = 0xC0DE8FF1
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert addr.value == ip + 1
    assert dut.dut.a_mbufa.value == 0x8FF1
    assert dut.dut.a_mbufb.value == 0xC0DE
    assert dut.ins == 0x4E74
    assert dut.ins_en == 1
    assert dut.dut.b_mbufa.value == 0xBABE
    assert dut.dut.b_mbufb.value == 0x4E74
    assert ins_req.value == 1

    data.value = 0x4C3465A6
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert addr.value == ip + 1
    assert dut.dut.a_mbufa.value == 0x8FF1
    assert dut.dut.a_mbufb.value == 0xC0DE
    assert dut.ins == 0x8FF1
    assert dut.ext == 0xC0DE
    assert dut.ins_en == 1
    assert dut.dut.b_mbufa.value == 0x65A6
    assert dut.dut.b_mbufb.value == 0x4C34
    assert ins_req.value == 1

    data.value = 0x63C66E76
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert addr.value == ip + 1
    assert dut.dut.a_mbufa.value == 0x6E76
    assert dut.dut.a_mbufb.value == 0x63C6
    assert dut.ins == 0x65A6
    assert dut.ins_en == 1
    assert dut.dut.b_mbufa.value == 0x65A6
    assert dut.dut.b_mbufb.value == 0x4C34
    assert ins_req.value == 0

    ins_res.value = 0

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert addr.value == ip + 1
    assert dut.dut.a_mbufa.value == 0x6E76
    assert dut.dut.a_mbufb.value == 0x63C6
    assert dut.ins == 0x4C34
    assert dut.ins_en == 1
    assert dut.dut.b_mbufa.value == 0x65A6
    assert dut.dut.b_mbufb.value == 0x4C34
    assert ins_req.value == 1

    data.value = 0x47E44C34
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert addr.value == ip + 1
    assert dut.dut.a_mbufa.value == 0x6E76
    assert dut.dut.a_mbufb.value == 0x63C6
    assert dut.ins == 0x6E76
    assert dut.ins_en == 1
    assert dut.dut.b_mbufa.value == 0x4C34
    assert dut.dut.b_mbufb.value == 0x47E4
    assert ins_req.value == 0

def jmpimm(off):
    if off < 0:
        off *= -1
        off = (0xFFF - off + 1) & 0x3FF
    else:
        off = off & 0x3FF
    return 0x7800 | off

IP_INIT = 0

@cocotb.test(skip=SKIP_2)
async def jmpimm_works(dut):
    cpu_rst = dut.cpu_rst
    ins_req = dut.ins_req
    ins_res = dut.ins_res
    addr = dut.addr
    stall = dut.stall
    data = dut.data
    ins_en = dut.ins_en
    ins = dut.ins
    a_mbufa = dut.dut.a_mbufa
    a_mbufb = dut.dut.a_mbufb
    b_mbufa = dut.dut.b_mbufa
    b_mbufb = dut.dut.b_mbufb
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_cpu.start())
    
    cpu_rst.value = 1
    stall.value = 0
    ins_res.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req == 0
    assert addr.value == IP_INIT

    cpu_rst.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req.value == 1 

    jmp_ins = jmpimm(15)
    data.value = 0x000067E6 | (jmp_ins << 16)
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == jmp_ins
    assert ins_req.value == 1
    assert ins_en.value == 0
    assert addr.value == ip + 15

    data.value = 0x6A566E76
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == jmp_ins
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_req.value == 0
    assert ins_en.value == 1
    assert ins.value == 0x67E6
    assert addr.value == ip + 1

    ip = addr.value
    ins_res.value = 0
    
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == jmp_ins
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_req.value == 1
    assert ins_en.value == 1
    assert ins.value == jmp_ins
    assert addr.value == ip
    
    jmp_ins = jmpimm(-7)
    data.value = 0x6DB60000 | jmp_ins
    ins_res.value = 1
    ip = addr.value

    dut._log.info(f"jmp ins is {jmp_ins:x}")

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == jmp_ins
    assert a_mbufb.value == 0x6DB6
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_req.value == 0
    assert ins_en.value == 1
    assert ins.value == 0x6E76
    assert addr.value == ip - 7
    
    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == jmp_ins
    assert a_mbufb.value == 0x6DB6
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_req.value == 1
    assert ins_en.value == 1
    assert ins.value == 0x6A56
    assert addr.value == ip

    jmp_ins2 = jmpimm(127)
    data.value = 0x4E740000 | jmp_ins2
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == jmp_ins
    assert a_mbufb.value == 0x6DB6
    assert b_mbufa.value == jmp_ins2
    assert b_mbufb.value == 0x4E74
    assert ins_req.value == 1
    assert ins_en.value == 1
    assert ins.value == jmp_ins # a_mbuf is empty now (mbufb is ignored)
    assert addr.value == ip + 127

    data.value = 0x6E766A56
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6A56
    assert a_mbufb.value == 0x6E76
    assert b_mbufa.value == jmp_ins2
    assert b_mbufb.value == 0x4E74
    assert ins_req.value == 1
    assert ins_en.value == 1
    assert ins.value == jmp_ins2 # b_mbuf is empty now (mbufb is ignored)
    assert addr.value == ip + 1
    
    jmp_ins = jmpimm(-31)
    data.value = 0x00004A54 | (jmp_ins << 16)
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6A56
    assert a_mbufb.value == 0x6E76
    assert b_mbufa.value == 0x4A54
    assert b_mbufb.value == jmp_ins
    assert ins_req.value == 0
    assert ins_en.value == 1
    assert ins.value == 0x6A56
    assert addr.value == ip - 31

    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6A56
    assert a_mbufb.value == 0x6E76
    assert b_mbufa.value == 0x4A54
    assert b_mbufb.value == jmp_ins
    assert ins_req.value == 1
    assert ins_en.value == 1
    assert ins.value == 0x6E76
    assert addr.value == ip

    data.value = 0x624667E6
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == 0x6246
    assert b_mbufa.value == 0x4A54
    assert b_mbufb.value == jmp_ins
    assert ins_req.value == 0
    assert ins_en.value == 1
    assert ins.value == 0x4A54
    assert addr.value == ip + 1

    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == 0x6246
    assert b_mbufa.value == 0x4A54
    assert b_mbufb.value == jmp_ins
    assert ins_req.value == 1
    assert ins_en.value == 1
    assert ins.value == jmp_ins
    assert addr.value == ip

def jmpimm_ext(off):
    if off < 0:
        off *= -1
        off = (0xFFFFFFF - off + 1) & 0x3FFFFFF
    else:
        off = off & 0x3FFFFFF
    ins_off = off & 0x3FF
    ext_off = off >> 10
    return (ext_off, 0xF800 | ins_off)

@cocotb.test(skip=SKIP_3)
async def jmpimm_ext_works(dut):
    cpu_rst = dut.cpu_rst
    ins_req = dut.ins_req
    ins_res = dut.ins_res
    addr = dut.addr
    stall = dut.stall
    data = dut.data
    ins_en = dut.ins_en
    ins = dut.ins
    ext = dut.ext
    a_mbufa = dut.dut.a_mbufa
    a_mbufb = dut.dut.a_mbufb
    b_mbufa = dut.dut.b_mbufa
    b_mbufb = dut.dut.b_mbufb
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_cpu.start())
    
    cpu_rst.value = 1
    stall.value = 0
    ins_res.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req == 0
    assert addr.value == IP_INIT

    cpu_rst.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req.value == 1 

    ins_hi, ins_lo = jmpimm_ext(66570)
    data.value = (ins_hi << 16) | ins_lo
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == ins_lo
    assert a_mbufb.value == ins_hi
    assert ins_req.value == 1
    assert addr.value == ip + 66570
    assert ins_req.value == 1

    ins2_hi, ins2_lo = jmpimm_ext(-2051)
    data.value = (ins2_lo << 16) | 0x6A56
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == ins_lo
    assert a_mbufb.value == ins_hi
    assert b_mbufa.value == 0x6A56
    assert b_mbufb.value == ins2_lo
    assert ins.value == ins_lo
    assert ext.value == ins_hi
    assert ins_en.value == 1
    assert addr.value == ip + 1
    assert ins_req.value == 1

    data.value = 0x67E60000 | ins2_hi
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == ins2_lo
    assert a_mbufb.value == ins2_hi
    assert b_mbufa.value == 0x6A56
    assert b_mbufb.value == ins2_lo
    assert ins.value == 0x6A56
    assert ins_en.value == 1
    assert addr.value == ip - 2051
    assert ins_req.value == 1

    data.value = 0x47E465A6
    ip = addr.value
    ins_res.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == ins2_lo
    assert a_mbufb.value == ins2_hi
    assert b_mbufa.value == 0x65A6
    assert b_mbufb.value == 0x47E4
    assert ins.value == ins2_lo
    assert ins_en.value == 1
    assert ext.value == ins2_hi
    assert addr.value == ip + 1
    assert ins_req.value == 1 # <-

    ins_hi, ins_lo = jmpimm_ext(3083)
    data.value = 0x000067E6 | (ins_lo << 16)
    ip = addr.value
    ins_res.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == ins_lo
    assert b_mbufa.value == 0x65A6
    assert b_mbufb.value == 0x47E4
    assert ins.value == 0x65A6
    assert ins_en.value == 1
    assert addr.value == ip + 1
    assert ins_req.value == 0

    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == ins_lo
    assert b_mbufa.value == 0x65A6
    assert b_mbufb.value == 0x47E4
    assert ins.value == 0x47E4
    assert ins_en.value == 1
    assert addr.value == ip
    assert ins_req.value == 1

    data.value = 0x73CE0000 | ins_hi
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == ins_lo
    assert b_mbufa.value == ins_lo
    assert b_mbufb.value == ins_hi
    assert ins.value == 0x67E6
    assert ins_en.value == 1
    assert addr.value == ip + 3083
    assert ins_req.value == 1

    ins_res.value = 0
    ip = addr.value
    
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x67E6
    assert a_mbufb.value == ins_lo
    assert b_mbufa.value == ins_lo
    assert b_mbufb.value == ins_hi
    assert ins.value == ins_lo
    assert ins_en.value == 1
    assert ext.value == ins_hi
    assert addr.value == ip
    assert ins_req.value == 1

def jmp(src1, src2):
    return 0x7C00 | ((src1 & 0xF) << 6) | ((src2 & 0xF) << 2)

@cocotb.test(skip=SKIP_4)
async def jmp_works(dut):
    cpu_rst = dut.cpu_rst
    ins_req = dut.ins_req
    ins_res = dut.ins_res
    addr = dut.addr
    stall = dut.stall
    data = dut.data
    ins_en = dut.ins_en
    ins = dut.ins
    ext = dut.ext
    a_mbufa = dut.dut.a_mbufa
    a_mbufb = dut.dut.a_mbufb
    b_mbufa = dut.dut.b_mbufa
    b_mbufb = dut.dut.b_mbufb
    jmping = dut.dut.jmping
    a_state = dut.dut.a_state
    b_state = dut.dut.b_state
    pc = dut.pc
    pc_en = dut.pc_en
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_cpu.start())
    
    cpu_rst.value = 1
    stall.value = 0
    pc_en.value = 0
    ins_res.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req == 0
    assert addr.value == IP_INIT

    cpu_rst.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req.value == 1 

    jins = jmp(1, 2)
    data.value = 0x000065A6 | (jins << 16)
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x65A6
    assert a_mbufb.value == jins
    assert ins_en.value == 0
    assert addr.value == ip + 1
    assert ins_req.value == 1
    assert jmping.value == 0

    data.value = 0x47E467E6
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x65A6
    assert a_mbufb.value == jins
    assert b_mbufa.value == 0x67E6
    assert b_mbufb.value == 0x47E4
    assert ins_en.value == 1
    assert ins.value == 0x65A6
    assert addr.value == ip + 1
    assert ins_req.value == 0
    assert jmping.value == 1

    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x65A6
    assert a_mbufb.value == jins
    assert b_mbufa.value == 0x67E6
    assert b_mbufb.value == 0x47E4
    assert ins_en.value == 1
    assert ins.value == jins
    assert addr.value == ip
    assert ins_req.value == 0
    assert jmping.value == 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x65A6
    assert a_mbufb.value == jins
    assert a_state.value == 0
    assert b_mbufa.value == 0x67E6
    assert b_mbufb.value == 0x47E4
    assert b_state.value == 0
    assert ins_en.value == 1
    assert ins.value == 0x67E6
    assert addr.value == ip
    assert ins_req.value == 0
    assert jmping.value == 1

    ip = 0x7000_00F0
    pc.value = ip
    pc_en.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x65A6
    assert a_mbufb.value == jins
    assert b_mbufa.value == 0x67E6
    assert b_mbufb.value == 0x47E4
    assert ins_en.value == 0
    assert ins.value == 0x67E6
    assert addr.value == (ip >> 1)
    assert ins_req.value == 1
    assert jmping.value == 0

    data.value = 0x6E766A56
    ins_res.value = 1
    pc_en.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6A56
    assert a_mbufb.value == 0x6E76
    assert ins_en.value == 0
    assert addr.value == ip + 1
    assert ins_req.value == 1
    assert jmping.value == 0

    data.value = 0x45A44E74
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6A56
    assert a_mbufb.value == 0x6E76
    assert b_mbufa.value == 0x4E74
    assert b_mbufb.value == 0x45A4
    assert ins_en.value == 1
    assert ins.value == 0x6A56
    assert addr.value == ip + 1
    assert ins_req.value == 0
    assert jmping.value == 0

BRANCH_Z = 0
BRANCH_NZ = 1
BRANCH_GZ = 2
BRANCH_LZ = 3
def branch(cond, a, b, ext=None, near=False):
    if near:
        assert ext is None
        pass
    else:
        if ext is None:
            return 0x7400 | ((a & 0xF) << 6) | ((b & 0xF) << 2) | (b & 3)
        else:
            lo = 0xF400 | ((a & 0xF) << 6) | ((b & 0xF) << 2) | (b & 3)
            hi = ext & 0xFFFF
            return hi, lo

@cocotb.test(skip=SKIP_5)
async def branch_works(dut):
    cpu_rst = dut.cpu_rst
    ins_req = dut.ins_req
    ins_res = dut.ins_res
    addr = dut.addr
    stall = dut.stall
    data = dut.data
    ins_en = dut.ins_en
    ins = dut.ins
    ext = dut.ext
    a_mbufa = dut.dut.a_mbufa
    a_mbufb = dut.dut.a_mbufb
    b_mbufa = dut.dut.b_mbufa
    b_mbufb = dut.dut.b_mbufb
    jmping = dut.dut.jmping
    a_state = dut.dut.a_state
    b_state = dut.dut.b_state
    pc = dut.pc
    pc_en = dut.pc_en
    pc_add = dut.pc_add
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_cpu.start())
    
    cpu_rst.value = 1
    stall.value = 0
    pc_en.value = 0
    pc_add.value = 0
    ins_res.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req.value == 0
    assert addr.value == IP_INIT

    cpu_rst.value = 0
    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert ins_req.value == 1 

    bins_hi, bins_lo = branch(BRANCH_Z, 3, 5, 126)
    data.value = (bins_hi << 16) | bins_lo
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins_lo
    assert a_mbufb.value == bins_hi
    assert ins_en.value == 0
    assert addr.value == ip + 1
    assert ins_req.value == 1
    assert jmping.value == 0

    data.value = 0x6A566E76
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins_lo
    assert a_mbufb.value == bins_hi
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_en.value == 1
    assert ins.value == bins_lo
    assert ext.value == bins_hi
    assert addr.value == ip + 1
    assert ins_req.value == 0
    assert jmping.value == 1

    # branch is DEC
    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins_lo
    assert a_mbufb.value == bins_hi
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_en.value == 1
    assert ins.value == 0x6E76
    assert addr.value == ip
    assert ins_req.value == 0
    assert jmping.value == 1

    # branch is REGS
    ins_res.value = 0
    ip = addr.value
    pc.value = 126
    pc_add.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins_lo
    assert a_mbufb.value == bins_hi
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_en.value == 0
    assert addr.value == ip + 126
    assert ins_req.value == 1
    assert jmping.value == 0

    bins = branch(BRANCH_NZ, 2, 4)
    pc_add.value = 0
    ins_res.value = 1
    data.value = 0x67E60000 | bins
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins
    assert a_mbufb.value == 0x67E6
    assert b_mbufa.value == 0x6E76
    assert b_mbufb.value == 0x6A56
    assert ins_en.value == 0
    assert addr.value == ip + 1
    assert ins_req.value == 1
    assert jmping.value == 0

    data.value = 0x4A544E74
    ins_res.value = 1
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins
    assert a_mbufb.value == 0x67E6
    assert b_mbufa.value == 0x4E74
    assert b_mbufb.value == 0x4A54
    assert ins_en.value == 1
    assert ins.value == bins
    assert addr.value == ip + 1
    assert ins_req.value == 0
    assert jmping.value == 1

    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins
    assert a_mbufb.value == 0x67E6
    assert b_mbufa.value == 0x4E74
    assert b_mbufb.value == 0x4A54
    assert ins_en.value == 1
    assert ins.value == 0x67E6
    assert addr.value == ip
    assert ins_req.value == 0
    assert jmping.value == 1

    ins_res.value = 0
    ip = addr.value
    pc.value = 0x100F
    pc_add.value = 1

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == bins
    assert a_mbufb.value == 0x67E6
    assert b_mbufa.value == 0x4E74
    assert b_mbufb.value == 0x4A54
    assert ins_en.value == 0
    assert addr.value == ip + 0x100F
    assert ins_req.value == 1
    assert jmping.value == 0

    ins_res.value = 1
    ip = addr.value
    data.value = 0x65A66C36
    pc_add.value = 0

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6C36
    assert a_mbufb.value == 0x65A6
    assert ins_en.value == 0
    assert addr.value == ip + 1
    assert ins_req.value == 1
    assert jmping.value == 0

    ins_res.value = 0
    ip = addr.value

    await RisingEdge(dut.cpu_clk)
    await NextTimeStep()
    assert a_mbufa.value == 0x6C36
    assert a_mbufb.value == 0x65A6
    assert ins_en.value == 1
    assert ins.value == 0x6C36
    assert addr.value == ip
    assert ins_req.value == 1
    assert jmping.value == 0
