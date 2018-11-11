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
  ipgui::add_param $IPINST -name "MAC_0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAC_1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAC_2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAC_3" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PORTS_BITMAP" -parent ${Page_0}


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

proc update_PARAM_VALUE.MAC_0 { PARAM_VALUE.MAC_0 } {
	# Procedure called to update MAC_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC_0 { PARAM_VALUE.MAC_0 } {
	# Procedure called to validate MAC_0
	return true
}

proc update_PARAM_VALUE.MAC_1 { PARAM_VALUE.MAC_1 } {
	# Procedure called to update MAC_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC_1 { PARAM_VALUE.MAC_1 } {
	# Procedure called to validate MAC_1
	return true
}

proc update_PARAM_VALUE.MAC_2 { PARAM_VALUE.MAC_2 } {
	# Procedure called to update MAC_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC_2 { PARAM_VALUE.MAC_2 } {
	# Procedure called to validate MAC_2
	return true
}

proc update_PARAM_VALUE.MAC_3 { PARAM_VALUE.MAC_3 } {
	# Procedure called to update MAC_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC_3 { PARAM_VALUE.MAC_3 } {
	# Procedure called to validate MAC_3
	return true
}

proc update_PARAM_VALUE.PORTS_BITMAP { PARAM_VALUE.PORTS_BITMAP } {
	# Procedure called to update PORTS_BITMAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORTS_BITMAP { PARAM_VALUE.PORTS_BITMAP } {
	# Procedure called to validate PORTS_BITMAP
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

proc update_MODELPARAM_VALUE.PORTS_BITMAP { MODELPARAM_VALUE.PORTS_BITMAP PARAM_VALUE.PORTS_BITMAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORTS_BITMAP}] ${MODELPARAM_VALUE.PORTS_BITMAP}
}

proc update_MODELPARAM_VALUE.MAC_0 { MODELPARAM_VALUE.MAC_0 PARAM_VALUE.MAC_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC_0}] ${MODELPARAM_VALUE.MAC_0}
}

proc update_MODELPARAM_VALUE.MAC_1 { MODELPARAM_VALUE.MAC_1 PARAM_VALUE.MAC_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC_1}] ${MODELPARAM_VALUE.MAC_1}
}

proc update_MODELPARAM_VALUE.MAC_2 { MODELPARAM_VALUE.MAC_2 PARAM_VALUE.MAC_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC_2}] ${MODELPARAM_VALUE.MAC_2}
}

proc update_MODELPARAM_VALUE.MAC_3 { MODELPARAM_VALUE.MAC_3 PARAM_VALUE.MAC_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC_3}] ${MODELPARAM_VALUE.MAC_3}
}

