module fetch(
    input wire cpu_clk,
    input wire cpu_rst,
    input wire stall,
    input wire ins_res,
    input wire pc_en,
    input wire pc_add,
    input wire [31:0] data,
    input wire [30:0] pc,
    output wire ins_req,
    output wire [29:0] addr,
    output wire [15:0] ins,
    output wire ins_en,
    output wire [15:0] ext
);

`define EXT(sig) sig[15]
`define OPCODE(sig) sig[14:10]
`define OPCODE_JMPIMM 5'b11110
`define OPCODE_JMP 5'b11111
`define OPCODE_BN 5'b11100
`define OPCODE_B 5'b11101

reg active_buf;
reg [15:0] a_mbufa;
reg [15:0] a_mbufb;
reg [1:0] a_state;
reg [15:0] b_mbufa;
reg [15:0] b_mbufb;
reg [1:0] b_state;

reg [15:0] ins_buf;
reg ins_valid;
reg [15:0] ext_buf;
reg ext_valid;

reg [29:0] ip;
reg req;
reg use_a;
reg pending_jmp;
reg jmping_a;
reg jmping_b;
reg req_made;

always_ff @(posedge cpu_clk) begin
    if (cpu_rst) begin
        use_a <= 1'b1;
        ip <= 30'h0;
        req <= 1'b0;
        active_buf <= 1'b0;
        a_state <= 2'h0;
        b_state <= 2'h0;
        ins_valid <= 1'b0;
        ext_valid <= 1'b0;
        pending_jmp <= 1'b0;
        jmping_a <= 1'b0;
        jmping_b <= 1'b0;
        req_made <= 1'b0;
    end
end

// request data
assign ins_req = !jmping_a && !jmping_b && !cpu_rst && !stall && 
                 !((a_state[0] || a_state[1]) && (b_state[0] || b_state[1]));

wire [15:0] a_buf, b_buf;
wire sign_a, sign_b;
wire ext_a, ext_b;
wire fork_a, fork_b;
wire accept_res;
assign a_buf = data[15:0];
assign b_buf = data[31:16];
assign sign_a = a_buf[9];
assign sign_b = b_buf[9];
assign fork_a = `OPCODE(a_buf) == `OPCODE_JMPIMM;
assign fork_b = `OPCODE(b_buf) == `OPCODE_JMPIMM;
assign ext_a = `EXT(a_buf);
assign ext_b = `EXT(b_buf);
assign accept_res = ins_res && !(jmping_a || jmping_b);

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
        req_made <= ins_req;
    end
end

// latch data and handle control transfers
always_ff @(posedge cpu_clk) begin
    if (!cpu_rst && accept_res) begin
        if (!(a_state[0] || a_state[1])) begin
            if (pending_jmp) begin
                a_mbufa <= b_mbufb;
                a_mbufb <= a_buf;
                a_state <= 2'b11;
                use_a <= 1'b1;
                b_state <= 2'b00;
                ip <= ip + { {4{b_mbufb[9]}}, a_buf, b_mbufb[9:0] };
            end else begin
                a_mbufa <= a_buf;
                a_mbufb <= b_buf;
                a_state <= { (~fork_a | ext_a), 1'b1 };
            end
        end else if (!(b_state[0] || b_state[1])) begin
            if (pending_jmp) begin
                b_mbufa <= a_mbufb;
                b_mbufb <= a_buf;
                a_state <= 2'b00;
                b_state <= 2'b11;
                ip <= ip + { {4{a_mbufb[9]}}, a_buf, a_mbufb[9:0] };
            end else begin
                b_mbufa <= data[15:0];
                b_mbufb <= data[31:16];
                b_state <= { (~fork_a | ext_a) & ~pending_jmp, ~pending_jmp };
            end
        end
        if (!pending_jmp) begin
            if (fork_a) begin
                if (ext_a) ip <= ip + { {4{sign_a}}, b_buf, a_buf[9:0] };
                else ip <= ip + { {20{sign_a}}, a_buf[9:0] };
            end else if (fork_b) begin 
                if (ext_b) begin 
                    pending_jmp <= 1'b1;
                    ip <= ip + 1;
                end
                else ip <= ip + { {20{sign_b}}, b_buf[9:0] };
            end else begin
                if (!pending_jmp) ip <= ip + 1;
            end
        end else pending_jmp <= 1'b0;
    end
end

// release instruction
always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
    if (!(jmping_a || jmping_b)) begin
        if (use_a) begin
            if (a_state[0] || a_state[1]) begin
                jmping_a <= (`OPCODE(a_mbufa) == `OPCODE_JMP || 
                             `OPCODE(a_mbufa) == `OPCODE_BN ||
                             `OPCODE(a_mbufa) == `OPCODE_B);
                jmping_b <= !`EXT(a_mbufa) && 
                            (`OPCODE(a_mbufb) == `OPCODE_JMP ||
                             `OPCODE(a_mbufb) == `OPCODE_BN ||
                             `OPCODE(a_mbufb) == `OPCODE_B);
            end
        end else begin
            if (b_state[0] || b_state[1]) begin
                jmping_a <= (`OPCODE(b_mbufa) == `OPCODE_JMP || 
                             `OPCODE(b_mbufa) == `OPCODE_BN ||
                             `OPCODE(b_mbufa) == `OPCODE_B);
                jmping_b <= !`EXT(b_mbufa) && 
                            (`OPCODE(b_mbufb) == `OPCODE_JMP ||
                             `OPCODE(b_mbufb) == `OPCODE_BN ||
                             `OPCODE(b_mbufb) == `OPCODE_B);
            end
        end
    end

    if (use_a && a_state[0]) begin
        if (`EXT(a_mbufa)) begin
            ins_buf <= a_mbufa;
            ins_valid <= 1'b1;
            ext_buf <= a_mbufb;
            ext_valid <= 1'b1;
            a_state <= 2'b00;
            use_a <= 1'b0;
        end else begin
            ins_buf <= a_mbufa;
            ins_valid <= 1'b1;
            ext_valid <= 1'b0;
            a_state[0] <= 1'b0;
            if (jmping_a || jmping_b) begin
                a_state[1] <= 1'b0;
            end
            use_a <= a_state[1];
        end
    end else if (use_a && a_state[1]) begin
        if (`EXT(a_mbufb)) begin
            if (b_state[0]) begin
                ins_buf <= a_mbufb;
                ins_valid <= 1'b1;
                ext_buf <= b_mbufa;
                ext_valid <= 1'b1;
                a_state <= 2'b00;
                if (jmping_a || jmping_b) b_state <= 2'b00;
                else b_state[0] <= 1'b0;
                use_a <= 1'b0;
            end
        end else begin
            ins_buf <= a_mbufb;
            ins_valid <= 1'b1;
            ext_valid <= 1'b0;
            a_state <= 2'b00;
            if (jmping_a) begin 
                b_state <= 2'b00;
                use_a <= 1'b1;
            end else use_a <= 1'b0;
        end
    end else if (b_state[0]) begin
        if (`EXT(b_mbufa)) begin
            ins_buf <= b_mbufa;
            ins_valid <= 1'b1;
            ext_buf <= b_mbufb;
            ext_valid <= 1'b1;
            b_state <= 2'b00;
            use_a <= 1'b1;
        end else begin
            ins_buf <= b_mbufa;
            ins_valid <= 1'b1;
            ext_valid <= 1'b0;
            b_state[0] <= 1'b0;
            if (jmping_a || jmping_b) begin
                b_state[1] <= 1'b0;
                use_a <= 1'b1;
            end
        end
    end else if (b_state[1]) begin
        if (`EXT(b_mbufb)) begin
            if (a_state[0]) begin
                ins_buf <= b_mbufb;
                ins_valid <= 1'b1;
                ext_buf <= a_mbufa;
                if (jmping_a || jmping_b) a_state <= 2'b00;
                else a_state[0] <= 1'b0;
                b_state <= 2'b00;
                use_a <= 1'b1;
            end
        end else begin
            ins_buf <= b_mbufb;
            ins_valid <= 1'b1;
            ext_valid <= 1'b0;
            b_state <= 2'b00;
            use_a <= 1'b1;
            if (jmping_a) a_state <= 2'b00;
        end
    end else begin
        ins_valid <= 1'b0;
        ext_valid <= 1'b0;
    end
    end
end

always_ff @(posedge cpu_clk) begin
    if (!cpu_rst) begin
    if ((jmping_a || jmping_b) && (pc_en || pc_add)) begin
        if (pc_en) begin
            // TODO: word aligned jumps
            ip <= pc[30:1];
            jmping_a <= 1'b0;
            jmping_b <= 1'b0;
        end
        if (pc_add) begin
            ip <= ip + { {14{pc[15]}}, pc[15:0] };
            jmping_a <= 1'b0;
            jmping_b <= 1'b0;
        end
    end
    end
end

wire jmping;
assign jmping = jmping_a || jmping_b;

assign addr = ip;

assign ins = ins_buf;
assign ins_en = ins_valid;
assign ext = ext_buf;

endmodule
