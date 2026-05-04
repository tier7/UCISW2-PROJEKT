library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity video_timing_640x480 is
    port (
        pxClk   : in  std_logic;
        rst     : in  std_logic;
        hcount  : out unsigned(10 downto 0);
        vcount  : out unsigned(10 downto 0);
        de      : out std_logic;
        hsync   : out std_logic;
        vsync   : out std_logic
    );
end video_timing_640x480;

architecture Behavioral of video_timing_640x480 is

    signal hcnt_s : unsigned(10 downto 0) := (others => '0');
    signal vcnt_s : unsigned(10 downto 0) := (others => '0');

begin

    process(pxClk)
    begin
        if rising_edge(pxClk) then
            if rst = '1' then
                hcnt_s <= (others => '0');
                vcnt_s <= (others => '0');
            else
                if hcnt_s = 799 then
                    hcnt_s <= (others => '0');

                    if vcnt_s = 524 then
                        vcnt_s <= (others => '0');
                    else
                        vcnt_s <= vcnt_s + 1;
                    end if;
                else
                    hcnt_s <= hcnt_s + 1;
                end if;
            end if;
        end if;
    end process;

    hcount <= hcnt_s;
    vcount <= vcnt_s;

    -- aktywny obszar 640x480
    de <= '1' when (hcnt_s < 640 and vcnt_s < 480) else '0';

    -- sync aktywne w stanie niskim
    hsync <= '0' when (hcnt_s >= 656 and hcnt_s < 752) else '1';
    vsync <= '0' when (vcnt_s >= 490 and vcnt_s < 492) else '1';

end Behavioral;