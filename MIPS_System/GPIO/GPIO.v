//
//  LEDG :	To turn off, write "0"
//		   	To turn on,  write "1"
//
//  HEX :	To turn off, write "1"
//       	To turn on, write "0" 
//
//         _0_
//       5|_6_|1
//       4|___|2
//          3
//
//  BUTTON : Push --> "0" 
//        	 Release --> "1"
//
//  SW: Down (towards the edge of the board)  --> "0"
//      Up --> "1"
//
`timescale 1ns/1ps

module GPIO(
  input clk,
  input reset,
  input CS_N,
  input RD_N,
  input WR_N,
  input       [11:0] 	Addr,
  input       [31:0]  DataIn,
  input       [2:1]	  BUTTON,
  input       [9:0]   SW,
  output reg  [31:0]  DataOut,
  output              Intr,
  output      [6:0]	  HEX3,
  output      [6:0]	  HEX2,
  output      [6:0]	  HEX1,
  output      [6:0]	  HEX0,
  output      [9:0]	  LEDG);

  reg [31:0] SW_StatusR;
  reg [31:0] BUTTON_StatusR;
  reg [31:0] LEDG_R;
  reg [31:0] HEX0_R;
  reg [31:0] HEX1_R;
  reg [31:0] HEX2_R;
  reg [31:0] HEX3_R;
  
  wire button1_pressed;
  wire button2_pressed;

  wire sw0_flipped;
  wire sw1_flipped;
  wire sw2_flipped;
  wire sw3_flipped;
  wire sw4_flipped;
  wire sw5_flipped;
  wire sw6_flipped;
  wire sw7_flipped;
  wire sw8_flipped;
  wire sw9_flipped;
  
//  Register Details
//  ========================================================
//  BASE:	0xFFFF_2000
//  OFFSET:	0x18	HEX3_R
//			0x14	HEX2_R
//  		0x10   	HEX1_R
//  		0x0C   	HEX0_R
//  		0x08   	LEDG_R
//  		0x04   	SW_StatusR
//  		0x00   	BUTTON_StatusR
//  --------------------------------------------------------
//  LEDG register (32bit) 
//  ZZZZ_ZZZ|LEDG8|_|LEDG7|LEDG6|LEDG5|LEDG4|_
//          |LEDG3|LEDG2|LEDG1|LEDG0|
//  --------------------------------------------------------
//  SW Status register (32bit)
//  ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZ|SW9|SW8|_|SW7|SW6|SW5|SW4|_
//	|SW3|SW2|SW1|SW0|
//  --------------------------------------------------------
//  BUTTON Status register (32bit)
//  ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_Z|button2|button1|Z
//  ========================================================

   pulse_gen  button1 (clk, reset, BUTTON[1], button1_pressed);
   pulse_gen  button2 (clk, reset, BUTTON[2], button2_pressed);
   
   pulse_gen  sw0  (clk, reset, ~SW[0],  sw0_flipped);
   pulse_gen  sw1  (clk, reset, ~SW[1],  sw1_flipped);
   pulse_gen  sw2  (clk, reset, ~SW[2],  sw2_flipped);
   pulse_gen  sw3  (clk, reset, ~SW[3],  sw3_flipped);
   pulse_gen  sw4  (clk, reset, ~SW[4],  sw4_flipped);
   pulse_gen  sw5  (clk, reset, ~SW[5],  sw5_flipped);
   pulse_gen  sw6  (clk, reset, ~SW[6],  sw6_flipped);
   pulse_gen  sw7  (clk, reset, ~SW[7],  sw7_flipped);
   pulse_gen  sw8  (clk, reset, ~SW[8],  sw8_flipped);
   pulse_gen  sw9  (clk, reset, ~SW[9],  sw9_flipped);
   
  //BUTTON Status Register Write
  always @(posedge clk)
  begin
    if(reset)    BUTTON_StatusR  <= 0;
    else
    begin
      //BUTTON             
      if (~CS_N && ~RD_N && Addr[11:0] == 12'h000)
          BUTTON_StatusR  <= 0;
      else
      begin
         if(button1_pressed)   BUTTON_StatusR[1] <= 1'b1;
         if(button2_pressed)   BUTTON_StatusR[2] <= 1'b1;
      end
    end
  end

  //SW Status Register Write
  always @(posedge clk)
  begin
    if(reset)   SW_StatusR   <= 0;
    else
    begin
      if (~CS_N && ~RD_N && Addr[11:0] == 12'h004)
          SW_StatusR  <= 0;
      else
      begin
           //SW
           if(sw0_flipped)         SW_StatusR[0] <= 1'b1;
           if(sw1_flipped)         SW_StatusR[1] <= 1'b1;
           if(sw2_flipped)         SW_StatusR[2] <= 1'b1;
           if(sw3_flipped)         SW_StatusR[3] <= 1'b1;
           if(sw4_flipped)         SW_StatusR[4] <= 1'b1;
           if(sw5_flipped)         SW_StatusR[5] <= 1'b1;
           if(sw6_flipped)         SW_StatusR[6] <= 1'b1;
           if(sw7_flipped)         SW_StatusR[7] <= 1'b1;
           if(sw8_flipped)         SW_StatusR[8] <= 1'b1;
           if(sw9_flipped)         SW_StatusR[9] <= 1'b1;
      end
    end
  end
  
  
  
  // Register Read
  always @(*)
  begin
      if (~CS_N && ~RD_N) 
      begin
        if      (Addr[11:0] == 12'h000) DataOut <= BUTTON_StatusR;
        else if (Addr[11:0] == 12'h004) DataOut <= SW_StatusR;
        else                            DataOut <= 32'b0;
      end
      else                              DataOut <= 32'b0;
  end
  
  // Write Output Register
  always @(posedge clk)
  begin
    if(reset)
    begin                                        
        LEDG_R[9:0]	<= 10'h3FF;
        HEX0_R 		<= 7'b1000000;
        HEX1_R 		<= 7'b1000000;
        HEX2_R 		<= 7'b1000000;
        HEX3_R 		<= 7'b1000000;
    end
  
    else if(~CS_N && ~WR_N) 
    begin
      if       (Addr[11:0] == 12'h008)  LEDG_R  <= DataIn;
      else if  (Addr[11:0] == 12'h00C)  HEX0_R  <= DataIn;		   
		  else if  (Addr[11:0] == 12'h010)  HEX1_R  <= DataIn;
		  else if  (Addr[11:0] == 12'h014)  HEX2_R  <= DataIn;
		  else if  (Addr[11:0] == 12'h018)  HEX3_R  <= DataIn;
    end
  end         
   
	//output 
	assign LEDG[9:0]  = LEDG_R[9:0];
	assign HEX0       = HEX0_R[6:0];
	assign HEX1       = HEX1_R[6:0];
	assign HEX2       = HEX2_R[6:0];
	assign HEX3       = HEX3_R[6:0];
   
	assign Intr = ~((|BUTTON_StatusR[2:0]) || (|SW_StatusR[9:0])); 

endmodule

module pulse_gen(input clk, input reset, input signal, output pulse);

			reg [3:0] c_state;
			reg [3:0] n_state;

			parameter  S0  =  4'b0000;
			parameter  S1  =  4'b0001;
			parameter  S2  =  4'b0010;
			parameter  S3  =  4'b0011;
			parameter  S4  =  4'b0100;
			parameter  S5  =  4'b0101;
			parameter  S6  =  4'b0110;
			parameter  S7  =  4'b0111;
			parameter  S8  =  4'b1000;
			parameter  S9  =  4'b1001;
			parameter  S10 =  4'b1010;
			parameter  S11 =  4'b1011;
			parameter  S12 =  4'b1100;
			parameter  S13 =  4'b1101;
			parameter  S14 =  4'b1110;
			parameter  S15 =  4'b1111;

			always@ (posedge clk) // synchronous resettable flop-flops
			begin
				if(reset)	c_state <= S0;
				else		c_state <= n_state;
			end
			
			always@(*) // Next state logic
			begin
			case(c_state)
			S0 : if(~signal)	n_state <= S1;
					 else		      n_state <= S0;

			S1 : if(~signal) n_state <= S2;
					 else     	  n_state <= S0;

			S2 : if(~signal) n_state <= S3;
					 else     	  n_state <= S0;

			S3 : if(~signal) n_state <= S4;
					 else     	  n_state <= S0;

			S4 : if(~signal) n_state <= S5;
					 else     	  n_state <= S0;

			S5 : if(~signal) n_state <= S6;
					 else     	  n_state <= S0;

			S6 : if(~signal) n_state <= S7;
					 else     	  n_state <= S0;

			S7 : if(~signal) n_state <= S8;
					 else     	  n_state <= S0;

			S8 : if(~signal) n_state <= S9;
					 else     	  n_state <= S0;

			S9 : if(~signal) n_state <= S10;
					 else     	  n_state <= S0;

			S10: if(~signal) n_state <= S11;
					 else     	  n_state <= S0;

			S11: if(~signal) n_state <= S12;
					 else     	  n_state <= S0;

			S12: if(~signal) n_state <= S13;
					 else     	  n_state <= S0;

			S13: if(~signal) n_state <= S14;
					 else     	  n_state <= S0;

			S14: if(~signal) n_state <= S15;
					 else     	  n_state <= S0;

			S15: if(signal)  n_state <= S0;
					 else     	  n_state <= S15;
					   
			default:       		n_state <= S0;
			endcase
      end

			assign  pulse = (c_state == S14);

endmodule
