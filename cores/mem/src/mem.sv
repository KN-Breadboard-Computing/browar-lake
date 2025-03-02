module mem(
    input wire sys_clk,
    input wire sys_rst,
    input wire clk_i,
    input wire [31:0] dat_i,
    input wire rst_i,
    input wire [29:0] adr_i,
    input wire cyc_i,
    input wire [3:0] sel_i,
    input wire stb_i,
    input wire we_i,
    output reg ack_o,
    output reg [31:0] dat_o
);

reg serviced;

// this will be in it's own module
reg [7:0] bank0 [4096];
reg [7:0] bank1 [4096];
reg [7:0] bank2 [4096];
reg [7:0] bank3 [4096];

`ifdef MEM_PRELOAD
initial begin
    bank0[0] = 8'hF1;
    bank1[0] = 8'h8F;
    bank2[0] = 8'hAD;
    bank3[0] = 8'hDE;

    bank0[1] = 8'hE6;
    bank1[1] = 8'h67;
    bank2[1] = 8'hE6;
    bank3[1] = 8'h67;

    bank0[2] = 8'hC6;
    bank1[2] = 8'h63;
    bank2[2] = 8'hE6;
    bank3[2] = 8'h67;

    bank0[3] = 8'h86;
    bank1[3] = 8'h61;
    bank2[3] = 8'hA6;
    bank3[3] = 8'h65;

    bank0[4] = 8'h0C;
    bank1[4] = 8'h78;
    bank2[4] = 8'hC6;
    bank3[4] = 8'h63;
// 0x7E6C
    bank0[16] = 8'h6C;
    bank1[16] = 8'h7E;
    bank2[16] = 8'hA6;
    bank3[16] = 8'h65;

    bank0[17] = 8'h86;
    bank1[17] = 8'h61;
    bank2[17] = 8'h00;
    bank3[17] = 8'h00;

    bank0[18] = 8'h00;
    bank1[18] = 8'h00;
    bank2[18] = 8'h00;
    bank3[18] = 8'h00;

    bank0[64] = 8'h8E;
    bank1[64] = 8'h74; // b.gez r2, r3
    bank2[64] = 8'hC6;
    bank3[64] = 8'h63;
    
    bank0[65] = 8'hC6;
    bank1[65] = 8'h63;
    bank2[65] = 8'h18; // add r4, r6
    bank3[65] = 8'h31;

    bank0[66] = 8'h19; // sub r4, r6
    bank1[66] = 8'h31;
    bank2[66] = 8'h30; // rol r4, 8
    bank3[66] = 8'h35;
end
`endif

wire [11:0] addr;
assign addr = adr_i[11:0];

always_ff @(posedge sys_clk) begin
    if (sys_rst) begin
        serviced <= 1'b0;
    end else begin
        if (cyc_i && stb_i) begin
            if (!we_i) begin
                if (sel_i[0]) dat_o[7:0] <= bank0[addr];
                else dat_o[7:0] = 8'h00;

                if (sel_i[1]) dat_o[15:8] <= bank1[addr];
                else dat_o[15:8] <= 8'h00;

                if (sel_i[2]) dat_o[23:16] <= bank2[addr];
                else dat_o[23:16] <= 8'h00;

                if (sel_i[3]) dat_o[31:24] <= bank3[addr];
                else dat_o[31:24] <= 8'h00;

                serviced <= 1'b1;
            end
            if (we_i) begin
                if (sel_i[0]) bank0[addr] <= dat_i[7:0];
                if (sel_i[1]) bank1[addr] <= dat_i[15:8];
                if (sel_i[2]) bank2[addr] <= dat_i[23:16];
                if (sel_i[3]) bank3[addr] <= dat_i[31:24];

                serviced <= 1'b1;
            end
        end else serviced <= 1'b0;
    end
end

assign ack_o = stb_i && serviced;

endmodule
