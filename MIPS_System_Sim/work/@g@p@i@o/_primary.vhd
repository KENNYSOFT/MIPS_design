library verilog;
use verilog.vl_types.all;
entity GPIO is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        CS_N            : in     vl_logic;
        RD_N            : in     vl_logic;
        WR_N            : in     vl_logic;
        Addr            : in     vl_logic_vector(11 downto 0);
        DataIn          : in     vl_logic_vector(31 downto 0);
        BUTTON          : in     vl_logic_vector(2 downto 1);
        SW              : in     vl_logic_vector(9 downto 0);
        DataOut         : out    vl_logic_vector(31 downto 0);
        Intr            : out    vl_logic;
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        LEDG            : out    vl_logic_vector(9 downto 0)
    );
end GPIO;
