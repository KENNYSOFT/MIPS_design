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
  wire        hazard;
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
                  input        hazard,
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

  wire [1:0] aluop;
  wire       branch;
// ###### Hyeonmin Park: Start ######
  wire        branchn;
  wire        ID_regdst;
  wire [1:0]  ID_aluop;
  wire        ID_alusrc;
  wire        ID_branch;
  wire        ID_branchn;
  wire        ID_memread;
  wire        ID_memwrite;
  wire        ID_memtoreg;
  wire        ID_pctoreg;
  wire        ID_regwrite;
  wire [10:0] ID_Control;
  wire [10:0] ID_Control2;
  wire        EX_regdst;
  wire [1:0]  EX_aluop;
  wire        EX_alusrc;
  wire [3:0]  EX_MEM;
  wire [2:0]  EX_WB;
  wire [5:0]  EX_funct;
  wire        MEM_branch;
  wire        MEM_branchn;
  wire        MEM_memread;
  wire        MEM_memwrite;
  wire [2:0]  MEM_WB;
  wire        MEM_zero;
  wire        WB_memtoreg;
  wire        WB_pctoreg;

  assign ID_Control = {ID_regdst, ID_aluop, ID_alusrc, ID_branch, ID_branchn, ID_memread, ID_memwrite, ID_memtoreg, ID_pctoreg, ID_regwrite};
  assign EX_memread = EX_MEM[1];
  assign MEM_regwrite = MEM_WB[0];
  assign {regdst, aluop, alusrc, memread, memwrite, memtoreg, pctoreg, regwrite} = {EX_regdst, EX_aluop, EX_alusrc, MEM_memread, MEM_memwrite, WB_memtoreg, WB_pctoreg, WB_regwrite};
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
// ###### Hyeonmin Park: End ######
    .jump     (jump),
// ###### Hyeonmin Park: Start ######
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
  mux2 #(11) hazardmux(
    .d0 (ID_Control),
    .d1 (11'b0),
    .s  (hazard),
    .y  (ID_Control2));

  flopr #(17) idex(
    .clk   (clk),
    .reset (reset),
    .d     ({ID_Control2, funct}),
    .q     ({EX_regdst, EX_aluop, EX_alusrc, EX_MEM, EX_WB, EX_funct}));

  flopr #(8) exmem(
    .clk   (clk),
    .reset (reset),
    .d     ({EX_MEM, EX_WB, zero}),
    .q     ({MEM_branch, MEM_branchn, MEM_memread, MEM_memwrite, MEM_WB, MEM_zero}));

  flopr #(3) memwb(
    .clk   (clk),
    .reset (reset),
    .d     ({MEM_WB}),
    .q     ({WB_memtoreg, WB_pctoreg, WB_regwrite}));

  assign pcsrc = (MEM_branch & MEM_zero) | (MEM_branchn & MEM_zero);
  assign regtopc = (op == 6'b000000 && funct == 6'b001000);
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
// ###### Hyeonmin Park: End ######
               output [1:0] aluop);

// ###### Hyeonmin Park: Start ######
  reg [13:0] controls;
// ###### Hyeonmin Park: End ######

// ###### Hyeonmin Park: Start ######
  assign {signext, shiftl16, regwrite, regdst, alusrc, branch, branchn, memread, memwrite,
          memtoreg, jump, pctoreg, aluop} = controls;
// ###### Hyeonmin Park: End ######

  always @(*)
    case(op)
// ###### Hyeonmin Park: Start ######
      6'b000000: controls <= #`mydelay 14'b00110000000011; // Rtype
      6'b100011: controls <= #`mydelay 14'b10101001010000; // LW
      6'b101011: controls <= #`mydelay 14'b10001000100000; // SW
      6'b000100: controls <= #`mydelay 14'b10000100000001; // BEQ
      6'b000101: controls <= #`mydelay 14'b10000010000001; // BNE
      6'b001000, 
      6'b001001: controls <= #`mydelay 14'b10101000000000; // ADDI, ADDIU: only difference is exception
      6'b001101: controls <= #`mydelay 14'b00101000000010; // ORI
      6'b001111: controls <= #`mydelay 14'b01101000000000; // LUI
      6'b000010: controls <= #`mydelay 14'b00000000001000; // J
      6'b000011: controls <= #`mydelay 14'b00100000001100; // JAL
      default:   controls <= #`mydelay 14'bxxxxxxxxxxxxxx; // ???
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
                input  [2:0]  fwda, fwdb,
                input         hazard,
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
// ###### Hyeonmin Park: Start ######
  wire [31:0] srca2, srcb2;
// ###### Hyeonmin Park: End ######
  wire [31:0] result;
// ###### Hyeonmin Park: Start ######
  wire [31:0] result2;
// ###### Hyeonmin Park: End ######
  wire        shift;
// ###### Hyeonmin Park: Start ######
  wire [31:0] writedata2;
  wire [31:0] ID_srca;
  wire [31:0] ID_writedata;
  wire [31:0] ID_shiftedimm;
  wire [4:0]  ID_rd;
  wire [31:0] EX_srca;
  wire [31:0] EX_writedata;
  wire [31:0] EX_shiftedimm;
  wire [31:0] EX_aluout;
  wire [4:0]  EX_writereg;
  wire [4:0]  EX_rd;
  wire [31:0] MEM_aluout;
  wire [31:0] MEM_writedata;
  wire [31:0] WB_readdata;
  wire [31:0] WB_aluout;

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
    .en    (~hazard),
// ###### Hyeonmin Park: End ######
    .d     (pcnext),
    .q     (pc));

  adder pcadd1(
    .a (pc),
    .b (32'b100),
    .y (pcplus4));

  sl2 immsh(
// ###### Hyeonmin Park: Start ######
    .a (EX_signimm),
    .y (EX_signimmsh));
// ###### Hyeonmin Park: End ######
				 
  adder pcadd2(
    .a (pcplus4),
// ###### Hyeonmin Park: Start ######
    .b (EX_signimmsh),
    .y (EX_pcbranch));
// ###### Hyeonmin Park: End ######

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
    .d1   ({pcplus4[31:28], ID_instr[25:0], 2'b00}),
// ###### Hyeonmin Park: End ######
    .s    (jump),
    .y    (pcnext));

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
    .d1 (pcplus4),
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
    .en    (~hazard),
    .d     ({instr}),
    .q     ({ID_instr}));

  flopr #(111) idex(
    .clk   (clk),
    .reset (reset),
    .d     ({srca, writedata2, ID_shiftedimm, ID_rs, ID_rt, ID_rd}),
    .q     ({EX_srca, EX_writedata, EX_shiftedimm, EX_rs, EX_rt, EX_rd}));

  flopr #(69) exmem(
    .clk   (clk),
    .reset (reset),
    .d     ({EX_aluout, srcb, EX_writereg}),
    .q     ({MEM_aluout, MEM_writedata, MEM_writereg}));

  flopr #(69) memwb(
    .clk   (clk),
    .reset (reset),
    .d     ({readdata, MEM_aluout, MEM_writereg}),
    .q     ({WB_readdata, WB_aluout, WB_writereg}));
// ###### Hyeonmin Park: End ######

endmodule

// ###### Hyeonmin Park: Start ######
module forwarding(input            MEM_regwrite, WB_regwrite,
                  input      [4:0] ID_rs, ID_rt, EX_rs, EX_rt, MEM_writereg, WB_writereg,
                  output reg [2:0] fwda, fwdb);

  always @(*) begin
    if (WB_regwrite & WB_writereg == ID_rs) fwda[2] = 1'b1;
    else fwda[2] = 1'b0;
    if (WB_regwrite & WB_writereg == ID_rt) fwdb[2] = 1'b1;
    else fwdb[2] = 1'b0;
    if (MEM_regwrite & MEM_writereg == EX_rs) fwda[1:0] = 2'b01;
    else if (WB_regwrite & WB_writereg == EX_rs) fwda[1:0] = 2'b10;
    else fwda[1:0] = 2'b00;
    if (MEM_regwrite & MEM_writereg == EX_rt) fwdb[1:0] = 2'b01;
    else if (WB_regwrite & WB_writereg == EX_rt) fwdb[1:0] = 2'b10;
    else fwdb[1:0] = 2'b00;
  end

endmodule

module hazarddetection(input            reset,
                       input            EX_memread,
                       input      [4:0] ID_rs, ID_rt, EX_rt,
                       output reg       hazard);

  always @(*) begin
    if (reset) hazard = 0;
    else if (EX_memread & ((EX_rt == ID_rs) | (EX_rt == ID_rt))) hazard = 1;
    else hazard = 0;
  end

endmodule
// ###### Hyeonmin Park: End ######
