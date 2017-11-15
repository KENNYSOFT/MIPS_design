library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        op              : in     vl_logic_vector(5 downto 0);
        funct           : in     vl_logic_vector(5 downto 0);
        zero            : in     vl_logic;
        hazard          : in     vl_logic;
        signext         : out    vl_logic;
        shiftl16        : out    vl_logic;
        memtoreg        : out    vl_logic;
        memread         : out    vl_logic;
        memwrite        : out    vl_logic;
        pcsrc           : out    vl_logic;
        alusrc          : out    vl_logic;
        regdst          : out    vl_logic;
        regwrite        : out    vl_logic;
        jump            : out    vl_logic;
        pctoreg         : out    vl_logic;
        regtopc         : out    vl_logic;
        alucontrol      : out    vl_logic_vector(3 downto 0);
        EX_memread      : out    vl_logic;
        MEM_regwrite    : out    vl_logic;
        WB_regwrite     : out    vl_logic
    );
end controller;
