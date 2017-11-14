`timescale 1ns/1ns

module MIPS_System_tb();

  reg           clk;
  reg           reset;
  wire   [6:0]  hex3;
  wire   [6:0]  hex2;
  wire   [6:0]  hex1;
  wire   [6:0]  hex0;
  wire   [9:0]  ledg;

  // instantiate device to be tested
  MIPS_System    MIPS_System_dut (
        .CLOCK_50  (clk),
        .BUTTON    ({2'b00,reset}),
        .SW        (10'b0),
        .HEX3_D    (hex3),
        .HEX2_D    (hex2),
        .HEX1_D    (hex1),
        .HEX0_D    (hex0),
        .LEDG      (ledg));

  // Reset
  initial
  begin
    reset <= 0; 
		#530; 
		reset <= 1;
  end

  // Clock 
  initial
  begin
    clk <= 0; 
		forever #10 clk <= ~clk;
  end  
      
endmodule
