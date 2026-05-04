## ===== PS/2 on Expansion Board - PORT A =====
set_property PACKAGE_PIN AB10 [get_ports {ps2_data}]
set_property PACKAGE_PIN AB9  [get_ports {ps2_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {ps2_data ps2_clk}]
set_property PULLUP true [get_ports {ps2_data ps2_clk}]

############# OLED IIC
set_property PACKAGE_PIN AE12 [get_ports {OLED_SCL}]
set_property PACKAGE_PIN AF12 [get_ports {OLED_SDA}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SCL OLED_SDA}]
set_property SLEW FAST [get_ports {OLED_SCL OLED_SDA}]
set_property PULLUP true [get_ports {OLED_SCL OLED_SDA}]

############ HDMI
set_property PACKAGE_PIN AF11 [get_ports {HDMI_D2_P}]
set_property PACKAGE_PIN AG11 [get_ports {HDMI_D2_N}]
set_property PACKAGE_PIN AH11 [get_ports {HDMI_D1_P}]
set_property PACKAGE_PIN AH12 [get_ports {HDMI_D1_N}]
set_property PACKAGE_PIN AF10 [get_ports {HDMI_D0_P}]
set_property PACKAGE_PIN AE10 [get_ports {HDMI_D0_N}]
set_property PACKAGE_PIN AD12 [get_ports {HDMI_CK_P}]
set_property PACKAGE_PIN AC12 [get_ports {HDMI_CK_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_D2_P HDMI_D2_N HDMI_D1_P HDMI_D1_N HDMI_D0_P HDMI_D0_N HDMI_CK_P HDMI_CK_N}]