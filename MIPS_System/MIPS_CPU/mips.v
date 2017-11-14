`timescale 1ns/1ps
`define mydelay 1

//--------------------------------------------------------------
// mips.v
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 23 October 2005
// Single-cycle MIPS processor
//--------------------------------------------------------------

// single-cycle MIPS processor
module mips(input         clk, reset,
            output [31:0] pc,
            input  [31:0] instr,
            output        memwrite,
            output [31:0] memaddr,
            output [31:0] memwritedata,
            input  [31:0] memreaddata);

  wire        signext, shiftl16, memtoreg, branch;
  wire        pcsrc, zero;
  wire        alusrc, regdst, regwrite, jump;
// ###### Hyeonmin Park: Start ######
  wire        pctoreg, regtopc;
  wire [3:0]  alucontrol;
// ###### Hyeonmin Park: End ######

  // Instantiate Controller
  controller c(
    .op         (instr[31:26]), 
		.funct      (instr[5:0]), 
		.zero       (zero),
		.signext    (signext),
		.shiftl16   (shiftl16),
		.memtoreg   (memtoreg),
		.memwrite   (memwrite),
		.pcsrc      (pcsrc),
		.alusrc     (alusrc),
		.regdst     (regdst),
		.regwrite   (regwrite),
		.jump       (jump),
// ###### Hyeonmin Park: Start ######
		.pctoreg    (pctoreg),
		.regtopc    (regtopc),
// ###### Hyeonmin Park: End ######
		.alucontrol (alucontrol));

  // Instantiate Datapath
  datapath dp(
    .clk        (clk),
    .reset      (reset),
    .signext    (signext),
    .shiftl16   (shiftl16),
    .memtoreg   (memtoreg),
    .pcsrc      (pcsrc),
    .alusrc     (alusrc),
    .regdst     (regdst),
    .regwrite   (regwrite),
    .jump       (jump),
	 .pctoreg    (pctoreg),
	 .regtopc    (regtopc),
    .alucontrol (alucontrol),
    .zero       (zero),
    .pc         (pc),
    .instr      (instr),
    .aluout     (memaddr), 
    .writedata  (memwritedata),
    .readdata   (memreaddata));

endmodule

module controller(input  [5:0] op, funct,
                  input        zero,
                  output       signext,
                  output       shiftl16,
                  output       memtoreg, memwrite,
                  output       pcsrc, alusrc,
                  output       regdst, regwrite,
                  output       jump,
// ###### Hyeonmin Park: Start ######
                  output       pctoreg, regtopc,
                  output [3:0] alucontrol);
// ###### Hyeonmin Park: End ######

  wire [1:0] aluop;
  wire       branch;

  maindec md(
    .op       (op),
    .signext  (signext),
    .shiftl16 (shiftl16),
    .memtoreg (memtoreg),
    .memwrite (memwrite),
    .branch   (branch),
    .alusrc   (alusrc),
    .regdst   (regdst),
    .regwrite (regwrite),
    .jump     (jump),
// ###### Hyeonmin Park: Start ######
	 .pctoreg  (pctoreg),
// ###### Hyeonmin Park: End ######
    .aluop    (aluop));

  aludec ad( 
    .funct      (funct),
    .aluop      (aluop), 
    .alucontrol (alucontrol));

// ###### Hyeonmin Park: Start ######
  assign pcsrc = branch & (op == 6'b000100 ? zero : ~zero);
  assign regtopc = (op == 6'b000000 && funct == 6'b001000);
// ###### Hyeonmin Park: End ######

endmodule


module maindec(input  [5:0] op,
               output       signext,
               output       shiftl16,
               output       memtoreg, memwrite,
               output       branch, alusrc,
               output       regdst, regwrite,
               output       jump,
// ###### Hyeonmin Park: Start ######
					output       pctoreg,
// ###### Hyeonmin Park: End ######
               output [1:0] aluop);

// ###### Hyeonmin Park: Start ######
  reg [11:0] controls;
// ###### Hyeonmin Park: End ######

  assign {signext, shiftl16, regwrite, regdst, alusrc, branch, memwrite,
// ###### Hyeonmin Park: Start ######
          memtoreg, jump, pctoreg, aluop} = controls;
// ###### Hyeonmin Park: End ######

  always @(*)
    case(op)
// ###### Hyeonmin Park: Start ######
      6'b000000: controls <= #`mydelay 12'b001100000011; // Rtype
      6'b100011: controls <= #`mydelay 12'b101010010000; // LW
      6'b101011: controls <= #`mydelay 12'b100010100000; // SW
      6'b000100: controls <= #`mydelay 12'b100001000001; // BEQ
		6'b000101: controls <= #`mydelay 12'b100001000001; // BNE: only difference is PCSrc
      6'b001000, 
      6'b001001: controls <= #`mydelay 12'b101010000000; // ADDI, ADDIU: only difference is exception
      6'b001101: controls <= #`mydelay 12'b001010000010; // ORI
      6'b001111: controls <= #`mydelay 12'b011010000000; // LUI
      6'b000010: controls <= #`mydelay 12'b000000001000; // J
		6'b000011: controls <= #`mydelay 12'b001000001100; // JAL
      default:   controls <= #`mydelay 12'bxxxxxxxxxxxx; // ???
// ###### Hyeonmin Park: End ######
    endcase

endmodule

module aludec(input      [5:0] funct,
              input      [1:0] aluop,
// ###### Hyeonmin Park: Start ######
              output reg [3:0] alucontrol);
// ###### Hyeonmin Park: End ######

  always @(*)
    case(aluop)
      2'b00: alucontrol <= #`mydelay 4'b0010;  // add
      2'b01: alucontrol <= #`mydelay 4'b0110;  // sub
      2'b10: alucontrol <= #`mydelay 4'b0001;  // or
      default: case(funct)          // RTYPE
// ###### Hyeonmin Park: Start ######
          6'b000100: alucontrol <= #`mydelay 4'b0010; // JR
          6'b100000,
          6'b100001: alucontrol <= #`mydelay 4'b0010; // ADD, ADDU: only difference is exception
          6'b100010,
          6'b100011: alucontrol <= #`mydelay 4'b0110; // SUB, SUBU: only difference is exception
          6'b100100: alucontrol <= #`mydelay 4'b0000; // AND
          6'b100101: alucontrol <= #`mydelay 4'b0001; // OR
          6'b101010: alucontrol <= #`mydelay 4'b0111; // SLT
          6'b101011: alucontrol <= #`mydelay 4'b1111; // SLTU
          default:   alucontrol <= #`mydelay 4'bxxxx; // ???
// ###### Hyeonmin Park: End ######
        endcase
    endcase
    
endmodule

module datapath(input         clk, reset,
                input         signext,
                input         shiftl16,
                input         memtoreg, pcsrc,
                input         alusrc, regdst,
                input         regwrite, jump,
// ###### Hyeonmin Park: Start ######
                input         pctoreg, regtopc,
                input  [3:0]  alucontrol,
// ###### Hyeonmin Park: End ######
                output        zero,
                output [31:0] pc,
                input  [31:0] instr,
                output [31:0] aluout, writedata,
                input  [31:0] readdata);

  wire [4:0]  writereg;
// ###### Hyeonmin Park: Start ######
  wire [4:0]  writereg2;
// ###### Hyeonmin Park: End ######
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
// ###### Hyeonmin Park: Start ######
  wire [31:0] pcnextjr;
// ###### Hyeonmin Park: End ######
  wire [31:0] signimm, signimmsh, shiftedimm;
  wire [31:0] srca, srcb;
  wire [31:0] result;
// ###### Hyeonmin Park: Start ######
  wire [31:0] result2;
// ###### Hyeonmin Park: End ######
  wire        shift;

  // next PC logic
  flopr #(32) pcreg(
    .clk   (clk),
    .reset (reset),
    .d     (pcnext),
    .q     (pc));

  adder pcadd1(
    .a (pc),
    .b (32'b100),
    .y (pcplus4));

  sl2 immsh(
    .a (signimm),
    .y (signimmsh));
				 
  adder pcadd2(
    .a (pcplus4),
    .b (signimmsh),
    .y (pcbranch));

  mux2 #(32) pcbrmux(
    .d0  (pcplus4),
    .d1  (pcbranch),
    .s   (pcsrc),
    .y   (pcnextbr));

// ###### Hyeonmin Park: Start ######
  mux2 #(32) pcjrmux(
    .d0  (pcnextbr),
    .d1  (srca),
    .s   (regtopc),
    .y   (pcnextjr));
// ###### Hyeonmin Park: End ######

  mux2 #(32) pcmux(
// ###### Hyeonmin Park: Start ######
    .d0   (pcnextjr),
// ###### Hyeonmin Park: End ######
    .d1   ({pcplus4[31:28], instr[25:0], 2'b00}),
    .s    (jump),
    .y    (pcnext));

  // register file logic
  regfile rf(
    .clk     (clk),
    .we      (regwrite),
    .ra1     (instr[25:21]),
    .ra2     (instr[20:16]),
// ###### Hyeonmin Park: Start ######
    .wa      (writereg2),
    .wd      (result2),
// ###### Hyeonmin Park: End ######
    .rd1     (srca),
    .rd2     (writedata));

  mux2 #(5) wrmux(
    .d0  (instr[20:16]),
    .d1  (instr[15:11]),
    .s   (regdst),
    .y   (writereg));

// ###### Hyeonmin Park: Start ######
  mux2 #(5) wrmux2(
    .d0  (writereg),
	 .d1  (5'b11111),
	 .s   (pctoreg),
	 .y   (writereg2));
// ###### Hyeonmin Park: End ######

  mux2 #(32) resmux(
    .d0 (aluout),
    .d1 (readdata),
    .s  (memtoreg),
    .y  (result));

// ###### Hyeonmin Park: Start ######
  mux2 #(32) resmux2(
    .d0 (result),
    .d1 (pcplus4),
    .s  (pctoreg),
    .y  (result2));
// ###### Hyeonmin Park: End ######

  sign_zero_ext sze(
    .a       (instr[15:0]),
    .signext (signext),
    .y       (signimm[31:0]));

  shift_left_16 sl16(
    .a         (signimm[31:0]),
    .shiftl16  (shiftl16),
    .y         (shiftedimm[31:0]));

  // ALU logic
  mux2 #(32) srcbmux(
    .d0 (writedata),
    .d1 (shiftedimm[31:0]),
    .s  (alusrc),
    .y  (srcb));

  alu alu(
    .a       (srca),
    .b       (srcb),
    .alucont (alucontrol),
    .result  (aluout),
    .zero    (zero));
    
endmodule
