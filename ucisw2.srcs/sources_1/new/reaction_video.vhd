library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction_video is
    port (
        hcount    : in  unsigned(10 downto 0);
        vcount    : in  unsigned(10 downto 0);
        de        : in  std_logic;
        red_on    : in  std_logic;
        green_on  : in  std_logic;
        test_done : in  std_logic;
        R         : out std_logic_vector(7 downto 0);
        G         : out std_logic_vector(7 downto 0);
        B         : out std_logic_vector(7 downto 0)
    );
end reaction_video;

architecture Behavioral of reaction_video is
begin

    process(hcount, vcount, de, red_on, green_on, test_done)
        variable r_v : std_logic_vector(7 downto 0);
        variable g_v : std_logic_vector(7 downto 0);
        variable b_v : std_logic_vector(7 downto 0);
        variable in_square : boolean;
    begin
        r_v := (others => '0');
        g_v := (others => '0');
        b_v := (others => '0');

        -- kwadrat na środku ekranu
        in_square := (hcount >= 220 and hcount < 420 and
                      vcount >= 140 and vcount < 340);

        if de = '1' then
            if in_square then
                if red_on = '1' then
                    r_v := x"FF";
                    g_v := x"00";
                    b_v := x"00";
                elsif green_on = '1' then
                    r_v := x"00";
                    g_v := x"FF";
                    b_v := x"00";
                elsif test_done = '1' then
                    r_v := x"00";
                    g_v := x"00";
                    b_v := x"FF";
                else
                    -- stan spoczynkowy
                    r_v := x"40";
                    g_v := x"40";
                    b_v := x"40";
                end if;
            else
                -- tło czarne
                r_v := x"00";
                g_v := x"00";
                b_v := x"00";
            end if;
        end if;

        R <= r_v;
        G <= g_v;
        B <= b_v;
    end process;

end Behavioral;