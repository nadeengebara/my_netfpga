#Creates ips used in fp_adder unit


create_ip -name floating_point -vendor xilinx.com -library ip -version 7.1 -module_name axi_fp_unit

set_property -dict [list CONFIG.Flow_Control {NonBlocking}] [get_ips axi_fp_unit]

set_property -dict [list CONFIG.Has_RESULT_TREADY {false}] [get_ips axi_fp_unit]

set_property -dict [list CONFIG.Maximum_Latency {false}] [get_ips axi_fp_unit]

set_property -dict [list CONFIG.C_Latency {1}] [get_ips axi_fp_unit]

 

set_property generate_synth_checkpoint false [get_files axi_fp_unit.xci]

reset_target all [get_ips axi_fp_unit.xci]

generate_target all [get_ips axi_fp_unit.xci]

 

#create fifo generator ip

create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.1 -module_name result_fifo

set_property -dict [list CONFIG.Performance_Options {First_Word_Fall_Through}] [get_ips result_fifo]

set_property -dict [list CONFIG.Input_Data_Width {32}] [get_ips result_fifo]

set_property -dict [list CONFIG.Input_Depth {16}] [get_ips result_fifo]

set_property -dict [list CONFIG.Output_Data_Width {32}] [get_ips result_fifo]

set_property -dict [list CONFIG.Output_Depth {16}] [get_ips result_fifo]


set_property -dict [list CONFIG.Data_Count_Width {5}] [get_ips result_fifo]

set_property -dict [list CONFIG.Write_Data_Count_Width {5}] [get_ips result_fifo]

set_property -dict [list CONFIG.Read_Data_Count_Width {5}] [get_ips result_fifo]

set_property -dict [list CONFIG.Full_Threshold_Assert_Value {15}] [get_ips result_fifo]

set_property -dict [list CONFIG.Full_Threshold_Negate_Value {14}] [get_ips result_fifo] 
