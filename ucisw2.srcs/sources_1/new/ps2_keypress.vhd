library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ps2_keypress is
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;
        ps2_clk       : in  std_logic;
        ps2_data      : in  std_logic;
        key_pressed   : out std_logic;
        key_code_dbg  : out std_logic_vector(7 downto 0);
        key_ready_dbg : out std_logic
    );
end ps2_keypress;

architecture Behavioral of ps2_keypress is

    signal key_code_s  : std_logic_vector(7 downto 0);
    signal e0_s        : std_logic;
    signal f0_s        : std_logic;
    signal key_rdy_s   : std_logic;

    signal key_pulse_s : std_logic := '0';
    signal last_code_s : std_logic_vector(7 downto 0) := (others => '0');

begin

    u_ps2 : entity work.PS2_Kbd_wrap
        port map (
            Clk_100MHz => clk,
            Key_Code   => key_code_s,
            E0         => e0_s,
            F0         => f0_s,
            Key_Rdy    => key_rdy_s,
            PS2_Clk    => ps2_clk,
            PS2_Data   => ps2_data
        );

    process(clk)
    begin
        if rising_edge(clk) then
            key_pulse_s <= '0';

            if rst = '1' then
                last_code_s <= (others => '0');
            else
                if key_rdy_s = '1' and f0_s = '0' then
                    key_pulse_s <= '1';
                    last_code_s <= key_code_s;
                end if;
            end if;
        end if;
    end process;

    key_pressed   <= key_pulse_s;
    key_code_dbg  <= last_code_s;
    key_ready_dbg <= key_pulse_s;

end Behavioral;