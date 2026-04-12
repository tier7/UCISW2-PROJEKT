library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wait_delay is
    generic (
        CLK_FREQ_HZ : integer := 100000000;
        WAIT_MS     : integer := 2000
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        done_pulse: out std_logic;
        busy      : out std_logic
    );
end wait_delay;

architecture Behavioral of wait_delay is
    constant WAIT_CYCLES : integer := (CLK_FREQ_HZ / 1000) * WAIT_MS;

    signal active_s    : std_logic := '0';
    signal done_reg_s  : std_logic := '0';
    signal counter_s   : integer range 0 to WAIT_CYCLES := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            done_reg_s <= '0';

            if rst = '1' then
                active_s  <= '0';
                counter_s <= 0;
            else
                if active_s = '0' then
                    if start = '1' then
                        active_s  <= '1';
                        counter_s <= 0;
                    end if;
                else
                    if counter_s = WAIT_CYCLES - 1 then
                        active_s   <= '0';
                        counter_s  <= 0;
                        done_reg_s <= '1';
                    else
                        counter_s <= counter_s + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    done_pulse <= done_reg_s;
    busy       <= active_s;

end Behavioral;