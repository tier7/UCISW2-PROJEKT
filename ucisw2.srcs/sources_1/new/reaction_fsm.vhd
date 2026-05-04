library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction_fsm is
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        start_btn        : in  std_logic;
        key_pressed      : in  std_logic;
        random_done      : in  std_logic;
        trial_count      : in  unsigned(2 downto 0);

        red_on           : out std_logic;
        green_on         : out std_logic;
        timer_enable     : out std_logic;
        timer_clear      : out std_logic;
        save_result      : out std_logic;
        inc_trial        : out std_logic;
        random_start     : out std_logic;
        clear_trials     : out std_logic;
        test_done        : out std_logic;
        invalid_reaction : out std_logic;
        state_dbg        : out std_logic_vector(2 downto 0)
    );
end reaction_fsm;

architecture Behavioral of reaction_fsm is

    type state_type is (
        ST_IDLE,
        ST_WAIT_RANDOM,
        ST_MEASURE,
        ST_SAVE_RESULT,
        ST_INVALID_RESULT,
        ST_NEXT_TRIAL,
        ST_FINAL_RESULT
    );

    signal state : state_type := ST_IDLE;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= ST_IDLE;
            else
                case state is
                    when ST_IDLE =>
                        if start_btn = '1' then
                            state <= ST_WAIT_RANDOM;
                        end if;

                    when ST_WAIT_RANDOM =>
                        if key_pressed = '1' then
                            state <= ST_INVALID_RESULT;
                        elsif random_done = '1' then
                            state <= ST_MEASURE;
                        end if;

                    when ST_MEASURE =>
                        if key_pressed = '1' then
                            state <= ST_SAVE_RESULT;
                        end if;

                    when ST_SAVE_RESULT =>
                        state <= ST_NEXT_TRIAL;

                    when ST_INVALID_RESULT =>
                        state <= ST_NEXT_TRIAL;

                    when ST_NEXT_TRIAL =>
                        if trial_count = "100" then
                            state <= ST_FINAL_RESULT;
                        else
                            state <= ST_WAIT_RANDOM;
                        end if;

                    when ST_FINAL_RESULT =>
                        if start_btn = '1' then
                            state <= ST_WAIT_RANDOM;
                        end if;
                end case;
            end if;
        end if;
    end process;

    red_on           <= '1' when state = ST_WAIT_RANDOM else '0';
    green_on         <= '1' when state = ST_MEASURE else '0';
    timer_enable     <= '1' when state = ST_MEASURE else '0';

    timer_clear      <= '1' when (state = ST_IDLE and start_btn = '1') or
                                  (state = ST_WAIT_RANDOM and random_done = '1') or
                                  (state = ST_WAIT_RANDOM and key_pressed = '1')
                        else '0';

    save_result      <= '1' when state = ST_SAVE_RESULT else '0';

    invalid_reaction <= '1' when state = ST_INVALID_RESULT else '0';

    inc_trial        <= '1' when (state = ST_NEXT_TRIAL and trial_count /= "100")
                        else '0';

    random_start     <= '1' when (state = ST_IDLE and start_btn = '1') or
                                  (state = ST_NEXT_TRIAL and trial_count /= "100") or
                                  (state = ST_FINAL_RESULT and start_btn = '1')
                        else '0';

    clear_trials     <= '1' when (state = ST_IDLE and start_btn = '1') or
                                  (state = ST_FINAL_RESULT and start_btn = '1')
                        else '0';

    test_done        <= '1' when state = ST_FINAL_RESULT else '0';

    state_dbg <=
        "000" when state = ST_IDLE else
        "001" when state = ST_WAIT_RANDOM else
        "010" when state = ST_MEASURE else
        "011" when state = ST_SAVE_RESULT else
        "100" when state = ST_INVALID_RESULT else
        "101" when state = ST_NEXT_TRIAL else
        "110";

end Behavioral;