module cpu_wb(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire clk_i,
    input wire [31:0] dat_i,
    input wire rst_i,
    input wire ack_i,
    output wire [31:0] dat_o,
    output wire [29:0] adr_o,
    output wire cyc_o,
    output wire [3:0] sel_o,
    output wire stb_o,
    output wire we_o
);

wire [29:0] ins_addr;
wire [31:0] ins_data;
wire ins_req;
wire ins_res;
wire fetch_stall;

wire [31:0] mem_addr;
wire [7:0] data_in;
wire [7:0] data_out;
wire mem_req;
wire mem_we;
wire mem_res;
wire mmu_stall;

mru mru(
    .ins_en(ins_req),
    .ins_addr({ ins_addr, 1'b0 }),
    .ins_ext(1'b1),
    .mem_en(1'b0),
    .mem_addr(mem_addr),
    .mem_we(mem_we),
    .mem_data_i(data_in),
    .clk_i(clk_i),
    .dat_i(dat_i),
    .rst_i(rst_i),
    .ack_i(ack_i),
    .ins_stl(fetch_stall),
    .ins_ack(ins_res),
    .ins_data(ins_data),
    .mem_stl(mmu_stall),
    .mem_ack(mem_res),
    .mem_data_o(data_out),
    .dat_o(dat_o),
    .adr_o(adr_o),
    .cyc_o(cyc_o),
    .sel_o(sel_o),
    .stb_o(stb_o),
    .we_o(we_o)
);

wire [15:0] dec_in;
wire [15:0] dec_ext;
wire dec_en;

fetch fetch(
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rst),
    .stall(fetch_stall),
    .ins_res(ins_res),
    .data(ins_data),
    .ins_req(ins_req),
    .addr(ins_addr),
    .ins(dec_in),
    .ins_en(dec_en),
    .ext(dec_ext)
);

endmodule
