module formal_tb();

wire signed [15:0] x;
wire [15:0] y;
wire [3:0] off;
wire [2:0] op;

`define WHEN_OP_EQ_ASSERT(opcode, cond) assert ( !(op == opcode) || (cond) )

roller dut(
    .x(x),
    .off(off),
    .shift(op[0]),
    .right(op[1]),
    .arith(op[2]),
    .y(y)
);

wire [15:0] rol;
wire [15:0] ror;
wire [15:0] shl;
wire [15:0] shr;
wire [15:0] sar;
wire [15:0] sal;

assign rol = ({x,x} >> (16-off));
assign ror = ({x,x} >> off);
assign shl = x << off;
assign shr = x >> off;
assign sal = x <<< off;
assign sar = x >>> off;

always_comb begin
    assert_rol: `WHEN_OP_EQ_ASSERT(3'b000, y == rol);
    assert_ror: `WHEN_OP_EQ_ASSERT(3'b010, y == ror);
    assert_shl: `WHEN_OP_EQ_ASSERT(3'b001, y == shl);
    assert_shr: `WHEN_OP_EQ_ASSERT(3'b011, y == shr);
    assert_sal: `WHEN_OP_EQ_ASSERT(3'b101, y == sal);
    assert_sar: `WHEN_OP_EQ_ASSERT(3'b111, y == sar);
end

endmodule
