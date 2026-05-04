library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_reaction_ps2 is
    generic (
        CLK_FREQ_HZ : integer := 100000000;
        WAIT_MS     : integer := 2000
    );
    port (
        clk                  : in  std_logic;
        rst                  : in  std_logic;
        start_btn            : in  std_logic;
        ps2_clk              : in  std_logic;
        ps2_data             : in  std_logic;

        red_on               : out std_logic;
        green_on             : out std_logic;
        test_done            : out std_logic;

        key_pressed_dbg      : out std_logic;
        key_code_dbg         : out std_logic_vector(7 downto 0);
        delay_busy_dbg       : out std_logic;

        timer_enable_dbg     : out std_logic;
        timer_clear_dbg      : out std_logic;
        save_result_dbg      : out std_logic;
        inc_trial_dbg        : out std_logic;
        random_start_dbg     : out std_logic;
        clear_trials_dbg     : out std_logic;
        invalid_reaction_dbg : out std_logic;

        state_dbg            : out std_logic_vector(2 downto 0);
        trial_count_dbg      : out unsigned(2 downto 0);
        current_time_ms      : out unsigned(31 downto 0);
        saved_time_ms        : out unsigned(31 downto 0);
        avg_time_ms          : out unsigned(31 downto 0)
    );
end top_reaction_ps2;

architecture Behavioral of top_reaction_ps2 is

    signal key_pressed_s  : std_logic;
    signal key_ready_s    : std_logic;
    signal random_done_s  : std_logic;
    signal delay_busy_s   : std_logic;

    signal random_start_s : std_logic;

begin

    u_key : entity work.ps2_keypress
        port map (
            clk           => clk,
            rst           => rst,
            ps2_clk       => ps2_clk,
            ps2_data      => ps2_data,
            key_pressed   => key_pressed_s,
            key_code_dbg  => key_code_dbg,
            key_ready_dbg => key_ready_s
        );

    u_delay : entity work.random_delay
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            MIN_MS      => 1000,
            MAX_MS      => 3000
        )
        port map (
            clk        => clk,
            rst        => rst,
            start      => random_start_s,
            seed_event => key_pressed_s,
            done_pulse => random_done_s,
            busy       => delay_busy_s
        );

    u_core : entity work.top_reaction_test
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ
        )
        port map (
            clk                  => clk,
            rst                  => rst,
            start_btn            => start_btn,
            key_pressed          => key_pressed_s,
            random_done          => random_done_s,

            red_on               => red_on,
            green_on             => green_on,
            test_done            => test_done,

            timer_enable_dbg     => timer_enable_dbg,
            timer_clear_dbg      => timer_clear_dbg,
            save_result_dbg      => save_result_dbg,
            inc_trial_dbg        => inc_trial_dbg,
            random_start_dbg     => random_start_s,
            clear_trials_dbg     => clear_trials_dbg,
            invalid_reaction_dbg => invalid_reaction_dbg,

            state_dbg            => state_dbg,
            trial_count_dbg      => trial_count_dbg,
            current_time_ms      => current_time_ms,
            saved_time_ms        => saved_time_ms,
            avg_time_ms          => avg_time_ms
        );

    key_pressed_dbg  <= key_ready_s;
    delay_busy_dbg   <= delay_busy_s;
    random_start_dbg <= random_start_s;

end Behavioral;