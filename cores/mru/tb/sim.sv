`timescale 1ns/100ps

module sim();

reg clk;
reg wb_clk_en;
reg rst;

reg fetch_ins;
reg fetch_mem;
reg mem_write;
reg [31:0] addr;
reg [7:0] data_in;

wire wb_clk;

wire [31:0] miso_bus;
wire [31:0] mosi_bus;
wire [29:0] addr_bus;
wire [3:0] sel_bus;
wire ack_sig;
wire cyc_sig;
wire stb_sig;
wire we_sig;

wire [31:0] ins_data_o;
wire [7:0] mem_data_o;
wire ins_ack;
wire mem_ack;

reg [31:0] inst;
reg [7:0] data;

reg cpu_clk;

mru mru(
    .ins_en(fetch_ins),
    .ins_addr(addr[31:1]),
    .ins_ext(1'b0),
    .mem_en(fetch_mem),
    .mem_addr(addr),
    .mem_we(mem_write),
    .mem_data_i(data_in),
    .clk_i(wb_clk),
    .dat_i(miso_bus),
    .rst_i(rst),
    .ack_i(ack_sig),
    .ins_stl(),
    .ins_ack(ins_ack),
    .ins_data(ins_data_o),
    .mem_stl(),
    .mem_ack(mem_ack),
    .mem_data_o(mem_data_o),
    .dat_o(mosi_bus),
    .adr_o(addr_bus),
    .cyc_o(cyc_sig),
    .sel_o(sel_bus),
    .stb_o(stb_sig),
    .we_o(we_sig)
);

mem mem(
    .sys_clk(clk),
    .sys_rst(rst),
    .clk_i(wb_clk),
    .dat_i(mosi_bus),
    .rst_i(rst),
    .adr_i(addr_bus),
    .cyc_i(cyc_sig),
    .sel_i(sel_bus),
    .stb_i(stb_sig),
    .we_i(we_sig),
    .ack_o(ack_sig),
    .dat_o(miso_bus)
);

assign wb_clk = wb_clk_en & ~clk;

always_ff @(posedge clk) cpu_clk <= !cpu_clk;

always_ff @(posedge cpu_clk) begin
    inst <= ins_data_o;
    data <= mem_data_o;
end

initial begin
    $dumpfile("mru_sim.fst");
    $dumpvars(0,sim);
    fetch_ins <= 0;
    fetch_mem <= 0;
    mem_write <= 0;
    clk <= 0;
    wb_clk_en <= 1;
    rst <= 1;
    cpu_clk <= 0;
    #1; clk <= 1;
    #1; clk <= 0;
    #1; clk <= 1;
    rst <= 0;
    #1; clk <= 0;
    
    #1; clk <= 1;
    // Fetch instruction
    fetch_mem <= 1;
    mem_write <= 1;
    addr <= 32'h00000001;
    data_in <= 8'hAF;
    #1; clk <= 0;

    #1; clk <= 1;
    mem_write <= 0;
    #1; clk <= 0;

    // Fetch next instruction 
    addr <= 32'h00000001;
    #1; clk <= 1;
    #1; clk <= 0;

    #1; clk <= 1;
    fetch_ins <= 0;
    #1; clk <= 0;
    #1; clk <= 1;
    #1; clk <= 0;
    #1; clk <= 1;
    #1; clk <= 0;
end

endmodule
