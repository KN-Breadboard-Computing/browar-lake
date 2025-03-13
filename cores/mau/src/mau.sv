module mau(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire [15:0] write_data,
    input wire [7:0] data_in,
    input wire en,
    input wire we,
    input wire mem_res,
    input wire [3:0] i_dst,
    output logic out_en,
    output logic [15:0] out,
    output logic [3:0] o_dst,
    output logic [7:0] data_out
);

reg read;
reg op_in_flight;

always_ff @(posedge cpu_clk) begin
    if (cpu_rst) begin
        read <= 1'b0;
        op_in_flight <= 1'b0;
        out_en <= 1'b0;
    end
end

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
        if (en) begin
            if (mem_res) begin
                if (!we) begin
                    out <= { 8'h00, data_in };
                    o_dst <= i_dst;
                    out_en <= 1'b1;
                end else out_en <= 1'b0;
                read <= 1'b0;
                op_in_flight <= 1'b0;
            end else begin
                out_en <= 1'b0;
            end
        end
    end
end

assign data_out = we ? write_data[7:0] : 8'hZZ;

endmodule
