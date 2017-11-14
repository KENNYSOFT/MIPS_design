library verilog;
use verilog.vl_types.all;
entity mips is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0);
        instr           : in     vl_logic_vector(31 downto 0);
        memwrite        : out    vl_logic;
        memaddr         : out    vl_logic_vector(31 downto 0);
        memwritedata    : out    vl_logic_vector(31 downto 0);
        memreaddata     : in     vl_logic_vector(31 downto 0)
    );
end mips;
