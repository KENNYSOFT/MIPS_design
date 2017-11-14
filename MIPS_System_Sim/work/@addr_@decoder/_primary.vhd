library verilog;
use verilog.vl_types.all;
entity Addr_Decoder is
    port(
        Addr            : in     vl_logic_vector(31 downto 0);
        CS_MEM_N        : out    vl_logic;
        CS_TC_N         : out    vl_logic;
        CS_UART_N       : out    vl_logic;
        CS_GPIO_N       : out    vl_logic
    );
end Addr_Decoder;
