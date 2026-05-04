vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../ipstatic" "+incdir+D:/2025.2/Vivado/data/rsb/busdef" \
"D:/2025.2/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"D:/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic" "+incdir+D:/2025.2/Vivado/data/rsb/busdef" \
"../../../../ucisw2.gen/sources_1/ip/clk_wiz_hdmi/clk_wiz_hdmi_clk_wiz.v" \
"../../../../ucisw2.gen/sources_1/ip/clk_wiz_hdmi/clk_wiz_hdmi.v" \

vlog -work xil_defaultlib \
"glbl.v"

