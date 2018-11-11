#
# Copyright (c) 2015 Noa Zilberman
# Modified by Salvator Galea
# All rights reserved.
#
# This software was developed by
# Stanford University and the University of Cambridge Computer Laboratory
# under National Science Foundation under Grant No. CNS-0855268,
# the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
# by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"), 
# as part of the DARPA MRC research programme.
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
#

# Vivado Launch Script
#### Change design settings here #######
set design simple_agg
set top simple_agg
set device xc7vx690t-3-ffg1761
set proj_dir ./ip_proj
set ip_version 1.00
set lib_name NetFPGA
#####################################
# Project Settings
#####################################
create_project -name ${design} -force -dir "./${proj_dir}" -part ${device} -ip
set_property source_mgmt_mode All [current_project]  
set_property top ${top} [current_fileset]
set_property ip_repo_paths $::env(SUME_FOLDER)/lib/my_hw/  [current_fileset]
update_ip_catalog
puts "Creating FP_DATAPATH IP"
#####################################
# Project Structure & IP Build
#####################################
#read_verilog "./hdl/parser_cpu_regs_defines.v"
#read_verilog "./hdl/parser_cpu_regs.v"

#IP BUILD
read_verilog "./hdl/simple_agg.v"
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
ipx::package_project

set_property name ${design} [ipx::current_core]
set_property library ${lib_name} [ipx::current_core]
set_property vendor_display_name {NetFPGA} [ipx::current_core]
set_property company_url {www.netfpga.org} [ipx::current_core]
set_property vendor {NetFPGA} [ipx::current_core]
set_property supported_families {{virtex7} {Production}} [ipx::current_core]
set_property taxonomy {{/NetFPGA/Generic}} [ipx::current_core]
set_property version ${ip_version} [ipx::current_core]
set_property display_name ${design} [ipx::current_core]
set_property description ${design} [ipx::current_core]

update_ip_catalog -rebuild 
ipx::add_subcore NetFPGA:NetFPGA:fallthrough_small_fifo:1.00 [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::add_subcore NetFPGA:NetFPGA:fallthrough_small_fifo:1.00 [ipx::get_file_groups xilinx_anylanguagebehavioralsimulation -of_objects [ipx::current_core]]
ipx::infer_user_parameters [ipx::current_core]


ipx::add_subcore NetFPGA:NetFPGA:fp_unit:1.00 [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::add_subcore NetFPGA:NetFPGA:fp_unit:1.00 [ipx::get_file_groups xilinx_anylanguagebehavioralsimulation -of_objects [ipx::current_core]]
ipx::infer_user_parameters [ipx::current_core]


ipx::add_user_parameter {C_M_AXIS_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_M_AXIS_DATA_WIDTH]
set_property display_name {C_M_AXIS_DATA_WIDTH} [ipx::get_user_parameters C_M_AXIS_DATA_WIDTH]
set_property value {64} [ipx::get_user_parameters C_M_AXIS_DATA_WIDTH]
set_property value_format {long} [ipx::get_user_parameters C_M_AXIS_DATA_WIDTH]

ipx::add_user_parameter {C_S_AXIS_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_S_AXIS_DATA_WIDTH]
set_property display_name {C_S_AXIS_DATA_WIDTH} [ipx::get_user_parameters C_S_AXIS_DATA_WIDTH]
set_property value {64} [ipx::get_user_parameters C_S_AXIS_DATA_WIDTH]
set_property value_format {long} [ipx::get_user_parameters C_S_AXIS_DATA_WIDTH]

ipx::add_user_parameter {C_M_AXIS_TUSER_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_M_AXIS_TUSER_WIDTH]
set_property display_name {C_M_AXIS_TUSER_WIDTH} [ipx::get_user_parameters C_M_AXIS_TUSER_WIDTH]
set_property value {128} [ipx::get_user_parameters C_M_AXIS_TUSER_WIDTH]
set_property value_format {long} [ipx::get_user_parameters C_M_AXIS_TUSER_WIDTH]

ipx::add_user_parameter {C_S_AXIS_TUSER_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_S_AXIS_TUSER_WIDTH]
set_property display_name {C_S_AXIS_TUSER_WIDTH} [ipx::get_user_parameters C_S_AXIS_TUSER_WIDTH]
set_property value {128} [ipx::get_user_parameters C_S_AXIS_TUSER_WIDTH]
set_property value_format {long} [ipx::get_user_parameters C_S_AXIS_TUSER_WIDTH]

ipx::add_user_parameter {C_S_AXI_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_S_AXI_DATA_WIDTH]
set_property display_name {C_S_AXI_DATA_WIDTH} [ipx::get_user_parameters C_S_AXI_DATA_WIDTH]
set_property value {32} [ipx::get_user_parameters C_S_AXI_DATA_WIDTH]
set_property value_format {long} [ipx::get_user_parameters C_S_AXI_DATA_WIDTH]

ipx::add_user_parameter {C_S_AXI_ADDR_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_S_AXI_ADDR_WIDTH]
set_property display_name {C_S_AXI_ADDR_WIDTH} [ipx::get_user_parameters C_S_AXI_ADDR_WIDTH]
set_property value {32} [ipx::get_user_parameters C_S_AXI_ADDR_WIDTH]
set_property value_format {long} [ipx::get_user_parameters C_S_AXI_ADDR_WIDTH]

ipx::add_user_parameter {SRC_MAC_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters SRC_MAC_POS]
set_property display_name {SRC_MAC_POS} [ipx::get_user_parameters SRC_MAC_POS]
set_property value {48} [ipx::get_user_parameters SRC_MAC_POS]
set_property value_format {long} [ipx::get_user_parameters SRC_MAC_POS]


ipx::add_user_parameter {DEST_MAC_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters DEST_MAC_POS]
set_property display_name {DEST_MAC_POS} [ipx::get_user_parameters DEST_MAC_POS]
set_property value {0} [ipx::get_user_parameters DEST_MAC_POS]
set_property value_format {long} [ipx::get_user_parameters DEST_MAC_POS]

ipx::add_user_parameter {NEW_DEST_MAC} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters NEW_DEST_MAC]
set_property display_name {NEW_DEST_MAC} [ipx::get_user_parameters NEW_DEST_MAC]
set_property value {0xFFFFFFFFFFFF} [ipx::get_user_parameters NEW_DEST_MAC]
set_property value_format {bitstring} [ipx::get_user_parameters NEW_DEST_MAC]

ipx::add_user_parameter {PORTS_BITMAP} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters PORTS_BITMAP]
set_property display_name {PORTS_BITMAP} [ipx::get_user_parameters PORTS_BITMAP]
set_property value {0xC} [ipx::get_user_parameters PORTS_BITMAP]
set_property value_format {bitstring} [ipx::get_user_parameters PORTS_BITMAP]

ipx::add_user_parameter {NUM_FP_UNITS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters NUM_FP_UNITS]
set_property display_name {NUM_FP_UNITS} [ipx::get_user_parameters NUM_FP_UNITS]
set_property value {2} [ipx::get_user_parameters NUM_FP_UNITS]
set_property value_format {long} [ipx::get_user_parameters NUM_FP_UNITS]

ipx::add_user_parameter {FP_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters FP_DATA_WIDTH]
set_property display_name {FP_DATA_WIDTH} [ipx::get_user_parameters FP_DATA_WIDTH]
set_property value {32} [ipx::get_user_parameters FP_DATA_WIDTH]
set_property value_format {long} [ipx::get_user_parameters FP_DATA_WIDTH]

ipx::add_user_parameter {MY_HEADERS_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters MY_HEADERS_POS]
set_property display_name {MY_HEADERS_POS} [ipx::get_user_parameters MY_HEADERS_POS]
set_property value {272} [ipx::get_user_parameters MY_HEADERS_POS]
set_property value_format {long} [ipx::get_user_parameters MY_HEADERS_POS]

ipx::add_user_parameter {OPP_CODE_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters OPP_CODE_POS]
set_property display_name {OPP_CODE_POS} [ipx::get_user_parameters OPP_CODE_POS]
set_property value {274} [ipx::get_user_parameters OPP_CODE_POS]
set_property value_format {long} [ipx::get_user_parameters OPP_CODE_POS]

ipx::add_user_parameter {VECTOR_INDEX_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters VECTOR_INDEX_POS]
set_property display_name {VECTOR_INDEX_POS} [ipx::get_user_parameters VECTOR_INDEX_POS]
set_property value {276} [ipx::get_user_parameters VECTOR_INDEX_POS]
set_property value_format {long} [ipx::get_user_parameters VECTOR_INDEX_POS]

ipx::add_user_parameter {FIN_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters FIN_POS]
set_property display_name {FIN_POS} [ipx::get_user_parameters FIN_POS]
set_property value {308} [ipx::get_user_parameters FIN_POS]
set_property value_format {long} [ipx::get_user_parameters FIN_POS]

ipx::add_user_parameter {NUM_VARIABLES_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters NUM_VARIABLES_POS]
set_property display_name {NUM_VARIABLES_POS} [ipx::get_user_parameters NUM_VARIABLES_POS]
set_property value {309} [ipx::get_user_parameters NUM_VARIABLES_POS]
set_property value_format {long} [ipx::get_user_parameters NUM_VARIABLES_POS]

ipx::add_user_parameter {DATA_POS} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters DATA_POS]
set_property display_name {DATA_POS} [ipx::get_user_parameters DATA_POS]
set_property value {320} [ipx::get_user_parameters DATA_POS]
set_property value_format {long} [ipx::get_user_parameters DATA_POS]

ipx::add_user_parameter {MASTER} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters MASTER]
set_property display_name {MASTER} [ipx::get_user_parameters MASTER]
set_property value {0} [ipx::get_user_parameters MASTER]
set_property value_format {long} [ipx::get_user_parameters MASTER]


ipx::add_user_parameter {C_BASEADDR} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameters C_BASEADDR]
set_property display_name {C_BASEADDR} [ipx::get_user_parameters C_BASEADDR]
set_property value {0x00000000} [ipx::get_user_parameters C_BASEADDR]
set_property value_format {bitstring} [ipx::get_user_parameters C_BASEADDR]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis_0 -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis_1 -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis_2 -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis_3 -of_objects [ipx::current_core]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis_0 -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis_1 -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis_2 -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis_3 -of_objects [ipx::current_core]]

ipx::infer_user_parameters [ipx::current_core]

ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
update_ip_catalog
close_project













