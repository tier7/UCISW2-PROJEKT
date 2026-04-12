library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_reaction_fsm is
end tb_reaction_fsm;

architecture Behavioral of tb_reaction_fsm is

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal start_btn    : std_logic := '0';
    signal key_pressed  : std_logic := '0';
    signal random_done  : std_logic := '0';
    signal trial_count  : unsigned(2 downto 0) := (others => '0');

    signal red_on       : std_logic;
    signal green_on     : std_logic;
    signal timer_enable : std_logic;
    signal timer_clear  : std_logic;
    signal save_result  : std_logic;
    signal inc_trial    : std_logic;
    signal random_start : std_logic;
    signal clear_trials : std_logic;
    signal test_done    : std_logic;
    signal state_dbg    : std_logic_vector(2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: entity work.reaction_fsm
    port map (
        clk          => clk,
        rst          => rst,
        start_btn    => start_btn,
        key_pressed  => key_pressed,
        random_done  => random_done,
        trial_count  => trial_count,
        red_on       => red_on,
        green_on     => green_on,
        timer_enable => timer_enable,
        timer_clear  => timer_clear,
        save_result  => save_result,
        inc_trial    => inc_trial,
        random_start => random_start,
        clear_trials => clear_trials,
        test_done    => test_done,
        state_dbg    => state_dbg
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

    trial_counter_model : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or clear_trials = '1' then
                trial_count <= (others => '0');
            elsif inc_trial = '1' then
                trial_count <= trial_count + 1;
            end if;
        end if;
    end process;

    stim_proc : process
    begin
        -- reset
        rst <= '1';
        wait for CLK_PERIOD * 3;
        rst <= '0';

        wait for CLK_PERIOD * 2;

        -- start
        start_btn <= '1';
        wait for CLK_PERIOD;
        start_btn <= '0';

        -- proba 1
        wait for CLK_PERIOD * 4;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for CLK_PERIOD * 2;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for CLK_PERIOD * 3;

        -- proba 2
        wait for CLK_PERIOD * 4;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for CLK_PERIOD * 3;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for CLK_PERIOD * 3;

        -- proba 3
        wait for CLK_PERIOD * 4;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for CLK_PERIOD * 4;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for CLK_PERIOD * 3;

        -- proba 4
        wait for CLK_PERIOD * 4;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for CLK_PERIOD * 5;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for CLK_PERIOD * 3;

        -- proba 5
        wait for CLK_PERIOD * 4;
        random_done <= '1';
        wait for CLK_PERIOD;
        random_done <= '0';

        wait for CLK_PERIOD * 6;
        key_pressed <= '1';
        wait for CLK_PERIOD;
        key_pressed <= '0';

        wait for CLK_PERIOD * 10;

        wait;
    end process;

end Behavioral;