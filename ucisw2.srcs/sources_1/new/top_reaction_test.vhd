library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_reaction_test is
    generic (
        CLK_FREQ_HZ : integer := 100000000
    );
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        start_btn        : in  std_logic;
        key_pressed      : in  std_logic;
        random_done      : in  std_logic;

        red_on           : out std_logic;
        green_on         : out std_logic;
        test_done        : out std_logic;

        timer_enable_dbg : out std_logic;
        timer_clear_dbg  : out std_logic;
        save_result_dbg  : out std_logic;
        inc_trial_dbg    : out std_logic;
        random_start_dbg : out std_logic;
        clear_trials_dbg : out std_logic;

        state_dbg        : out std_logic_vector(2 downto 0);
        trial_count_dbg  : out unsigned(2 downto 0);
        current_time_ms  : out unsigned(31 downto 0);
        saved_time_ms    : out unsigned(31 downto 0);
        avg_time_ms      : out unsigned(31 downto 0)
    );
end top_reaction_test;

architecture Behavioral of top_reaction_test is

    signal timer_enable_s : std_logic;
    signal timer_clear_s  : std_logic;
    signal save_result_s  : std_logic;
    signal inc_trial_s    : std_logic;
    signal random_start_s : std_logic;
    signal clear_trials_s : std_logic;

    signal trial_count_s  : unsigned(2 downto 0)  := (others => '0');
    signal ms_count_s     : unsigned(31 downto 0) := (others => '0');
    signal saved_time_s   : unsigned(31 downto 0) := (others => '0');

    signal result0_s      : unsigned(31 downto 0) := (others => '0');
    signal result1_s      : unsigned(31 downto 0) := (others => '0');
    signal result2_s      : unsigned(31 downto 0) := (others => '0');
    signal result3_s      : unsigned(31 downto 0) := (others => '0');
    signal result4_s      : unsigned(31 downto 0) := (others => '0');

    signal ms_tick_s      : std_logic;

    signal sum_time_i     : integer := 0;
    signal avg_time_i     : integer := 0;

begin

    u_fsm : entity work.reaction_fsm
        port map (
            clk          => clk,
            rst          => rst,
            start_btn    => start_btn,
            key_pressed  => key_pressed,
            random_done  => random_done,
            trial_count  => trial_count_s,
            red_on       => red_on,
            green_on     => green_on,
            timer_enable => timer_enable_s,
            timer_clear  => timer_clear_s,
            save_result  => save_result_s,
            inc_trial    => inc_trial_s,
            random_start => random_start_s,
            clear_trials => clear_trials_s,
            test_done    => test_done,
            state_dbg    => state_dbg
        );

    u_timer : entity work.timer_ms
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ
        )
        port map (
            clk      => clk,
            rst      => rst,
            enable   => timer_enable_s,
            clear    => timer_clear_s,
            ms_tick  => ms_tick_s,
            ms_count => ms_count_s
        );

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or clear_trials_s = '1' then
                trial_count_s <= (others => '0');
            elsif inc_trial_s = '1' then
                trial_count_s <= trial_count_s + 1;
            end if;
        end if;
    end process;

    process(clk)
        variable current_time_i : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' or clear_trials_s = '1' then
                saved_time_s <= (others => '0');

                result0_s <= (others => '0');
                result1_s <= (others => '0');
                result2_s <= (others => '0');
                result3_s <= (others => '0');
                result4_s <= (others => '0');

                sum_time_i <= 0;
                avg_time_i <= 0;

            elsif save_result_s = '1' then
                current_time_i := to_integer(ms_count_s);
                saved_time_s   <= ms_count_s;

                case trial_count_s is
                    when "000" =>
                        result0_s  <= ms_count_s;
                        sum_time_i <= current_time_i;

                    when "001" =>
                        result1_s  <= ms_count_s;
                        sum_time_i <= sum_time_i + current_time_i;

                    when "010" =>
                        result2_s  <= ms_count_s;
                        sum_time_i <= sum_time_i + current_time_i;

                    when "011" =>
                        result3_s  <= ms_count_s;
                        sum_time_i <= sum_time_i + current_time_i;

                    when "100" =>
                        result4_s  <= ms_count_s;
                        sum_time_i <= sum_time_i + current_time_i;
                        avg_time_i <= (sum_time_i + current_time_i) / 5;

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    timer_enable_dbg <= timer_enable_s;
    timer_clear_dbg  <= timer_clear_s;
    save_result_dbg  <= save_result_s;
    inc_trial_dbg    <= inc_trial_s;
    random_start_dbg <= random_start_s;
    clear_trials_dbg <= clear_trials_s;

    trial_count_dbg <= trial_count_s;
    current_time_ms <= ms_count_s;
    saved_time_ms   <= saved_time_s;
    avg_time_ms     <= to_unsigned(avg_time_i, 32);

end Behavioral;