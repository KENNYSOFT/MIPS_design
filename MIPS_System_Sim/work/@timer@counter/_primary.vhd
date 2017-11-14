library verilog;
use verilog.vl_types.all;
entity TimerCounter is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        CS_N            : in     vl_logic;
        RD_N            : in     vl_logic;
        WR_N            : in     vl_logic;
        Addr            : in     vl_logic_vector(11 downto 0);
        DataIn          : in     vl_logic_vector(31 downto 0);
        DataOut         : out    vl_logic_vector(31 downto 0);
        Intr            : out    vl_logic
    );
end TimerCounter;
