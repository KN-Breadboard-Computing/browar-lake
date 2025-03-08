module mau(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire [7:0] data_in,
    input wire en,
    input wire mem_res,
    input wire [3:0] i_dst,
    output logic out_en,
    output logic [15:0] out,
    output logic [3:0] o_dst
);

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
        if (en && mem_res) begin
            out <= { 8'h00, data_in };
            o_dst <= i_dst;
            out_en <= 1'b1;
        end else begin
            out_en <= 1'b0;
        end
    end
end

endmodule
