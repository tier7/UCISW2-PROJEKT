library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top_reaction_test is
end tb_top_reaction_test;

architecture Behavioral of tb_top_reaction_test is

    signal clk              : std_logic := '0';
    signal rst              : std_logic := '0';
    signal start_btn        : std_logic := '0';
    signal key_pressed      : std_logic := '0';
    signal random_done      : std_logic := '0';

    signal red_on           : std_logic;
    signal green_on         : std_logic;
    signal test_done        : std_logic;

    signal timer_enable_dbg : std_logic;
    signal timer_clear_dbg  : std_logic;
    signal save_result_dbg  : std_logic;
    signal inc_trial_dbg    : std_logic;
    signal random_start_dbg : std_logic;
    signal clear_trials_dbg : std_logic;

    signal state_dbg        : std_logic_vector(2 downto 0);
    signal trial_count_dbg  : unsigned(2 downto 0);
    signal current_time_ms  : unsigned(31 downto 0);
    signal saved_time_ms    : unsigned(31 downto 0);
    signal avg_time_ms      : unsigned(31 downto 0);

    constant CLK_PERIOD : time := 1 ms;

begin

    uut: entity work.top_reaction_test
        generic map (
            CLK_FREQ_HZ => 1000
        )
        port map (
            clk              => clk,
            rst              => rst,
            start_btn        => start_btn,
            key_pressed      => key_pressed,
            random_done      => random_done,
            red_on           => red_on,
            green_on         => green_on,
            test_done        => test_done,
            timer_enable_dbg => timer_enable_dbg,
            timer_clear_dbg  => timer_clear_dbg,
            save_result_dbg  => save_result_dbg,
            inc_trial_dbg    => inc_trial_dbg,
            random_start_dbg => random_start_dbg,
            clear_trials_dbg => clear_trials_dbg,
            state_dbg        => state_dbg,
            trial_count_dbg  => trial_count_dbg,
            current_time_ms  => current_time_ms,
            saved_time_ms    => saved_time_ms,
            avg_time_ms      => avg_time_ms
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
        wait for 2 * CLK_PERIOD;
        rst <= '0';

        wait for 2 * CLK_PERIOD;

        start_btn <= '1';
        wait for CLK_PERIOD;
        start_btn <= '0';

        -- próba 1
        wait for 3 * CLK_PERIOD;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for 7 * CLK_PERIOD;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for 3 * CLK_PERIOD;

        -- próba 2
        wait for 4 * CLK_PERIOD;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for 5 * CLK_PERIOD;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for 3 * CLK_PERIOD;

        -- próba 3
        wait for 2 * CLK_PERIOD;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for 9 * CLK_PERIOD;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for 3 * CLK_PERIOD;

        -- próba 4
        wait for 4 * CLK_PERIOD;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for 6 * CLK_PERIOD;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for 3 * CLK_PERIOD;

        -- próba 5
        wait for 3 * CLK_PERIOD;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for 8 * CLK_PERIOD;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for 10 * CLK_PERIOD;
        wait;
    end process;

end Behavioral;