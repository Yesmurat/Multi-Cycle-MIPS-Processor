module datapath (
    input clk, reset, pcen,
    input iord, irwrite, regdst,
    input memtoreg, regwrite, alusrca,

    input [1:0] alusrcb,
    input [2:0] alucontrol,
    input [1:0] pcsrc,
    input [31:0] readdata,

    output [5:0] op, funct,
    output zero,
    output [31:0] adr,
    output [31:0] writedata
);

wire [31:0] pc, pcnext;
wire [31:0] address, aluout;
wire [31:0] instr, data;
wire [4:0] writereg;
wire [31:0] wd3, rd1, rd2;
wire [31:0] avalue;
wire [31:0] srca, srcb;
wire [31:0] signimm, shiftimm;
wire [31:0] aluresult, jumpadr;

// Op and Funct fields for control unit
assign op = instr[31:26];
assign funct = instr[5:0];

// Jump address used for j instruction
assign jumpadr = {pc[31:28], instr[25:0], 2'b00};

// 32-bit register for PC; loads pcnext when pcen is high
flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);

// selects whether to use PC (for fetching instruction) or ALUOut (for memory access)
mux2 #(32) memmux(pc, aluout, iord, adr);

// stores fetched instructions when irwrite is high
flopenr #(32) instrreg(clk, reset, irwrite, readdata, instr);

flopenr #(32) datareg(clk, reset, 1'b1, readdata, data);

// Register File Logic

// chooses destination register: rt or rd.
mux2 #(5) a3mux(instr[20:16], instr[15:11], regdst, writereg);

// chooses between ALU result and memory read data
mux2 #(32) wd3mux(aluout, data, memtoreg, wd3);

// Register File itself
/*
rs, rt --> read ports
writereg, wd3 --> write ports
regwrite enables the write
*/
regfile rf(clk, regwrite, instr[25:21], instr[20:16], writereg, wd3, rd1, rd2);

/*
writedata will be used in memory write
avalue is passed to ALU
*/
flopenr #(32) areg(clk, reset, 1'b1, rd1, avalue);
flopenr #(32) breg(clk, reset, 1'b1, rd2, writedata);

// ALU Input Logic
// pc or A (from regfile) -> to ALU A input
mux2 #(32) srcamux(pc, avalue, alusrca, srca);

// sign extend the immediate and shift left by 2 (for branch)
signext se(instr[15:0], signimm);
sl2 shift(signimm, shiftimm);

// one of: B (writedata), 4 (for PC + 4), immediate, shifted immediate
mux4 #(32) srcbmux(writedata, 32'b100, signimm, shiftimm, alusrcb, srcb);

// performs ADD/SUB/AND/OR/SLT/etc. and sets zero for branch comparison
alu alu(srca, srcb, alucontrol, aluresult, zero);

// stores ALU result (needed for memory address in lw/sw)
flopenr #(32) alureg(clk, reset, 1'b1, aluresult, aluout);

// chooses next PC either: from ALU (for PC + 4), from branch target, or jump address
mux3 #(32) pcmux(aluresult, aluout, jumpadr, pcsrc, pcnext);
    
endmodule