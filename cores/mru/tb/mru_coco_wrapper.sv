module mru_coco_wrapper(
    input wire sys_clk,
    input wire sys_rst,
    input wire cpu_clk,
    input wire ins_en,
    input wire [30:0] ins_addr,
    input wire ins_ext,
    input wire mem_en,
    input wire [31:0] mem_addr,
    input wire mem_we,
    input wire [7:0] mem_data_i,
    input wire clk_i,
    input wire rst_i,
//    input wire [31:0] dat_i,
//    input wire ack_i,
    output wire ins_stl,
    output wire ins_ack,
    output wire [31:0] ins_data,
    output wire mem_stl,
    output wire mem_ack,
    output logic [7:0] mem_data_o
//    output logic [31:0] dat_o,
//    output wire [29:0] adr_o,
//    output wire cyc_o,
//    output wire [3:0] sel_o,
//    output wire stb_o,
//    output wire we_o
);

//`ifndef VERILATOR
//    vlog_tb_utils vtu();
//`endif

wire ack_sig;
wire cyc_sig;
wire stb_sig;
wire we_sig;
wire [31:0] mosi_bus;
wire [31:0] miso_bus;
wire [29:0] addr_bus;
wire [3:0] sel_bus;

mem mem(
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .clk_i(clk_i),
    .dat_i(mosi_bus),
    .rst_i(rst_i),
    .adr_i(addr_bus),
    .cyc_i(cyc_sig),
    .sel_i(sel_bus),
    .stb_i(stb_sig),
    .we_i(we_sig),
    .ack_o(ack_sig),
    .dat_o(miso_bus)
);

mru mru(
    .ins_en(ins_en),
    .ins_addr(ins_addr),
    .ins_ext(ins_ext),
    .mem_en(mem_en),
    .mem_addr(mem_addr),
    .mem_we(mem_we),
    .mem_data_i(mem_data_i),
    .clk_i(clk_i),
    .dat_i(miso_bus),
    .rst_i(rst_i),
    .ack_i(ack_sig),
    .ins_stl(ins_stl),
    .ins_ack(ins_ack),
    .ins_data(ins_data),
    .mem_stl(mem_stl),
    .mem_ack(mem_ack),
    .mem_data_o(mem_data_o),
    .dat_o(mosi_bus),
    .adr_o(addr_bus),
    .cyc_o(cyc_sig),
    .sel_o(sel_bus),
    .stb_o(stb_sig),
    .we_o(we_sig)
);

endmodule
