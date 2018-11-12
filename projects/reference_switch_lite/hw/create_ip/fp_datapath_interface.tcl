create_ip -name fp_adder -vendor NetFPGA -library NetFPGA -module_name fp_adder_ip
set_property generate_synth_checkpoint false [get_files fp_adder_ip.xci]
reset_target all [get_ips fp_adder_ip]
generate_target all [get_ips fp_adder_ip]

