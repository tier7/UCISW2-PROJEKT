library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.ALL;

entity top_reaction_ps2_demo is
    generic (
        CLK_FREQ_HZ : integer := 100000000;
        WAIT_MS     : integer := 2000
    );
    port (
        clk_p     : in  std_logic;
        clk_n     : in  std_logic;
        rst       : in  std_logic;
        start_btn : in  std_logic;
        ps2_clk   : in  std_logic;
        ps2_data  : in  std_logic;
        led       : out std_logic_vector(3 downto 0)
    );
end top_reaction_ps2_demo;

architecture Behavioral of top_reaction_ps2_demo is

    signal clk_s              : std_logic;

    signal red_on_s           : std_logic;
    signal green_on_s         : std_logic;
    signal test_done_s        : std_logic;
    signal key_pressed_dbg_s  : std_logic;
    signal key_code_dbg_s     : std_logic_vector(7 downto 0);
    signal delay_busy_dbg_s   : std_logic;

    signal timer_enable_dbg_s : std_logic;
    signal timer_clear_dbg_s  : std_logic;
    signal save_result_dbg_s  : std_logic;
    signal inc_trial_dbg_s    : std_logic;
    signal random_start_dbg_s : std_logic;
    signal clear_trials_dbg_s : std_logic;

    signal state_dbg_s        : std_logic_vector(2 downto 0);
    signal trial_count_dbg_s  : unsigned(2 downto 0);
    signal current_time_ms_s  : unsigned(31 downto 0);
    signal saved_time_ms_s    : unsigned(31 downto 0);
    signal avg_time_ms_s      : unsigned(31 downto 0);

begin

    u_ibufds : IBUFDS
        port map (
            I  => clk_p,
            IB => clk_n,
            O  => clk_s
        );

    u_top : entity work.top_reaction_ps2
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            WAIT_MS     => WAIT_MS
        )
        port map (
            clk              => clk_s,
            rst              => rst,
            start_btn        => start_btn,
            ps2_clk          => ps2_clk,
            ps2_data         => ps2_data,

            red_on           => red_on_s,
            green_on         => green_on_s,
            test_done        => test_done_s,

            key_pressed_dbg  => key_pressed_dbg_s,
            key_code_dbg     => key_code_dbg_s,
            delay_busy_dbg   => delay_busy_dbg_s,

            timer_enable_dbg => timer_enable_dbg_s,
            timer_clear_dbg  => timer_clear_dbg_s,
            save_result_dbg  => save_result_dbg_s,
            inc_trial_dbg    => inc_trial_dbg_s,
            random_start_dbg => random_start_dbg_s,
            clear_trials_dbg => clear_trials_dbg_s,

            state_dbg        => state_dbg_s,
            trial_count_dbg  => trial_count_dbg_s,
            current_time_ms  => current_time_ms_s,
            saved_time_ms    => saved_time_ms_s,
            avg_time_ms      => avg_time_ms_s
        );

    led(0) <= red_on_s;
    led(1) <= green_on_s;
    led(2) <= key_pressed_dbg_s;
    led(3) <= test_done_s;

end Behavioral;