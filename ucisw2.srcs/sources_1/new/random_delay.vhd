library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity random_delay is
    generic (
        CLK_FREQ_HZ : integer := 100000000;
        MIN_MS      : integer := 1000;
        MAX_MS      : integer := 3000
    );
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        start      : in  std_logic;
        seed_event : in  std_logic;
        done_pulse : out std_logic;
        busy       : out std_logic
    );
end random_delay;

architecture Behavioral of random_delay is

    constant MIN_CYCLES : integer := (CLK_FREQ_HZ / 1000) * MIN_MS;
    constant MAX_CYCLES : integer := (CLK_FREQ_HZ / 1000) * MAX_MS;
    constant RANGE_CYC  : integer := MAX_CYCLES - MIN_CYCLES;

    signal lfsr_s       : unsigned(15 downto 0) := x"ACE1";
    signal active_s     : std_logic := '0';
    signal done_reg_s   : std_logic := '0';
    signal counter_s    : integer := 0;
    signal target_s     : integer := MIN_CYCLES;

begin

    process(clk)
        variable feedback_v : std_logic;
        variable rand_part  : integer;
    begin
        if rising_edge(clk) then
            done_reg_s <= '0';

            if rst = '1' then
                lfsr_s    <= x"ACE1";
                active_s  <= '0';
                counter_s <= 0;
                target_s  <= MIN_CYCLES;
            else
                -- LFSR miesza się przy różnych zdarzeniach użytkownika/systemu
                if seed_event = '1' or start = '1' then
                    feedback_v := lfsr_s(15) xor lfsr_s(13) xor lfsr_s(12) xor lfsr_s(10);
                    lfsr_s <= lfsr_s(14 downto 0) & feedback_v;
                end if;

                if active_s = '0' then
                    if start = '1' then
                        rand_part := to_integer(lfsr_s) mod (RANGE_CYC + 1);
                        target_s  <= MIN_CYCLES + rand_part;
                        counter_s <= 0;
                        active_s  <= '1';
                    end if;
                else
                    if counter_s >= target_s then
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