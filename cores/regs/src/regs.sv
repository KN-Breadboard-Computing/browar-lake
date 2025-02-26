module regs(
    input wire cpu_clk,
    input wire src_a_en,
    input wire src_a_pop,
    input wire [3:0] src_a,
    input wire src_b_en,
    input wire [3:0] src_b,
    input wire we,
    input wire [3:0] src_w,
    input wire [15:0] val,
    output wire [15:0] a_out,
    output wire [15:0] b_out
);

reg [15:0] r1_a, r1_b;
reg [15:0] r2_a, r2_b;
reg [15:0] r3_a, r3_b;
reg [15:0] r4_a, r4_b;
reg [15:0] r5_a, r5_b;
reg [15:0] r6_a, r6_b;
reg [15:0] r7_a, r7_b;
reg [15:0] r8_a, r8_b;
reg [15:0] r9_a, r9_b;
reg [15:0] ra_a, ra_b;
reg [15:0] rb_a, rb_b;
reg [15:0] rc_a, rc_b;
reg [15:0] rd_a, rd_b;
reg [15:0] sp_low_a, sp_low_b;
reg [15:0] sp_high_a, sp_high_b;

`ifdef REG_PRELOAD
    initial begin
        r2_a <= 16'h8FFF;
        r2_b <= 16'h8FFF;
        r3_a <= 16'h0010;
        r3_b <= 16'h0010;
        r9_a <= 16'h0000;
        r9_b <= 16'h0000;
        ra_a <= 16'h0000;
        ra_b <= 16'h0000;
        rb_a <= 16'h0100;
        rb_b <= 16'h0100;
    end
`endif

always_ff @(posedge cpu_clk) begin
    case (src_w)
        4'b0000: begin end
        4'b0001: begin
            r1_a <= val;
            r1_b <= val;
        end
        4'b0010: begin
            r2_a <= val;
            r2_b <= val;
        end
        4'b0011: begin
            r3_a <= val;
            r3_b <= val;
        end
        4'b0100: begin
            r4_a <= val;
            r4_b <= val;
        end
        4'b0101: begin
            r5_a <= val;
            r5_b <= val;
        end
        4'b0110: begin
            r6_a <= val;
            r6_b <= val;
        end
        4'b0111: begin
            r7_a <= val;
            r7_b <= val;
        end
        4'b1000: begin
            r8_a <= val;
            r8_b <= val;
        end
        4'b1001: begin
            r9_a <= val;
            r9_b <= val;
        end
        4'b1010: begin
            ra_a <= val;
            ra_b <= val;
        end
        4'b1011: begin
            rb_a <= val;
            rb_b <= val;
        end
        4'b1100: begin
            rc_a <= val;
            rc_b <= val;
        end
        4'b1101: begin
            rd_a <= val;
            rd_b <= val;
        end
        4'b1110: begin
            sp_low_a <= val;
            sp_low_b <= val;
        end
        4'b1111: begin
            sp_high_a <= val;
            sp_high_b <= val;
        end
    endcase
end

logic [15:0] a_bus;
logic [15:0] b_bus;

always_comb begin
    case (src_a) 
        4'b0000: a_bus = 16'h0;
        4'b0001: a_bus = r1_a;
        4'b0010: a_bus = r2_a;
        4'b0011: a_bus = r3_a;
        4'b0100: a_bus = r4_a;
        4'b0101: a_bus = r5_a;
        4'b0110: a_bus = r6_a;
        4'b0111: a_bus = r7_a;
        4'b1000: a_bus = r8_a;
        4'b1001: a_bus = r9_a;
        4'b1010: a_bus = ra_a;
        4'b1011: a_bus = rb_a;
        4'b1100: a_bus = rc_a;
        4'b1101: a_bus = rd_a;
        4'b1110: a_bus = sp_low_a;
        4'b1111: a_bus = sp_high_a;
    endcase
end

always_comb begin
    case (src_b) 
        4'b0000: b_bus = 16'h0;
        4'b0001: b_bus = r1_b;
        4'b0010: b_bus = r2_b;
        4'b0011: b_bus = r3_b;
        4'b0100: b_bus = r4_b;
        4'b0101: b_bus = r5_b;
        4'b0110: b_bus = r6_b;
        4'b0111: b_bus = r7_b;
        4'b1000: b_bus = r8_b;
        4'b1001: b_bus = r9_b;
        4'b1010: b_bus = ra_b;
        4'b1011: b_bus = rb_b;
        4'b1100: b_bus = rc_b;
        4'b1101: b_bus = rd_b;
        4'b1110: b_bus = sp_low_b;
        4'b1111: b_bus = sp_high_b;
    endcase
end

assign a_out = src_a_en ? a_bus : 16'hZZZZ;
assign b_out = src_b_en ? b_bus : 16'hZZZZ;

endmodule
