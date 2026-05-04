library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity oled_ascii_formatter is
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        busy             : in  std_logic;

        trial_count_dbg  : in  unsigned(2 downto 0);
        saved_time_ms    : in  unsigned(31 downto 0);
        avg_time_ms      : in  unsigned(31 downto 0);
        test_done        : in  std_logic;
        invalid_reaction : in  std_logic;

        ascii_out        : out std_logic_vector(6 downto 0);
        ascii_we_out     : out std_logic;
        clrscr_out       : out std_logic
    );
end oled_ascii_formatter;

architecture Behavioral of oled_ascii_formatter is

    subtype ascii7_t is std_logic_vector(6 downto 0);
    type char_array_t is array (0 to 15) of ascii7_t;

    type state_t is (
        ST_IDLE,
        ST_CLR_PULSE,
        ST_WAIT_CLR_BUSY_HI,
        ST_WAIT_CLR_BUSY_LO,
        ST_SEND_CHAR,
        ST_WAIT_CHAR_BUSY_HI,
        ST_WAIT_CHAR_BUSY_LO
    );

    signal state_s      : state_t := ST_IDLE;
    signal idx_s        : integer range 0 to 15 := 0;

    signal ascii_reg_s  : ascii7_t := (others => '0');
    signal we_reg_s     : std_logic := '0';
    signal clr_reg_s    : std_logic := '0';

    signal msg_cur_s    : char_array_t;
    signal msg_sent_s   : char_array_t := (others => std_logic_vector(to_unsigned(character'pos(' '), 7)));

    function ch(c : character) return ascii7_t is
    begin
        return std_logic_vector(to_unsigned(character'pos(c), 7));
    end function;

    function dig(d : integer) return ascii7_t is
    begin
        return std_logic_vector(to_unsigned(character'pos('0') + d, 7));
    end function;

    function msg_equal(a, b : char_array_t) return boolean is
    begin
        for i in 0 to 15 loop
            if a(i) /= b(i) then
                return false;
            end if;
        end loop;
        return true;
    end function;

begin

    -- Budowanie aktualnego komunikatu 16-znakowego
    process(trial_count_dbg, saved_time_ms, avg_time_ms, test_done, invalid_reaction)
        variable msg_v : char_array_t;
        variable tmp   : integer;
        variable d0, d1, d2, d3 : integer;
        variable tryno : integer;
    begin
        for i in 0 to 15 loop
            msg_v(i) := ch(' ');
        end loop;

        tryno := to_integer(trial_count_dbg) + 1;
        if tryno < 1 then
            tryno := 1;
        end if;
        if tryno > 5 then
            tryno := 5;
        end if;

        if test_done = '1' then
            if invalid_reaction = '1' then
                -- "BAD  ERROR      "
                msg_v(0) := ch('B');
                msg_v(1) := ch('A');
                msg_v(2) := ch('D');
                msg_v(5) := ch('E');
                msg_v(6) := ch('R');
                msg_v(7) := ch('R');
                msg_v(8) := ch('O');
                msg_v(9) := ch('R');
            else
                -- "AVG 0267 GOOD   "
                msg_v(0) := ch('A');
                msg_v(1) := ch('V');
                msg_v(2) := ch('G');
                msg_v(3) := ch(' ');

                tmp := to_integer(avg_time_ms);
                if tmp < 0 then tmp := 0; end if;
                if tmp > 9999 then tmp := 9999; end if;

                d0 := tmp mod 10; tmp := tmp / 10;
                d1 := tmp mod 10; tmp := tmp / 10;
                d2 := tmp mod 10; tmp := tmp / 10;
                d3 := tmp mod 10;

                msg_v(4) := dig(d3);
                msg_v(5) := dig(d2);
                msg_v(6) := dig(d1);
                msg_v(7) := dig(d0);

                msg_v(9)  := ch('G');
                msg_v(10) := ch('O');
                msg_v(11) := ch('O');
                msg_v(12) := ch('D');
            end if;
        else
            if invalid_reaction = '1' then
                -- "TRY1 ERROR      "
                msg_v(0) := ch('T');
                msg_v(1) := ch('R');
                msg_v(2) := ch('Y');
                msg_v(3) := dig(tryno);
                msg_v(5) := ch('E');
                msg_v(6) := ch('R');
                msg_v(7) := ch('R');
                msg_v(8) := ch('O');
                msg_v(9) := ch('R');
            else
                -- "TRY1 0245       "
                msg_v(0) := ch('T');
                msg_v(1) := ch('R');
                msg_v(2) := ch('Y');
                msg_v(3) := dig(tryno);
                msg_v(4) := ch(' ');

                tmp := to_integer(saved_time_ms);
                if tmp < 0 then tmp := 0; end if;
                if tmp > 9999 then tmp := 9999; end if;

                d0 := tmp mod 10; tmp := tmp / 10;
                d1 := tmp mod 10; tmp := tmp / 10;
                d2 := tmp mod 10; tmp := tmp / 10;
                d3 := tmp mod 10;

                msg_v(5) := dig(d3);
                msg_v(6) := dig(d2);
                msg_v(7) := dig(d1);
                msg_v(8) := dig(d0);
            end if;
        end if;

        msg_cur_s <= msg_v;
    end process;

    -- Sterownik wysyłający znaki do OLED_ASCII_wrap
    process(clk)
    begin
        if rising_edge(clk) then
            we_reg_s  <= '0';
            clr_reg_s <= '0';

            if rst = '1' then
                state_s     <= ST_IDLE;
                idx_s       <= 0;
                ascii_reg_s <= ch(' ');
                msg_sent_s  <= (others => ch(' '));
            else
                case state_s is

                    when ST_IDLE =>
                        if not msg_equal(msg_cur_s, msg_sent_s) then
                            msg_sent_s <= msg_cur_s;
                            idx_s      <= 0;
                            state_s    <= ST_CLR_PULSE;
                        end if;

                    when ST_CLR_PULSE =>
                        clr_reg_s <= '1';
                        state_s   <= ST_WAIT_CLR_BUSY_HI;

                    when ST_WAIT_CLR_BUSY_HI =>
                        if busy = '1' then
                            state_s <= ST_WAIT_CLR_BUSY_LO;
                        end if;

                    when ST_WAIT_CLR_BUSY_LO =>
                        if busy = '0' then
                            state_s <= ST_SEND_CHAR;
                        end if;

                    when ST_SEND_CHAR =>
                        if busy = '0' then
                            ascii_reg_s <= msg_sent_s(idx_s);
                            we_reg_s    <= '1';
                            state_s     <= ST_WAIT_CHAR_BUSY_HI;
                        end if;

                    when ST_WAIT_CHAR_BUSY_HI =>
                        if busy = '1' then
                            state_s <= ST_WAIT_CHAR_BUSY_LO;
                        end if;

                    when ST_WAIT_CHAR_BUSY_LO =>
                        if busy = '0' then
                            if idx_s = 15 then
                                state_s <= ST_IDLE;
                            else
                                idx_s   <= idx_s + 1;
                                state_s <= ST_SEND_CHAR;
                            end if;
                        end if;

                end case;
            end if;
        end if;
    end process;

    ascii_out    <= ascii_reg_s;
    ascii_we_out <= we_reg_s;
    clrscr_out   <= clr_reg_s;

end Behavioral;