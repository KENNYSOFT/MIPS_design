library verilog;
use verilog.vl_types.all;
entity MIPS_System is
    port(
        CLOCK_50        : in     vl_logic;
        BUTTON          : in     vl_logic_vector(2 downto 0);
        SW              : in     vl_logic_vector(9 downto 0);
        HEX3_D          : out    vl_logic_vector(6 downto 0);
        HEX2_D          : out    vl_logic_vector(6 downto 0);
        HEX1_D          : out    vl_logic_vector(6 downto 0);
        HEX0_D          : out    vl_logic_vector(6 downto 0);
        LEDG            : out    vl_logic_vector(9 downto 0)
    );
end MIPS_System;
