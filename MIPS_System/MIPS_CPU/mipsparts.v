`timescale 1ns/1ps
`define mydelay 1

//------------------------------------------------
// mipsparts.v
// David_Harris@hmc.edu 23 October 2005
// Components used in MIPS processor
//------------------------------------------------

`define REGFILE_FF
`ifdef REGFILE_FF

module regfile(input             clk, 
               input             we, 
               input      [4:0]  ra1, ra2, wa, 
               input      [31:0] wd, 
               output reg [31:0] rd1, rd2);

	reg [31:0] R1;
	reg [31:0] R2;
	reg [31:0] R3;
	reg [31:0] R4;
	reg [31:0] R5;
	reg [31:0] R6;
	reg [31:0] R7;
	reg [31:0] R8;
	reg [31:0] R9;
	reg [31:0] R10;
	reg [31:0] R11;
	reg [31:0] R12;
	reg [31:0] R13;
	reg [31:0] R14;
	reg [31:0] R15;
	reg [31:0] R16;
	reg [31:0] R17;
	reg [31:0] R18;
	reg [31:0] R19;
	reg [31:0] R20;
	reg [31:0] R21;
	reg [31:0] R22;
	reg [31:0] R23;
	reg [31:0] R24;
	reg [31:0] R25;
	reg [31:0] R26;
	reg [31:0] R27;
	reg [31:0] R28;
	reg [31:0] R29;
	reg [31:0] R30;
	reg [31:0] R31;

	always @(posedge clk)
	begin
  	 if (we) 
	 begin
   		case (wa[4:0])
   		5'd0:   ;
   		5'd1:   R1  <= wd;
   		5'd2:   R2  <= wd;
   		5'd3:   R3  <= wd;
   		5'd4:   R4  <= wd;
   		5'd5:   R5  <= wd;
   		5'd6:   R6  <= wd;
   		5'd7:   R7  <= wd;
   		5'd8:   R8  <= wd;
   		5'd9:   R9  <= wd;
   		5'd10:  R10 <= wd;
   		5'd11:  R11 <= wd;
   		5'd12:  R12 <= wd;
   		5'd13:  R13 <= wd;
   		5'd14:  R14 <= wd;
   		5'd15:  R15 <= wd;
   		5'd16:  R16 <= wd;
   		5'd17:  R17 <= wd;
   		5'd18:  R18 <= wd;
   		5'd19:  R19 <= wd;
   		5'd20:  R20 <= wd;
   		5'd21:  R21 <= wd;
   		5'd22:  R22 <= wd;
   		5'd23:  R23 <= wd;
   		5'd24:  R24 <= wd;
   		5'd25:  R25 <= wd;
   		5'd26:  R26 <= wd;
   		5'd27:  R27 <= wd;
   		5'd28:  R28 <= wd;
   		5'd29:  R29 <= wd;
   		5'd30:  R30 <= wd;
   		5'd31:  R31 <= wd;
   		endcase
     end
	end

	always @(*)
	begin
		case (ra2[4:0])
		5'd0:   rd2 = 32'b0;
		5'd1:   rd2 = R1;
		5'd2:   rd2 = R2;
		5'd3:   rd2 = R3;
		5'd4:   rd2 = R4;
		5'd5:   rd2 = R5;
		5'd6:   rd2 = R6;
		5'd7:   rd2 = R7;
		5'd8:   rd2 = R8;
		5'd9:   rd2 = R9;
		5'd10:  rd2 = R10;
		5'd11:  rd2 = R11;
		5'd12:  rd2 = R12;
		5'd13:  rd2 = R13;
		5'd14:  rd2 = R14;
		5'd15:  rd2 = R15;
		5'd16:  rd2 = R16;
		5'd17:  rd2 = R17;
		5'd18:  rd2 = R18;
		5'd19:  rd2 = R19;
		5'd20:  rd2 = R20;
		5'd21:  rd2 = R21;
		5'd22:  rd2 = R22;
		5'd23:  rd2 = R23;
		5'd24:  rd2 = R24;
		5'd25:  rd2 = R25;
		5'd26:  rd2 = R26;
		5'd27:  rd2 = R27;
		5'd28:  rd2 = R28;
		5'd29:  rd2 = R29;
		5'd30:  rd2 = R30;
		5'd31:  rd2 = R31;
		endcase
	end

	always @(*)
	begin
		case (ra1[4:0])
		5'd0:   rd1 = 32'b0;
		5'd1:   rd1 = R1;
		5'd2:   rd1 = R2;
		5'd3:   rd1 = R3;
		5'd4:   rd1 = R4;
		5'd5:   rd1 = R5;
		5'd6:   rd1 = R6;
		5'd7:   rd1 = R7;
		5'd8:   rd1 = R8;
		5'd9:   rd1 = R9;
		5'd10:  rd1 = R10;
		5'd11:  rd1 = R11;
		5'd12:  rd1 = R12;
		5'd13:  rd1 = R13;
		5'd14:  rd1 = R14;
		5'd15:  rd1 = R15;
		5'd16:  rd1 = R16;
		5'd17:  rd1 = R17;
		5'd18:  rd1 = R18;
		5'd19:  rd1 = R19;
		5'd20:  rd1 = R20;
		5'd21:  rd1 = R21;
		5'd22:  rd1 = R22;
		5'd23:  rd1 = R23;
		5'd24:  rd1 = R24;
		5'd25:  rd1 = R25;
		5'd26:  rd1 = R26;
		5'd27:  rd1 = R27;
		5'd28:  rd1 = R28;
		5'd29:  rd1 = R29;
		5'd30:  rd1 = R30;
		5'd31:  rd1 = R31;
		endcase
	end

endmodule

`else

module regfile(input         clk, 
               input         we, 
               input  [4:0]  ra1, ra2, wa, 
               input  [31:0] wd, 
               output [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we) rf[wa] <= #`mydelay wd;	

  assign #`mydelay rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign #`mydelay rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

`endif


module alu(input      [31:0] a, b, 
           input      [3:0]  alucont, 
           output reg [31:0] result,
           output            zero);

  wire [31:0] b2, slt;
// ###### Hyeonmin Park: Start ######
  wire [32:0] sum;
  wire [31:0] sltu;
// ###### Hyeonmin Park: End ######

  assign b2 = alucont[2] ? ~b:b; 
  assign sum = a + b2 + alucont[2];
  assign slt = sum[31];
// ###### Hyeonmin Park: Start ######
  assign sltu = !sum[32];
// ###### Hyeonmin Park: End ######

  always@(*)
    case({alucont[3],alucont[1:0]})
      3'b000: result <= #`mydelay a & b;
      3'b001: result <= #`mydelay a | b;
      3'b010: result <= #`mydelay sum;
      3'b011: result <= #`mydelay slt;
// ###### Hyeonmin Park: Start ######		
		3'b111: result <= #`mydelay sltu;
// ###### Hyeonmin Park: End ######
    endcase

  assign #`mydelay zero = (result == 32'b0);

endmodule


module adder(input [31:0] a, b,
             output [31:0] y);

  assign #`mydelay y = a + b;
endmodule



module sl2(input  [31:0] a,
           output [31:0] y);

  // shift left by 2
  assign #`mydelay y = {a[29:0], 2'b00};
endmodule



module sign_zero_ext(input      [15:0] a,
                     input             signext,
                     output reg [31:0] y);
              
   always @(*)
	begin
	   if (signext)  y <= {{16{a[15]}}, a[15:0]};
	   else          y <= {16'b0, a[15:0]};
	end

endmodule



module shift_left_16(input      [31:0] a,
		               input         shiftl16,
                     output reg [31:0] y);

   always @(*)
	begin
	   if (shiftl16) y = {a[15:0],16'b0};
	   else          y = a[31:0];
	end
              
endmodule



module flopr #(parameter WIDTH = 8)
              (input                  clk, reset,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= #`mydelay 0;
    else       q <= #`mydelay d;

endmodule



module flopenr #(parameter WIDTH = 8)
                (input                  clk, reset,
                 input                  en,
                 input      [WIDTH-1:0] d, 
                 output reg [WIDTH-1:0] q);
 
  always @(posedge clk, posedge reset)
    if      (reset) q <= #`mydelay 0;
    else if (en)    q <= #`mydelay d;

endmodule



module mux2 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);

  assign #`mydelay y = s ? d1 : d0; 

endmodule



// ###### Hyeonmin Park: Start ######
module mux4 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, d2, d3, 
              input  [1:0]       s, 
              output [WIDTH-1:0] y);

  assign #`mydelay y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0); 

endmodule
// ###### Hyeonmin Park: End ######
