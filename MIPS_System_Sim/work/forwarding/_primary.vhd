library verilog;
use verilog.vl_types.all;
entity forwarding is
    port(
        MEM_regwrite    : in     vl_logic;
        WB_regwrite     : in     vl_logic;
        ID_rs           : in     vl_logic_vector(4 downto 0);
        ID_rt           : in     vl_logic_vector(4 downto 0);
        EX_rs           : in     vl_logic_vector(4 downto 0);
        EX_rt           : in     vl_logic_vector(4 downto 0);
        MEM_writereg    : in     vl_logic_vector(4 downto 0);
        WB_writereg     : in     vl_logic_vector(4 downto 0);
        fwda            : out    vl_logic_vector(2 downto 0);
        fwdb            : out    vl_logic_vector(2 downto 0)
    );
end forwarding;
