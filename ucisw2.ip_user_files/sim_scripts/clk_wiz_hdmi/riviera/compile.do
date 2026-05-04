transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../ipstatic" "+incdir+D:/2025.2/Vivado/data/rsb/busdef" -l xpm -l xil_defaultlib \
"D:/2025.2/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  -incr \
"D:/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../ipstatic" "+incdir+D:/2025.2/Vivado/data/rsb/busdef" -l xpm -l xil_defaultlib \
"../../../../ucisw2.gen/sources_1/ip/clk_wiz_hdmi/clk_wiz_hdmi_clk_wiz.v" \
"../../../../ucisw2.gen/sources_1/ip/clk_wiz_hdmi/clk_wiz_hdmi.v" \

vlog -work xil_defaultlib \
"glbl.v"

