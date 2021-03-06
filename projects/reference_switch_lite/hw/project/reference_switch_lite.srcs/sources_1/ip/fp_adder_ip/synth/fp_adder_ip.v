// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: NetFPGA:NetFPGA:fp_adder:1.00
// IP Revision: 1

(* X_CORE_INFO = "fp_adder,Vivado 2016.4" *)
(* CHECK_LICENSE_TYPE = "fp_adder_ip,fp_adder,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module fp_adder_ip (
  aclk,
  srst,
  S_AXIS_0_tdata,
  S_AXIS_0_tvalid,
  S_AXIS_1_tdata,
  S_AXIS_1_tvalid,
  S_AXIS_2_tdata,
  S_AXIS_2_tvalid,
  S_AXIS_3_tdata,
  S_AXIS_3_tvalid,
  dout,
  empty,
  full,
  rd_en
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
input wire srst;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TDATA" *)
input wire [31 : 0] S_AXIS_0_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TVALID" *)
input wire S_AXIS_0_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_1 TDATA" *)
input wire [31 : 0] S_AXIS_1_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_1 TVALID" *)
input wire S_AXIS_1_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_2 TDATA" *)
input wire [31 : 0] S_AXIS_2_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_2 TVALID" *)
input wire S_AXIS_2_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_3 TDATA" *)
input wire [31 : 0] S_AXIS_3_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_3 TVALID" *)
input wire S_AXIS_3_tvalid;
output wire [31 : 0] dout;
output wire empty;
output wire full;
input wire rd_en;

  fp_adder #(
    .FP_DATA_WIDTH(32)
  ) inst (
    .aclk(aclk),
    .srst(srst),
    .S_AXIS_0_tdata(S_AXIS_0_tdata),
    .S_AXIS_0_tvalid(S_AXIS_0_tvalid),
    .S_AXIS_1_tdata(S_AXIS_1_tdata),
    .S_AXIS_1_tvalid(S_AXIS_1_tvalid),
    .S_AXIS_2_tdata(S_AXIS_2_tdata),
    .S_AXIS_2_tvalid(S_AXIS_2_tvalid),
    .S_AXIS_3_tdata(S_AXIS_3_tdata),
    .S_AXIS_3_tvalid(S_AXIS_3_tvalid),
    .dout(dout),
    .empty(empty),
    .full(full),
    .rd_en(rd_en)
  );
endmodule
