## ===== CLOCK 100 MHz LVDS =====
set_property PACKAGE_PIN D7 [get_ports clk_p]
set_property PACKAGE_PIN D6 [get_ports clk_n]
set_property IOSTANDARD LVDS [get_ports {clk_p clk_n}]
create_clock -period 10.000 -name Clk_100MHz [get_ports clk_p]

## ===== BUTTONS =====
set_property PACKAGE_PIN AB6 [get_ports start_btn]
set_property IOSTANDARD LVCMOS12 [get_ports start_btn]

set_property PACKAGE_PIN AB7 [get_ports rst]
set_property IOSTANDARD LVCMOS12 [get_ports rst]

## ===== LEDS =====
set_property PACKAGE_PIN AF5 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[0]}]

set_property PACKAGE_PIN AE7 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[1]}]

set_property PACKAGE_PIN AH2 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[2]}]

set_property PACKAGE_PIN AE5 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[3]}]