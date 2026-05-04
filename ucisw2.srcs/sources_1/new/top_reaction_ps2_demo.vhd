library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.ALL;

entity top_reaction_ps2_demo is
    generic (
        CLK_FREQ_HZ : integer := 100000000;
        WAIT_MS     : integer := 2000
    );
    port (
        clk_p     : in  std_logic;
        clk_n     : in  std_logic;
        rst       : in  std_logic;
        start_btn : in  std_logic;
        ps2_clk   : in  std_logic;
        ps2_data  : in  std_logic;
        led       : out std_logic_vector(3 downto 0);

        OLED_SCL  : inout std_logic;
        OLED_SDA  : inout std_logic;

        HDMI_D0_P : out std_logic;
        HDMI_D0_N : out std_logic;
        HDMI_D1_P : out std_logic;
        HDMI_D1_N : out std_logic;
        HDMI_D2_P : out std_logic;
        HDMI_D2_N : out std_logic;
        HDMI_CK_P : out std_logic;
        HDMI_CK_N : out std_logic
    );
end top_reaction_ps2_demo;

architecture Behavioral of top_reaction_ps2_demo is

    signal clk_s               : std_logic;

    signal red_on_s            : std_logic;
    signal green_on_s          : std_logic;
    signal test_done_s         : std_logic;
    signal key_pressed_dbg_s   : std_logic;
    signal key_code_dbg_s      : std_logic_vector(7 downto 0);
    signal delay_busy_dbg_s    : std_logic;

    signal timer_enable_dbg_s  : std_logic;
    signal timer_clear_dbg_s   : std_logic;
    signal save_result_dbg_s   : std_logic;
    signal inc_trial_dbg_s     : std_logic;
    signal random_start_dbg_s  : std_logic;
    signal clear_trials_dbg_s  : std_logic;
    signal invalid_reaction_s  : std_logic;

    signal state_dbg_s         : std_logic_vector(2 downto 0);
    signal trial_count_dbg_s   : unsigned(2 downto 0);
    signal current_time_ms_s   : unsigned(31 downto 0);
    signal saved_time_ms_s     : unsigned(31 downto 0);
    signal avg_time_ms_s       : unsigned(31 downto 0);

    signal ascii_char_s        : std_logic_vector(6 downto 0);
    signal ascii_we_s          : std_logic;
    signal oled_clr_s          : std_logic;
    signal oled_busy_s         : std_logic;

    signal pxClk_s             : std_logic;
    signal pxClkX5_s           : std_logic;
    signal clk_locked_s        : std_logic;

    signal hcount_s            : unsigned(10 downto 0);
    signal vcount_s            : unsigned(10 downto 0);
    signal de_s                : std_logic;
    signal hsync_s             : std_logic;
    signal vsync_s             : std_logic;
    signal R_s                 : std_logic_vector(7 downto 0);
    signal G_s                 : std_logic_vector(7 downto 0);
    signal B_s                 : std_logic_vector(7 downto 0);

    signal hdmi_rst_s          : std_logic;

begin

    u_ibufds : IBUFDS
        port map (
            I  => clk_p,
            IB => clk_n,
            O  => clk_s
        );

    u_top : entity work.top_reaction_ps2
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            WAIT_MS     => WAIT_MS
        )
        port map (
            clk                  => clk_s,
            rst                  => rst,
            start_btn            => start_btn,
            ps2_clk              => ps2_clk,
            ps2_data             => ps2_data,

            red_on               => red_on_s,
            green_on             => green_on_s,
            test_done            => test_done_s,

            key_pressed_dbg      => key_pressed_dbg_s,
            key_code_dbg         => key_code_dbg_s,
            delay_busy_dbg       => delay_busy_dbg_s,

            timer_enable_dbg     => timer_enable_dbg_s,
            timer_clear_dbg      => timer_clear_dbg_s,
            save_result_dbg      => save_result_dbg_s,
            inc_trial_dbg        => inc_trial_dbg_s,
            random_start_dbg     => random_start_dbg_s,
            clear_trials_dbg     => clear_trials_dbg_s,
            invalid_reaction_dbg => invalid_reaction_s,

            state_dbg            => state_dbg_s,
            trial_count_dbg      => trial_count_dbg_s,
            current_time_ms      => current_time_ms_s,
            saved_time_ms        => saved_time_ms_s,
            avg_time_ms          => avg_time_ms_s
        );

    u_oled_ascii_fmt : entity work.oled_ascii_formatter
        port map (
            clk              => clk_s,
            rst              => rst,
            busy             => oled_busy_s,
            trial_count_dbg  => trial_count_dbg_s,
            saved_time_ms    => saved_time_ms_s,
            avg_time_ms      => avg_time_ms_s,
            test_done        => test_done_s,
            invalid_reaction => invalid_reaction_s,
            ascii_out        => ascii_char_s,
            ascii_we_out     => ascii_we_s,
            clrscr_out       => oled_clr_s
        );

    u_oled : entity work.OLED_ASCII_wrap
        port map (
            Clk_100MHz => clk_s,
            ASCII      => ascii_char_s,
            ASCII_WE   => ascii_we_s,
            ClrScr     => oled_clr_s,
            Busy       => oled_busy_s,
            OLED_SDA   => OLED_SDA,
            OLED_SCL   => OLED_SCL
        );

    u_clk_hdmi : entity work.clk_wiz_hdmi
        port map (
            clk_in1  => clk_s,
            reset    => rst,
            clk_out1 => pxClk_s,
            clk_out2 => pxClkX5_s,
            locked   => clk_locked_s
        );

    hdmi_rst_s <= rst or (not clk_locked_s);

    u_vtim : entity work.video_timing_640x480
        port map (
            pxClk  => pxClk_s,
            rst    => hdmi_rst_s,
            hcount => hcount_s,
            vcount => vcount_s,
            de     => de_s,
            hsync  => hsync_s,
            vsync  => vsync_s
        );

    u_vgen : entity work.reaction_video
        port map (
            hcount    => hcount_s,
            vcount    => vcount_s,
            de        => de_s,
            red_on    => red_on_s,
            green_on  => green_on_s,
            test_done => test_done_s,
            R         => R_s,
            G         => G_s,
            B         => B_s
        );

    u_hdmi : entity work.HDMI_TX_wrap
        port map (
            pxClk     => pxClk_s,
            pxClkX5   => pxClkX5_s,
            ResetN    => not hdmi_rst_s,
            DE        => de_s,
            HSync     => hsync_s,
            VSync     => vsync_s,
            R         => R_s,
            G         => G_s,
            B         => B_s,
            HDMI_D0_P => HDMI_D0_P,
            HDMI_D0_N => HDMI_D0_N,
            HDMI_D1_P => HDMI_D1_P,
            HDMI_D1_N => HDMI_D1_N,
            HDMI_D2_P => HDMI_D2_P,
            HDMI_D2_N => HDMI_D2_N,
            HDMI_CK_P => HDMI_CK_P,
            HDMI_CK_N => HDMI_CK_N
        );

    led(0) <= red_on_s;
    led(1) <= green_on_s;
    led(2) <= key_pressed_dbg_s;
    led(3) <= test_done_s;

end Behavioral;