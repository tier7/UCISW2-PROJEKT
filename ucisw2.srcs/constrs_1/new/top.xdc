## ===== CLOCK 100 MHz LVDS =====
set_property PACKAGE_PIN D7 [get_ports clk_p]
set_property PACKAGE_PIN D6 [get_ports clk_n]
set_property IOSTANDARD LVDS [get_ports {clk_p clk_n}]
create_clock -period 10.000 -name Clk_100MHz [get_ports clk_p]

## ===== BUTTONS =====
## start_btn -> PB0
set_property PACKAGE_PIN AB6 [get_ports start_btn]
set_property IOSTANDARD LVCMOS12 [get_ports start_btn]

## rst -> PB1
set_property PACKAGE_PIN AB7 [get_ports rst]
set_property IOSTANDARD LVCMOS12 [get_ports rst]

## ===== LEDS =====
## led[0] = red_on
set_property PACKAGE_PIN AF5 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[0]}]

## led[1] = green_on
set_property PACKAGE_PIN AE7 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[1]}]

## led[2] = key_pressed_dbg
set_property PACKAGE_PIN AH2 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[2]}]

## led[3] = test_done
set_property PACKAGE_PIN AE5 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[3]}]

## ===== PS/2 on PMOD JA =====
## przykład: JA[0] i JA[1]
set_property PACKAGE_PIN J12 [get_ports ps2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]

set_property PACKAGE_PIN H12 [get_ports ps2_data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]