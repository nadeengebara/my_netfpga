#!/usr/bin/env python

#
# Copyright (c) 2015 University of Cambridge
# Copyright (c) 2015 Neelakandan Manihatty Bojan, Georgina Kalogeridou
# All rights reserved.
#
# This software was developed by Stanford University and the University of Cambridge Computer Laboratory 
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
# Author:
#        Modified by Neelakandan Manihatty Bojan, Georgina Kalogeridou

import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)

from NFTest import *
import sys
import os
from scapy.layers.all import Ether, IP, TCP
from reg_defines_reference_switch_lite import *

phy2loop0 = ('../connections/conn', [])
nftest_init(sim_loop = [], hw_config = [phy2loop0])


if isHW():
   # Clearing the LUT_HIT and LUT_MISS by asserting the reset_counters
 #  nftest_regwrite(SUME_INPUT_ARBITER_0_RESET(), 0x1)
 #  nftest_regwrite(SUME_OUTPUT_PORT_LOOKUP_0_RESET(), 0x101)
 #  nftest_regwrite(SUME_OUTPUT_QUEUES_0_RESET(), 0x1)
   nftest_regwrite(SUME_PSWITCH_PARSER_0_RESET(),0X1)
   nftest_regwrite(SUME_NF_10G_INTERFACE_SHARED_0_RESET(), 0x1)
   nftest_regwrite(SUME_NF_10G_INTERFACE_1_RESET(), 0x1)
#   nftest_regwrite(SUME_NF_10G_INTERFACE_2_RESET(), 0x1)
#   nftest_regwrite(SUME_NF_10G_INTERFACE_3_RESET(), 0x1)
#   nftest_regwrite(SUME_NF_RIFFA_DMA_0_RESET(), 0x1)

   # Reset the switch table lookup counters (value is reset every time is read)
   nftest_regread(SUME_PSWITCH_PARSER_0_PKTOUT_AGG())
   nftest_regread(SUME_PSWITCH_PARSER_0_PKTOUT_OQ())

nftest_start()


routerMAC = []
routerIP = []
for i in range(4):
    routerMAC.append("00:ca:fe:00:00:0%d"%(i+1))
    routerIP.append("192.168.%s.40"%i)

num_oq =5

pkts = []
pkta = []


num_agg =2 

#=3.5

for i in range(num_agg):
    pkt = make_agg_pkt(dst_MAC="aa:bb:cc:dd:ee:ff", src_MAC=routerMAC[1],
                     EtherType=0x8888, pkt_len=100)
 #   pkt=Ether(src="aa:bb:cc:dd:ee:ff",dst="ff:ff:ff:ff:ff:ff")/'\x00\x01'
 
    pkt.time = (((i+5)*(1e-8)) + (2e-6))
    pkta.append(pkt)
#    if isHW():
#    	nftest_send_phy('nf1', pkt)
#    	nftest_expect_phy('nf0', pkt)

if not isHW():
    nftest_send_phy('nf1', pkta)
    nftest_expect_phy('nf3', pkta)

nftest_barrier()



for i in range(num_oq):
    pkt = make_IP_pkt(src_MAC="aa:bb:cc:dd:ee:ff", dst_MAC=routerMAC[0],src_IP="192.168.0.1", dst_IP="192.168.1.1", pkt_len=100)

    pkt.time = ((i*(1e-8)) + (2e-6))
    pkts.append(pkt)
#    if isHW():
#      nftest_send_phy('nf0', pkt)
#        nftest_expect_phy('nf1', pkt)
   
if not isHW():
    nftest_send_phy('nf0', pkts)
    nftest_expect_phy('nf0', pkts)
  #  nftest_expect_phy('nf2', pkts)
  #  nftest_expect_phy('nf3', pkts)

nftest_barrier()


if isHW():
    # Now we expect to see the lut_hit and lut_miss registers incremented and we
    # verify this by doing a regread_expect
    rres1= nftest_regread_expect(SUME_PSWITCH_PARSER_0_PKTOUT_OQ(), num_oq)
#    rres2= nftest_regread_expect(SUME_PSWITCH_PARSER_0_PKTOUT_AGG(), num_agg)
    # List containing the return values of the reg_reads
    mres=[rres1,rres2]
else:
  
    rres0=nftest_regread(SUME_PSWITCH_PARSER_0_PKTIN())	
    rres1= nftest_regread(SUME_PSWITCH_PARSER_0_PKTOUT_OQ())
#    rres2= nftest_regread_expect(SUME_PSWITCH_PARSER_0_PKTOUT_AGG(), num_agg)
    mres=[]

cd="/home/nadeen/SIGCOMM/PANAMA/Vivado/my_netfpga/projects/reference_switch_lite/test"
f=os.path.join(cd,'registervalues.txt')
file=open(f,"w")
file.write("PKTSin= %d \r\n"%rres0)
file.write("PKTSoq= %d \r\n"%rres1)
#file.write("PKTagg= %d \r\n"%rres2)
file.close()



#nftest_finish(mres)



