module mru(
    input wire ins_en,
    input wire [30:0] ins_addr,
    input wire ins_ext,
    input wire mem_en,
    input wire [31:0] mem_addr,
    input wire mem_we,
    input wire [7:0] mem_data_i,
    input wire clk_i,
    input wire [31:0] dat_i,
    input wire rst_i,
    input wire ack_i,
    output wire ins_stl,
    output wire ins_ack,
    output wire [31:0] ins_data,
    output wire mem_stl,
    output wire mem_ack,
    output logic [7:0] mem_data_o,
    output logic [31:0] dat_o,
    output wire [29:0] adr_o,
    output wire cyc_o,
    output wire [3:0] sel_o,
    output wire stb_o,
    output wire we_o
);

reg req;
reg [29:0] addr;
reg [3:0] sel;
reg write;

reg mem_req;
reg mem_served;
reg ins_req;
reg ins_served;
reg [31:0] in_data_buf;
reg [7:0] out_data_buf;

always_ff @(posedge clk_i) begin
    if (rst_i) begin
        req <= 1'b0;
        ins_req <= 1'b0;
        ins_served <= 1'b0;
        mem_req <= 1'b0;
        mem_served <= 1'b0;
    end else begin
        if (!req) begin
            if (mem_en) begin
                if (ins_en) begin // service whichever has priority
                    
                end else begin // service mem
                    addr <= mem_addr[31:2];
                    write <= mem_we;
                    req <= 1'b1;
                    ins_req <= 1'b0;
                    mem_req <= 1'b1;
                    out_data_buf <= mem_data_i;

                    case (mem_addr[1:0])
                        2'b00: sel <= 4'b0001;
                        2'b01: sel <= 4'b0010;
                        2'b10: sel <= 4'b0100;
                        2'b11: sel <= 4'b1000;
                    endcase
                end
            end else begin
                if (ins_en) begin // service ins
                    addr <= ins_addr[30:1];
                    write <= 1'b0;
                    req <= 1'b1;
                    ins_req <= 1'b1;
                    mem_req <= 1'b0;

                    if (ins_addr[0]) sel <= { 2'b11, ins_ext, ins_ext };
                    else sel <= { ins_ext, ins_ext, 2'b11};
                end else begin
                    mem_served <= 1'b0;
                    ins_served <= 1'b0;
                end
            end
        end else begin
            if (ack_i) begin
                in_data_buf <= dat_i; // for write this is not really correct
                req <= 1'b0;
                mem_served <= mem_req;
                mem_req <= 1'b0;
                ins_served <= ins_req;
                ins_req <= 1'b0;
            end
        end
    end
end

assign stb_o = req;
assign cyc_o = req;
assign adr_o = addr;
assign we_o = write;
assign sel_o = sel;
assign ins_ack = ins_served;
assign mem_ack = mem_served;
assign ins_data = in_data_buf;

assign ins_stl = mem_req;
assign mem_stl = ins_req;

always_comb begin
    casez (sel_o)
        4'b0000: mem_data_o = 8'hXX;
        4'b???1: mem_data_o = dat_i[7:0];
        4'b??10: mem_data_o = dat_i[15:8];
        4'b?100: mem_data_o = dat_i[23:16];
        4'b1000: mem_data_o = dat_i[31:24];
    endcase
end

always_comb begin
    casez (sel_o)
        4'b0000: dat_o = 32'hXXXXXXXX;
        4'b???1: dat_o = { 24'h000000, out_data_buf };
        4'b??10: dat_o = { 16'h0000, out_data_buf, 8'h00 };
        4'b?100: dat_o = { 8'h00, out_data_buf, 16'h0000 };
        4'b1000: dat_o = { out_data_buf, 24'h000000 };
    endcase
end
endmodule
