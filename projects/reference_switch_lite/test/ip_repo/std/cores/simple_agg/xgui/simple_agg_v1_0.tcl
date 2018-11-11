# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXIS_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXIS_TUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_TUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEST_MAC_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIN_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FP_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MASTER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MY_HEADERS_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NEW_DEST_MAC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_FP_UNITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_QUEUES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_VARIABLES_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OPP_CODE_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PORTS_BITMAP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SRC_MAC_POS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VECTOR_INDEX_POS" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_BASEADDR { PARAM_VALUE.C_BASEADDR } {
	# Procedure called to update C_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BASEADDR { PARAM_VALUE.C_BASEADDR } {
	# Procedure called to validate C_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_DATA_WIDTH { PARAM_VALUE.C_M_AXIS_DATA_WIDTH } {
	# Procedure called to update C_M_AXIS_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_DATA_WIDTH { PARAM_VALUE.C_M_AXIS_DATA_WIDTH } {
	# Procedure called to validate C_M_AXIS_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_TUSER_WIDTH { PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_M_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_TUSER_WIDTH { PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_M_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_DATA_WIDTH { PARAM_VALUE.C_S_AXIS_DATA_WIDTH } {
	# Procedure called to update C_S_AXIS_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_DATA_WIDTH { PARAM_VALUE.C_S_AXIS_DATA_WIDTH } {
	# Procedure called to validate C_S_AXIS_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_S_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_S_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_POS { PARAM_VALUE.DATA_POS } {
	# Procedure called to update DATA_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_POS { PARAM_VALUE.DATA_POS } {
	# Procedure called to validate DATA_POS
	return true
}

proc update_PARAM_VALUE.DEST_MAC_POS { PARAM_VALUE.DEST_MAC_POS } {
	# Procedure called to update DEST_MAC_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEST_MAC_POS { PARAM_VALUE.DEST_MAC_POS } {
	# Procedure called to validate DEST_MAC_POS
	return true
}

proc update_PARAM_VALUE.FIN_POS { PARAM_VALUE.FIN_POS } {
	# Procedure called to update FIN_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIN_POS { PARAM_VALUE.FIN_POS } {
	# Procedure called to validate FIN_POS
	return true
}

proc update_PARAM_VALUE.FP_DATA_WIDTH { PARAM_VALUE.FP_DATA_WIDTH } {
	# Procedure called to update FP_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FP_DATA_WIDTH { PARAM_VALUE.FP_DATA_WIDTH } {
	# Procedure called to validate FP_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MASTER { PARAM_VALUE.MASTER } {
	# Procedure called to update MASTER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MASTER { PARAM_VALUE.MASTER } {
	# Procedure called to validate MASTER
	return true
}

proc update_PARAM_VALUE.MY_HEADERS_POS { PARAM_VALUE.MY_HEADERS_POS } {
	# Procedure called to update MY_HEADERS_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MY_HEADERS_POS { PARAM_VALUE.MY_HEADERS_POS } {
	# Procedure called to validate MY_HEADERS_POS
	return true
}

proc update_PARAM_VALUE.NEW_DEST_MAC { PARAM_VALUE.NEW_DEST_MAC } {
	# Procedure called to update NEW_DEST_MAC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NEW_DEST_MAC { PARAM_VALUE.NEW_DEST_MAC } {
	# Procedure called to validate NEW_DEST_MAC
	return true
}

proc update_PARAM_VALUE.NUM_FP_UNITS { PARAM_VALUE.NUM_FP_UNITS } {
	# Procedure called to update NUM_FP_UNITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_FP_UNITS { PARAM_VALUE.NUM_FP_UNITS } {
	# Procedure called to validate NUM_FP_UNITS
	return true
}

proc update_PARAM_VALUE.NUM_QUEUES { PARAM_VALUE.NUM_QUEUES } {
	# Procedure called to update NUM_QUEUES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_QUEUES { PARAM_VALUE.NUM_QUEUES } {
	# Procedure called to validate NUM_QUEUES
	return true
}

proc update_PARAM_VALUE.NUM_VARIABLES_POS { PARAM_VALUE.NUM_VARIABLES_POS } {
	# Procedure called to update NUM_VARIABLES_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_VARIABLES_POS { PARAM_VALUE.NUM_VARIABLES_POS } {
	# Procedure called to validate NUM_VARIABLES_POS
	return true
}

proc update_PARAM_VALUE.OPP_CODE_POS { PARAM_VALUE.OPP_CODE_POS } {
	# Procedure called to update OPP_CODE_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OPP_CODE_POS { PARAM_VALUE.OPP_CODE_POS } {
	# Procedure called to validate OPP_CODE_POS
	return true
}

proc update_PARAM_VALUE.PORTS_BITMAP { PARAM_VALUE.PORTS_BITMAP } {
	# Procedure called to update PORTS_BITMAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORTS_BITMAP { PARAM_VALUE.PORTS_BITMAP } {
	# Procedure called to validate PORTS_BITMAP
	return true
}

proc update_PARAM_VALUE.SRC_MAC_POS { PARAM_VALUE.SRC_MAC_POS } {
	# Procedure called to update SRC_MAC_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SRC_MAC_POS { PARAM_VALUE.SRC_MAC_POS } {
	# Procedure called to validate SRC_MAC_POS
	return true
}

proc update_PARAM_VALUE.VECTOR_INDEX_POS { PARAM_VALUE.VECTOR_INDEX_POS } {
	# Procedure called to update VECTOR_INDEX_POS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VECTOR_INDEX_POS { PARAM_VALUE.VECTOR_INDEX_POS } {
	# Procedure called to validate VECTOR_INDEX_POS
	return true
}


proc update_MODELPARAM_VALUE.C_M_AXIS_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXIS_DATA_WIDTH PARAM_VALUE.C_M_AXIS_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXIS_DATA_WIDTH PARAM_VALUE.C_S_AXIS_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_QUEUES { MODELPARAM_VALUE.NUM_QUEUES PARAM_VALUE.NUM_QUEUES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_QUEUES}] ${MODELPARAM_VALUE.NUM_QUEUES}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_BASEADDR { MODELPARAM_VALUE.C_BASEADDR PARAM_VALUE.C_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BASEADDR}] ${MODELPARAM_VALUE.C_BASEADDR}
}

proc update_MODELPARAM_VALUE.SRC_MAC_POS { MODELPARAM_VALUE.SRC_MAC_POS PARAM_VALUE.SRC_MAC_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SRC_MAC_POS}] ${MODELPARAM_VALUE.SRC_MAC_POS}
}

proc update_MODELPARAM_VALUE.DEST_MAC_POS { MODELPARAM_VALUE.DEST_MAC_POS PARAM_VALUE.DEST_MAC_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEST_MAC_POS}] ${MODELPARAM_VALUE.DEST_MAC_POS}
}

proc update_MODELPARAM_VALUE.NEW_DEST_MAC { MODELPARAM_VALUE.NEW_DEST_MAC PARAM_VALUE.NEW_DEST_MAC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NEW_DEST_MAC}] ${MODELPARAM_VALUE.NEW_DEST_MAC}
}

proc update_MODELPARAM_VALUE.PORTS_BITMAP { MODELPARAM_VALUE.PORTS_BITMAP PARAM_VALUE.PORTS_BITMAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORTS_BITMAP}] ${MODELPARAM_VALUE.PORTS_BITMAP}
}

proc update_MODELPARAM_VALUE.NUM_FP_UNITS { MODELPARAM_VALUE.NUM_FP_UNITS PARAM_VALUE.NUM_FP_UNITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_FP_UNITS}] ${MODELPARAM_VALUE.NUM_FP_UNITS}
}

proc update_MODELPARAM_VALUE.FP_DATA_WIDTH { MODELPARAM_VALUE.FP_DATA_WIDTH PARAM_VALUE.FP_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FP_DATA_WIDTH}] ${MODELPARAM_VALUE.FP_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.MY_HEADERS_POS { MODELPARAM_VALUE.MY_HEADERS_POS PARAM_VALUE.MY_HEADERS_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MY_HEADERS_POS}] ${MODELPARAM_VALUE.MY_HEADERS_POS}
}

proc update_MODELPARAM_VALUE.OPP_CODE_POS { MODELPARAM_VALUE.OPP_CODE_POS PARAM_VALUE.OPP_CODE_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OPP_CODE_POS}] ${MODELPARAM_VALUE.OPP_CODE_POS}
}

proc update_MODELPARAM_VALUE.VECTOR_INDEX_POS { MODELPARAM_VALUE.VECTOR_INDEX_POS PARAM_VALUE.VECTOR_INDEX_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VECTOR_INDEX_POS}] ${MODELPARAM_VALUE.VECTOR_INDEX_POS}
}

proc update_MODELPARAM_VALUE.FIN_POS { MODELPARAM_VALUE.FIN_POS PARAM_VALUE.FIN_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIN_POS}] ${MODELPARAM_VALUE.FIN_POS}
}

proc update_MODELPARAM_VALUE.NUM_VARIABLES_POS { MODELPARAM_VALUE.NUM_VARIABLES_POS PARAM_VALUE.NUM_VARIABLES_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_VARIABLES_POS}] ${MODELPARAM_VALUE.NUM_VARIABLES_POS}
}

proc update_MODELPARAM_VALUE.DATA_POS { MODELPARAM_VALUE.DATA_POS PARAM_VALUE.DATA_POS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_POS}] ${MODELPARAM_VALUE.DATA_POS}
}

proc update_MODELPARAM_VALUE.MASTER { MODELPARAM_VALUE.MASTER PARAM_VALUE.MASTER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MASTER}] ${MODELPARAM_VALUE.MASTER}
}

