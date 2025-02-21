import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

# clk+0: write
# clk+1: read
# clk+2: read ready
@cocotb.test
async def inst_each_clk(dut):
    dut.mem_en = 0
    dut.ins_en = 0
    dut.mem_we = 0
    dut.sys_clk = 0
    dut.clk_i = 0
    dut.rst_i = 1
    dut.sys_rst = 1
    clk_sys = Clock(dut.sys_clk, 2, 'ns')
    clk_wb = Clock(dut.clk_i, 2, 'ns')
    clk_cpu = Clock(dut.cpu_clk, 4, 'ns')
    await cocotb.start(clk_sys.start())
    await cocotb.start(clk_wb.start(start_high=False))
    await cocotb.start(clk_cpu.start())
    await RisingEdge(dut.sys_clk)
    await RisingEdge(dut.sys_clk)
    dut.rst_i = 0
    dut.sys_rst = 0

    # write
    dut.mem_en = 1
    dut.mem_we = 1
    dut.mem_addr = 0x0000_0001
    dut.mem_data_i = 0xAF
    await RisingEdge(dut.cpu_clk) # edge 0

    # read
    dut.mem_we = 0;
    dut.mem_data_i = 0;
    await RisingEdge(dut.cpu_clk) # edge 1, write completes, read starts

    dut.mem_en = 0;
    await RisingEdge(dut.cpu_clk) # edge 2, read completes
    assert dut.mem_data_o == 0xAF
