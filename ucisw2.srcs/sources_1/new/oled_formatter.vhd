library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity oled_formatter is
    port (
        trial_count_dbg  : in  unsigned(2 downto 0);
        saved_time_ms    : in  unsigned(31 downto 0);
        avg_time_ms      : in  unsigned(31 downto 0);
        test_done        : in  std_logic;
        invalid_reaction : in  std_logic;

        line_out         : out std_logic_vector(63 downto 0);
        decpts_out       : out std_logic_vector(15 downto 0);
        blank_out        : out std_logic_vector(15 downto 0)
    );
end oled_formatter;

architecture Behavioral of oled_formatter is

    function digit_to_nibble(d : integer) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(d, 4));
    end function;

    function time_to_16hex(val : integer) return std_logic_vector is
        variable tmp : integer := val;
        variable d0, d1, d2, d3 : integer := 0;
        variable line_v : std_logic_vector(63 downto 0) := (others => '0');
    begin
        if tmp < 0 then
            tmp := 0;
        end if;

        if tmp > 9999 then
            tmp := 9999;
        end if;

        d0 := tmp mod 10;
        tmp := tmp / 10;
        d1 := tmp mod 10;
        tmp := tmp / 10;
        d2 := tmp mod 10;
        tmp := tmp / 10;
        d3 := tmp mod 10;

        -- 4 cyfry czasu po prawej
        line_v(15 downto 12) := digit_to_nibble(d3);
        line_v(11 downto 8)  := digit_to_nibble(d2);
        line_v(7 downto 4)   := digit_to_nibble(d1);
        line_v(3 downto 0)   := digit_to_nibble(d0);

        return line_v;
    end function;

    function trial_to_16hex(t : integer) return std_logic_vector is
        variable line_v   : std_logic_vector(63 downto 0) := (others => '0');
        variable trial_no : integer := t + 1; -- 0..4 -> 1..5
    begin
        if trial_no < 1 then
            trial_no := 1;
        end if;

        if trial_no > 5 then
            trial_no := 5;
        end if;

        -- pierwsza cyfra od lewej = numer próby
        line_v(63 downto 60) := digit_to_nibble(trial_no);

        return line_v;
    end function;

    signal line_s : std_logic_vector(63 downto 0);

begin

    process(trial_count_dbg, saved_time_ms, avg_time_ms, test_done, invalid_reaction)
        variable line_tmp : std_logic_vector(63 downto 0);
    begin
        if test_done = '1' then
            if invalid_reaction = '1' then
                line_tmp := time_to_16hex(9999);
            else
                line_tmp := time_to_16hex(to_integer(avg_time_ms));
            end if;
        else
            line_tmp := trial_to_16hex(to_integer(trial_count_dbg)) or
                        time_to_16hex(to_integer(saved_time_ms));
        end if;

        line_s <= line_tmp;
    end process;

    line_out   <= line_s;
    decpts_out <= (others => '0');

    -- W trakcie testu: lewa 1 cyfra + prawe 4 cyfry
    -- Po teście: tylko prawe 4 cyfry
    blank_out <= "0111111111100000" when test_done = '0' else
                 "1111111111110000";

end Behavioral;