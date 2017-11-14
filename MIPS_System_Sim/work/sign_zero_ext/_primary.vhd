library verilog;
use verilog.vl_types.all;
entity sign_zero_ext is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        signext         : in     vl_logic;
        y               : out    vl_logic_vector(31 downto 0)
    );
end sign_zero_ext;
