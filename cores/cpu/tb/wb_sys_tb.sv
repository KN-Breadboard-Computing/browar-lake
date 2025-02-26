`timescale 1ns/1ns
module wb_sys_tb();

reg clk;
reg rst;
reg cpu_clk;

wire sys_clk;
wire wb_clk;

wire [29:0] addr_bus;
wire [31:0] cpu_in;
wire [31:0] cpu_out;
wire [3:0] sel_bus;
wire cyc_sig;
wire stb_sig;
wire ack_sig;
wire we_sig;

cpu_wb cpu(
    .cpu_clk(cpu_clk),
    .cpu_rst(rst),
    .clk_i(wb_clk),
    .dat_i(cpu_in),
    .rst_i(rst),
    .ack_i(ack_sig),
    .dat_o(cpu_out),
    .adr_o(addr_bus),
    .cyc_o(cyc_sig),
    .sel_o(sel_bus),
    .stb_o(stb_sig),
    .we_o(we_sig)
);

mem mem(
    .sys_clk(sys_clk),
    .sys_rst(rst),
    .clk_i(wb_clk),
    .dat_i(cpu_out),
    .rst_i(rst),
    .adr_i(addr_bus),
    .cyc_i(cyc_sig),
    .sel_i(sel_bus),
    .stb_i(stb_sig),
    .we_i(we_sig),
    .ack_o(ack_sig),
    .dat_o(cpu_in)
);

assign wb_clk = ~clk;
assign sys_clk = clk;

always_ff @(posedge clk) cpu_clk <= !cpu_clk;

initial begin
    $dumpfile("wb_sys.fst");
    $dumpvars(0, wb_sys_tb);
    clk <= 1'b0;
    cpu_clk <= 1'b0;
    rst <= 1'b1;
    
    #1; clk <= 1'b1;
    #1; clk <= 1'b0;
    #1; clk <= 1'b1;
    #1; clk <= 1'b0; 
    rst <= 1'b0;

    #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;

    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
    #1; clk <= 1'b0; #1; clk <= 1'b1;
end
endmodule
