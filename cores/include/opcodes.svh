`define EXT(sig) sig[15]
`define OPCODE(sig) sig[14:10]
`define OPCODE_JMPIMM 5'b11110
`define OPCODE_JMP 5'b11111
`define OPCODE_BN 5'b11100
`define OPCODE_B 5'b11101
