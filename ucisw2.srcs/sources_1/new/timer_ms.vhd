library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_ms is
    generic (
        CLK_FREQ_HZ : integer := 100000000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        enable   : in  std_logic;
        clear    : in  std_logic;
        ms_tick  : out std_logic;
        ms_count : out unsigned(31 downto 0)
    );
end timer_ms;

architecture Behavioral of timer_ms is
    constant PRESCALER_MAX : integer := CLK_FREQ_HZ / 1000 - 1;

    signal prescaler_cnt : integer range 0 to PRESCALER_MAX := 0;
    signal ms_counter    : unsigned(31 downto 0) := (others => '0');
    signal tick_reg      : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            tick_reg <= '0';

            if rst = '1' then
                prescaler_cnt <= 0;
                ms_counter    <= (others => '0');

            elsif clear = '1' then
                prescaler_cnt <= 0;
                ms_counter    <= (others => '0');

            elsif enable = '1' then
                if prescaler_cnt = PRESCALER_MAX then
                    prescaler_cnt <= 0;
                    ms_counter    <= ms_counter + 1;
                    tick_reg      <= '1';
                else
                    prescaler_cnt <= prescaler_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    ms_tick  <= tick_reg;
    ms_count <= ms_counter;

end Behavioral;