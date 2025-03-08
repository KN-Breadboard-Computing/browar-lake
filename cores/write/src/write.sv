module write(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire alu_en,
    input wire [3:0] alu_dst,
    input wire [15:0] alu_out,
    input wire mau_en,
    input wire [3:0] mau_dst,
    input wire [15:0] mau_out,
    output logic exe_en,
    output logic [3:0] exe_dst,
    output logic [15:0] exe_out,
    output logic we,
    output logic [3:0] dst,
    output logic [15:0] out
);

assign exe_out = alu_en ? alu_out :
                 mau_en ? mau_out : 16'hZZZZ;
assign exe_dst = alu_en ? alu_dst :
                 mau_en ? mau_dst : 4'hZ;

assign exe_en = alu_en || mau_en;

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
        we <= exe_en;
        dst <= exe_dst;
        out <= exe_out;
    end
end

endmodule
