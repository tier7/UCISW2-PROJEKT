library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_timer_ms is
end tb_timer_ms;

architecture Behavioral of tb_timer_ms is

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal enable   : std_logic := '0';
    signal clear    : std_logic := '0';
    signal ms_tick  : std_logic;
    signal ms_count : unsigned(31 downto 0);

    constant CLK_PERIOD : time := 1 ms;

begin

    uut: entity work.timer_ms
        generic map (
            CLK_FREQ_HZ => 1000
        )
        port map (
            clk      => clk,
            rst      => rst,
            enable   => enable,
            clear    => clear,
            ms_tick  => ms_tick,
            ms_count => ms_count
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stim_proc : process
    begin
        rst <= '1';
        wait for 2 ms;
        rst <= '0';

        enable <= '1';
        wait for 5 ms;

        enable <= '0';
        wait for 3 ms;

        enable <= '1';
        wait for 2 ms;

        clear <= '1';
        wait for 1 ms;
        clear <= '0';

        enable <= '1';
        wait for 3 ms;

        wait;
    end process;

end Behavioral;