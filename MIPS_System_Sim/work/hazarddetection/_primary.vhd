library verilog;
use verilog.vl_types.all;
entity hazarddetection is
    port(
        reset           : in     vl_logic;
        EX_memread      : in     vl_logic;
        ID_rs           : in     vl_logic_vector(4 downto 0);
        ID_rt           : in     vl_logic_vector(4 downto 0);
        EX_rt           : in     vl_logic_vector(4 downto 0);
        hazard          : out    vl_logic
    );
end hazarddetection;
