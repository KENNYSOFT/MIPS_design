library verilog;
use verilog.vl_types.all;
entity pulse_gen is
    generic(
        S0              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        S1              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        S2              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        S3              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        S4              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        S5              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        S6              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        S7              : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        S8              : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0);
        S9              : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1);
        S10             : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi1, Hi0);
        S11             : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi1, Hi1);
        S12             : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi0, Hi0);
        S13             : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi0, Hi1);
        S14             : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi1, Hi0);
        S15             : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \signal\        : in     vl_logic;
        pulse           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of S0 : constant is 1;
    attribute mti_svvh_generic_type of S1 : constant is 1;
    attribute mti_svvh_generic_type of S2 : constant is 1;
    attribute mti_svvh_generic_type of S3 : constant is 1;
    attribute mti_svvh_generic_type of S4 : constant is 1;
    attribute mti_svvh_generic_type of S5 : constant is 1;
    attribute mti_svvh_generic_type of S6 : constant is 1;
    attribute mti_svvh_generic_type of S7 : constant is 1;
    attribute mti_svvh_generic_type of S8 : constant is 1;
    attribute mti_svvh_generic_type of S9 : constant is 1;
    attribute mti_svvh_generic_type of S10 : constant is 1;
    attribute mti_svvh_generic_type of S11 : constant is 1;
    attribute mti_svvh_generic_type of S12 : constant is 1;
    attribute mti_svvh_generic_type of S13 : constant is 1;
    attribute mti_svvh_generic_type of S14 : constant is 1;
    attribute mti_svvh_generic_type of S15 : constant is 1;
end pulse_gen;
