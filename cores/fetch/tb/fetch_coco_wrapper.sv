module fetch_coco_wrapper(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire stall,
    input wire ins_res,
    input wire pc_en,
    input wire pc_add,
    input wire [31:0] data,
    input wire [30:0] pc,
    output wire ins_req,
    output wire [29:0] addr,
    output wire [15:0] ins,
    output wire ins_en,
    output wire [15:0] ext
);

`ifndef VERILATOR
    vlog_tb_utils vtu();
`endif

fetch dut(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .stall(stall),
    .ins_res(ins_res),
    .pc_en(pc_en),
    .pc_add(pc_add),
    .data(data),
    .pc(pc),
    .ins_req(ins_req),
    .addr(addr),
    .ins(ins),
    .ins_en(ins_en),
    .ext(ext)
);

initial begin
    $dumpfile("coco.fst");
    $dumpvars(0, dut);
end

endmodule
