module cpu(
    input wire sys_clk,
    input wire sys_rst,
    input wire clk_i,
    input wire [31:0] dat_i,
    input wire rst_i,
    input wire ack_i,
    output reg [31:0] dat_o,
    output reg [29:0] adr_o,
    output reg cyc_o,
    output reg [3:0] sel_o,
    output reg stb_o,
    output reg we_o
);

reg [31:0] addr;
reg [7:0] data;
reg write_req;
reg write_ack;

// Memory Unit
always_ff @(posedge sys_clk) begin
    if (sys_rst) begin
        addr <= 32'h0000FF00;
        data <= 8'hDE;
        write_req <= 1'b1;
    end else begin
        if (!write_req) begin
            addr <= addr + 1;
            data <= { data[6:0], data[7] };
            write_req <= 1'b1;
        end

        if (write_ack) write_req <= 1'b0;
    end
end

reg write_wait;

// Memory Request Unit
always_ff @(posedge clk_i) begin
    if (rst_i) begin
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        write_ack <= 1'b0;
    end else begin
        if (write_req) begin
            adr_o <= addr[31:2];
            we_o <= 1'b1;
            sel_o <= addr[1:0];
            cyc_o <= 1'b1;
            stb_o <= 1'b1;
            dat_o <= {data, data, data, data};
            write_wait <= 1'b1;
        end
        if (write_wait && ack_i) begin
            stb_o <= 1'b0;
            cyc_o <= 1'b0;
            write_wait <= 1'b0;
            write_ack <= 1'b0;
        end
    end
end

endmodule
