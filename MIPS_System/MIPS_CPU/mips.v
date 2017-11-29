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

// ###### Hyeonmin Park: Start ######
  wire        signext, shiftl16, memread, memtoreg, branch;
// ###### Hyeonmin Park: End ######
  wire        pcsrc, zero;
  wire        alusrc, regdst, regwrite, jump;
// ###### Hyeonmin Park: Start ######
  wire        pctoreg, regtopc;
  wire [3:0]  alucontrol;
  wire [31:0] ID_instr;
  wire        MEM_regwrite, WB_regwrite, EX_memread;
  wire [4:0]  ID_rs, ID_rt, EX_rs, EX_rt, MEM_writereg, WB_writereg;
  wire [2:0]  fwda, fwdb;
  wire [1:0]  hazard;
// ###### Hyeonmin Park: End ######

  // Instantiate Controller
  controller c(
// ###### Hyeonmin Park: Start ######
    .clk        (clk),
    .reset      (reset),
    .op         (ID_instr[31:26]), 
		.funct      (ID_instr[5:0]), 
// ###### Hyeonmin Park: End ######
		.zero       (zero),
// ###### Hyeonmin Park: Start ######
		.hazard     (hazard),
// ###### Hyeonmin Park: End ######
		.signext    (signext),
		.shiftl16   (shiftl16),
		.memtoreg   (memtoreg),
// ###### Hyeonmin Park: Start ######
		.memread    (memread),
// ###### Hyeonmin Park: End ######
		.memwrite   (memwrite),
		.pcsrc      (pcsrc),
		.alusrc     (alusrc),
		.regdst     (regdst),
		.regwrite   (regwrite),
		.jump       (jump),
// ###### Hyeonmin Park: Start ######
		.pctoreg    (pctoreg),
		.regtopc    (regtopc),
		.alucontrol (alucontrol),
		.EX_memread (EX_memread),
		.MEM_regwrite (MEM_regwrite),
		.WB_regwrite (WB_regwrite));
// ###### Hyeonmin Park: End ######

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
// ###### Hyeonmin Park: Start ######
    .pctoreg    (pctoreg),
    .regtopc    (regtopc),
// ###### Hyeonmin Park: End ######
    .alucontrol (alucontrol),
// ###### Hyeonmin Park: Start ######
    .fwda       (fwda),
    .fwdb       (fwdb),
    .hazard     (hazard),
// ###### Hyeonmin Park: End ######
    .zero       (zero),
    .pc         (pc),
    .instr      (instr),
// ###### Hyeonmin Park: Start ######
    .ID_instr   (ID_instr),
    .ID_rs      (ID_rs),
    .ID_rt      (ID_rt),
    .EX_rs      (EX_rs),
    .EX_rt      (EX_rt),
    .MEM_writereg (MEM_writereg),
    .WB_writereg (WB_writereg),
// ###### Hyeonmin Park: End ######
    .aluout     (memaddr), 
    .writedata  (memwritedata),
    .readdata   (memreaddata));

// ###### Hyeonmin Park: Start ######
  forwarding fwd(
    .MEM_regwrite (MEM_regwrite),
    .WB_regwrite  (WB_regwrite),
    .ID_rs        (ID_rs),
    .ID_rt        (ID_rt),
    .EX_rs        (EX_rs),
    .EX_rt        (EX_rt),
    .MEM_writereg (MEM_writereg),
    .WB_writereg  (WB_writereg),
    .fwda         (fwda),
    .fwdb         (fwdb));

  hazarddetection hzd(
    .reset      (reset),
    .EX_memread (EX_memread),
    .ID_rs      (ID_rs),
    .ID_rt      (ID_rt),
    .EX_rt      (EX_rt),
    .pcsrc      (pcsrc),
    .regtopc    (regtopc),
    .jump       (jump),
    .hazard     (hazard));
// ###### Hyeonmin Park: End ######

endmodule

// ###### Hyeonmin Park: Start ######
module controller(input        clk,
                  input        reset,
                  input  [5:0] op, funct,
// ###### Hyeonmin Park: End ######
                  input        zero,
// ###### Hyeonmin Park: Start ######
                  input  [1:0] hazard,
// ###### Hyeonmin Park: End ######
                  output       signext,
                  output       shiftl16,
// ###### Hyeonmin Park: Start ######
                  output       memtoreg, memread, memwrite,
// ###### Hyeonmin Park: End ######
                  output       pcsrc, alusrc,
                  output       regdst, regwrite,
                  output       jump,
// ###### Hyeonmin Park: Start ######
                  output       pctoreg, regtopc,
                  output [3:0] alucontrol,
                  output       EX_memread,
                  output       MEM_regwrite,
                  output       WB_regwrite);
// ###### Hyeonmin Park: End ######

// ###### Hyeonmin Park: Start ######
  wire [2:0] aluop;
// ###### Hyeonmin Park: End ######
  wire       branch;
// ###### Hyeonmin Park: Start ######
  wire        branchn;
  wire        ID_regdst;
  wire [2:0]  ID_aluop;
  wire        ID_alusrc;
  wire        ID_branch;
  wire        ID_branchn;
  wire        ID_regtopc;
  wire        ID_jump;
  wire        ID_memread;
  wire        ID_memwrite;
  wire        ID_memtoreg;
  wire        ID_pctoreg;
  wire        ID_regwrite;
  wire [13:0] ID_Control;
  wire [13:0] ID_Control2;
  wire        EX_regdst;
  wire [2:0]  EX_aluop;
  wire        EX_alusrc;
  wire        EX_branch;
  wire        EX_branchn;
  wire        EX_regtopc;
  wire        EX_jump;
  wire [1:0]  EX_MEM;
  wire [2:0]  EX_WB;
  wire [5:0]  EX_funct;
  wire        MEM_memread;
  wire        MEM_memwrite;
  wire [2:0]  MEM_WB;
  wire        WB_memtoreg;
  wire        WB_pctoreg;

  assign ID_Control = {ID_regdst, ID_aluop, ID_alusrc, ID_branch, ID_branchn, ID_regtopc, ID_jump, ID_memread, ID_memwrite, ID_memtoreg, ID_pctoreg, ID_regwrite};
  assign EX_memread = EX_MEM[1];
  assign MEM_regwrite = MEM_WB[0];
  assign {regdst, aluop, alusrc, regtopc, jump, memread, memwrite, memtoreg, pctoreg, regwrite} = {EX_regdst, EX_aluop, EX_alusrc, EX_regtopc, EX_jump, MEM_memread, MEM_memwrite, WB_memtoreg, WB_pctoreg, WB_regwrite};
// ###### Hyeonmin Park: End ######

  maindec md(
    .op       (op),
    .signext  (signext),
    .shiftl16 (shiftl16),
// ###### Hyeonmin Park: Start ######
    .memtoreg (ID_memtoreg),
    .memread  (ID_memread),
    .memwrite (ID_memwrite),
    .branch   (ID_branch),
    .branchn  (ID_branchn),
    .alusrc   (ID_alusrc),
    .regdst   (ID_regdst),
    .regwrite (ID_regwrite),
    .jump     (ID_jump),
    .pctoreg  (ID_pctoreg),
    .aluop    (ID_aluop));
// ###### Hyeonmin Park: End ######

  aludec ad( 
// ###### Hyeonmin Park: Start ######
    .funct      (EX_funct),
    .aluop      (EX_aluop), 
// ###### Hyeonmin Park: End ######
    .alucontrol (alucontrol));

// ###### Hyeonmin Park: Start ######
  mux2 #(14) hazardmux(
    .d0 (ID_Control),
    .d1 (14'b0),
    .s  (hazard[0] | hazard[1]),
    .y  (ID_Control2));

  flopr #(20) idex(
    .clk   (clk),
    .reset (reset),
    .d     ({ID_Control2, funct}),
    .q     ({EX_regdst, EX_aluop, EX_alusrc, EX_branch, EX_branchn, EX_regtopc, EX_jump, EX_MEM, EX_WB, EX_funct}));

  flopr #(5) exmem(
    .clk   (clk),
    .reset (reset),
    .d     ({EX_MEM, EX_WB}),
    .q     ({MEM_memread, MEM_memwrite, MEM_WB}));

  flopr #(3) memwb(
    .clk   (clk),
    .reset (reset),
    .d     ({MEM_WB}),
    .q     ({WB_memtoreg, WB_pctoreg, WB_regwrite}));

  assign pcsrc = (EX_branch & zero) | (EX_branchn & ~zero);
  assign ID_regtopc = (op == 6'b000000) & (funct == 6'b001000);
// ###### Hyeonmin Park: End ######

endmodule


module maindec(input  [5:0] op,
               output       signext,
               output       shiftl16,
// ###### Hyeonmin Park: Start ######
               output       memtoreg, memread, memwrite,
               output       branch, branchn, alusrc,
// ###### Hyeonmin Park: End ######
               output       regdst, regwrite,
               output       jump,
// ###### Hyeonmin Park: Start ######
               output       pctoreg,
               output [2:0] aluop);
// ###### Hyeonmin Park: End ######

// ###### Hyeonmin Park: Start ######
  reg [14:0] controls;
// ###### Hyeonmin Park: End ######

// ###### Hyeonmin Park: Start ######
  assign {signext, shiftl16, regwrite, regdst, alusrc, branch, branchn, memread, memwrite,
          memtoreg, jump, pctoreg, aluop} = controls;
// ###### Hyeonmin Park: End ######

  always @(*)
    case(op)
// ###### Hyeonmin Park: Start ######
      6'b000000: controls <= #`mydelay 15'b001100000000111; // Rtype
      6'b100011: controls <= #`mydelay 15'b101010010100000; // LW
      6'b101011: controls <= #`mydelay 15'b100010001000000; // SW
      6'b000100: controls <= #`mydelay 15'b100001000000001; // BEQ
      6'b000101: controls <= #`mydelay 15'b100000100000001; // BNE
      6'b001000, 
      6'b001001: controls <= #`mydelay 15'b101010000000000; // ADDI, ADDIU: only difference is exception
      6'b001010: controls <= #`mydelay 15'b101010000000011; // SLTI
      6'b001011: controls <= #`mydelay 15'b101010000000100; // SLTIU
      6'b001101: controls <= #`mydelay 15'b001010000000010; // ORI
      6'b001111: controls <= #`mydelay 15'b011010000000000; // LUI
      6'b000010: controls <= #`mydelay 15'b000000000010000; // J
      6'b000011: controls <= #`mydelay 15'b001000000011000; // JAL
      default:   controls <= #`mydelay 15'bxxxxxxxxxxxxxxx; // ???
// ###### Hyeonmin Park: End ######
    endcase

endmodule

module aludec(input      [5:0] funct,
// ###### Hyeonmin Park: Start ######
              input      [2:0] aluop,
              output reg [3:0] alucontrol);
// ###### Hyeonmin Park: End ######

  always @(*)
    case(aluop)
// ###### Hyeonmin Park: Start ######
      3'b000: alucontrol <= #`mydelay 4'b0010;  // add
      3'b001: alucontrol <= #`mydelay 4'b0110;  // sub
      3'b010: alucontrol <= #`mydelay 4'b0001;  // or
      3'b011: alucontrol <= #`mydelay 4'b0111;  // slt
      3'b100: alucontrol <= #`mydelay 4'b1111;  // sltu
// ###### Hyeonmin Park: End ######
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
                input  [2:0]  fwda, fwdb,
                input  [1:0]  hazard,
// ###### Hyeonmin Park: End ######
                output        zero,
                output [31:0] pc,
                input  [31:0] instr,
// ###### Hyeonmin Park: Start ######
                output [31:0] ID_instr,
                output [4:0]  ID_rs, ID_rt, EX_rs, EX_rt, MEM_writereg, WB_writereg,
// ###### Hyeonmin Park: End ######
                output [31:0] aluout, writedata,
                input  [31:0] readdata);

// ###### Hyeonmin Park: Start ######
  wire [4:0]  writereg, writereg2;
  wire [31:0] pcnext, pcnext2, pcnextbr, pcnextjr, pcplus4, pcbranch;
// ###### Hyeonmin Park: End ######
  wire [31:0] signimm, signimmsh, shiftedimm;
// ###### Hyeonmin Park: Start ######
  wire [31:0] srca, srca2, srcb, srcb2;
  wire [31:0] result, result2;
// ###### Hyeonmin Park: End ######
  wire        shift;
// ###### Hyeonmin Park: Start ######
  wire [31:0] writedata2;
  wire [31:0] ID_srca;
  wire [31:0] ID_writedata;
  wire [31:0] ID_shiftedimm;
  wire [4:0]  ID_rd;
  wire [31:0] EX_instr;
  wire [31:0] EX_srca;
  wire [31:0] EX_writedata;
  wire [31:0] EX_signimm;
  wire [31:0] EX_shiftedimm;
  wire [31:0] EX_aluout;
  wire [31:0] EX_pcplus4;
  wire [31:0] EX_pc;
  wire [4:0]  EX_writereg;
  wire [4:0]  EX_rd;
  wire [31:0] MEM_aluout;
  wire [31:0] MEM_writedata;
  wire [31:0] MEM_pc;
  wire [31:0] WB_readdata;
  wire [31:0] WB_aluout;
  wire [31:0] WB_pc;

  assign aluout = MEM_aluout;
  assign writedata = MEM_writedata;
  assign ID_rs = ID_instr[25:21];
  assign ID_rt = ID_instr[20:16];
  assign ID_rd = ID_instr[15:11];
// ###### Hyeonmin Park: End ######

  // next PC logic
// ###### Hyeonmin Park: Start ######
  flopenr #(32) pcreg(
// ###### Hyeonmin Park: End ######
    .clk   (clk),
    .reset (reset),
// ###### Hyeonmin Park: Start ######
    .en    (~hazard[0]),
    .d     (pcnext2),
// ###### Hyeonmin Park: End ######
    .q     (pc));

  adder pcadd1(
    .a (pc),
    .b (32'b100),
    .y (pcplus4));

  sl2 immsh(
// ###### Hyeonmin Park: Start ######
    .a (EX_signimm),
// ###### Hyeonmin Park: End ######
    .y (signimmsh));
				 
  adder pcadd2(
// ###### Hyeonmin Park: Start ######
    .a (EX_pc),
// ###### Hyeonmin Park: End ######
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
    .d1  (srca2),
    .s   (regtopc),
    .y   (pcnextjr));
// ###### Hyeonmin Park: End ######

  mux2 #(32) pcmux(
// ###### Hyeonmin Park: Start ######
    .d0   (pcnextjr),
    .d1   ({pcplus4[31:28], EX_instr[25:0], 2'b00}),
// ###### Hyeonmin Park: End ######
    .s    (jump),
    .y    (pcnext));

// ###### Hyeonmin Park: Start ######
  mux2 #(32) pcmux2(
    .d0   (pcplus4),
    .d1   (pcnext),
    .s    (hazard[1]),
    .y    (pcnext2));
// ###### Hyeonmin Park: End ######

  // register file logic
  regfile rf(
    .clk     (clk),
    .we      (regwrite),
// ###### Hyeonmin Park: Start ######
    .ra1     (ID_rs),
    .ra2     (ID_rt),
    .wa      (writereg2),
    .wd      (result2),
    .rd1     (ID_srca),
    .rd2     (ID_writedata));
// ###### Hyeonmin Park: End ######

  mux2 #(5) wrmux(
// ###### Hyeonmin Park: Start ######
    .d0  (EX_rt),
    .d1  (EX_rd),
// ###### Hyeonmin Park: End ######
    .s   (regdst),
// ###### Hyeonmin Park: Start ######
    .y   (EX_writereg));
// ###### Hyeonmin Park: End ######

// ###### Hyeonmin Park: Start ######
  mux2 #(5) wrmux2(
    .d0  (WB_writereg),
    .d1  (5'b11111),
    .s   (pctoreg),
    .y   (writereg2));
// ###### Hyeonmin Park: End ######

  mux2 #(32) resmux(
// ###### Hyeonmin Park: Start ######
    .d0 (WB_aluout),
    .d1 (WB_readdata),
// ###### Hyeonmin Park: End ######
    .s  (memtoreg),
    .y  (result));

// ###### Hyeonmin Park: Start ######
  mux2 #(32) resmux2(
    .d0 (result),
    .d1 (WB_pc),
    .s  (pctoreg),
    .y  (result2));
// ###### Hyeonmin Park: End ######

  sign_zero_ext sze(
// ###### Hyeonmin Park: Start ######
    .a       (ID_instr[15:0]),
// ###### Hyeonmin Park: End ######
    .signext (signext),
    .y       (signimm[31:0]));

  shift_left_16 sl16(
    .a         (signimm[31:0]),
    .shiftl16  (shiftl16),
// ###### Hyeonmin Park: Start ######
    .y         (ID_shiftedimm[31:0]));
// ###### Hyeonmin Park: End ######

  // ALU logic
  mux2 #(32) srcbmux(
// ###### Hyeonmin Park: Start ######
    .d0 (srcb),
    .d1 (EX_shiftedimm[31:0]),
// ###### Hyeonmin Park: End ######
    .s  (alusrc),
// ###### Hyeonmin Park: Start ######
    .y  (srcb2));
// ###### Hyeonmin Park: End ######

  alu alu(
// ###### Hyeonmin Park: Start ######
    .a       (srca2),
    .b       (srcb2),
// ###### Hyeonmin Park: End ######
    .alucont (alucontrol),
// ###### Hyeonmin Park: Start ######
    .result  (EX_aluout),
// ###### Hyeonmin Park: End ######
    .zero    (zero));
    
// ###### Hyeonmin Park: Start ######
  mux2 #(32) rd1mux(
    .d0 (ID_srca),
    .d1 (result2),
    .s  (fwda[2]),
    .y  (srca));

  mux2 #(32) rd2mux(
    .d0 (ID_writedata),
    .d1 (result2),
    .s  (fwdb[2]),
    .y  (writedata2));

  mux4 #(32) srcamux2(
    .d0 (EX_srca),
    .d1 (MEM_aluout),
    .d2 (result2),
    .d3 (32'b0),
    .s  (fwda[1:0]),
    .y  (srca2));

  mux4 #(32) srcbmux2(
    .d0 (EX_writedata),
    .d1 (MEM_aluout),
    .d2 (result2),
    .d3 (32'b0),
    .s  (fwdb[1:0]),
    .y  (srcb));

  flopenr #(32) ifid(
    .clk   (clk),
    .reset (reset),
    .en    (~hazard[0]),
    .d     ({hazard[1] ? 32'b0 : instr}),
    .q     ({ID_instr}));

  flopr #(239) idex(
    .clk   (clk),
    .reset (reset),
    .d     ({hazard[1] ? 32'b0 : ID_instr, srca, writedata2, signimm, ID_shiftedimm, pcplus4, pc, ID_rs, ID_rt, ID_rd}),
    .q     ({EX_instr, EX_srca, EX_writedata, EX_signimm, EX_shiftedimm, EX_pcplus4, EX_pc, EX_rs, EX_rt, EX_rd}));

  flopr #(101) exmem(
    .clk   (clk),
    .reset (reset),
    .d     ({EX_aluout, srcb, EX_pc, EX_writereg}),
    .q     ({MEM_aluout, MEM_writedata, MEM_pc, MEM_writereg}));

  flopr #(101) memwb(
    .clk   (clk),
    .reset (reset),
    .d     ({readdata, MEM_aluout, MEM_pc, MEM_writereg}),
    .q     ({WB_readdata, WB_aluout, WB_pc, WB_writereg}));
// ###### Hyeonmin Park: End ######

endmodule

// ###### Hyeonmin Park: Start ######
module forwarding(input            MEM_regwrite, WB_regwrite,
                  input      [4:0] ID_rs, ID_rt, EX_rs, EX_rt, MEM_writereg, WB_writereg,
                  output reg [2:0] fwda, fwdb);

  always @(*) begin
    if (ID_rs == 0) fwda[2] = 1'b0;
    else if (WB_regwrite & WB_writereg == ID_rs) fwda[2] = 1'b1;
    else fwda[2] = 1'b0;
    if (ID_rt == 0) fwdb[2] = 1'b0;
    else if (WB_regwrite & WB_writereg == ID_rt) fwdb[2] = 1'b1;
    else fwdb[2] = 1'b0;
    if (EX_rs == 0) fwda[1:0] = 2'b00;
    else if (MEM_regwrite & MEM_writereg == EX_rs) fwda[1:0] = 2'b01;
    else if (WB_regwrite & WB_writereg == EX_rs) fwda[1:0] = 2'b10;
    else fwda[1:0] = 2'b00;
    if (EX_rt == 0) fwdb[1:0] = 2'b00;
    else if (MEM_regwrite & MEM_writereg == EX_rt) fwdb[1:0] = 2'b01;
    else if (WB_regwrite & WB_writereg == EX_rt) fwdb[1:0] = 2'b10;
    else fwdb[1:0] = 2'b00;
  end

endmodule

module hazarddetection(input            reset,
                       input            EX_memread,
                       input      [4:0] ID_rs, ID_rt, EX_rt,
                       input            pcsrc, regtopc, jump,
                       output reg [1:0] hazard);

  always @(*) begin
    if (reset) hazard = 2'b00;
    if (EX_memread & ((EX_rt == ID_rs) | (EX_rt == ID_rt))) hazard[0] = 1'b1;
    else hazard[0] = 1'b0;
    if (pcsrc | regtopc | jump) hazard[1] = 1'b1;
    else hazard[1] = 1'b0;
  end

endmodule
// ###### Hyeonmin Park: End ######
