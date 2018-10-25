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


// IP VLNV: NetFPGA:NetFPGA:pswitch_parser:1.00
// IP Revision: 1

(* X_CORE_INFO = "parser,Vivado 2016.4" *)
(* CHECK_LICENSE_TYPE = "pswitch_parser_ip,parser,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module pswitch_parser_ip (
  axis_aclk,
  axis_resetn,
  m_axis_agg_tdata,
  m_axis_agg_tkeep,
  m_axis_agg_tuser,
  m_axis_agg_tvalid,
  m_axis_agg_tready,
  m_axis_agg_tlast,
  m_axis_OQ_tdata,
  m_axis_OQ_tkeep,
  m_axis_OQ_tuser,
  m_axis_OQ_tvalid,
  m_axis_OQ_tready,
  m_axis_OQ_tlast,
  s_axis_rxq_tdata,
  s_axis_rxq_tkeep,
  s_axis_rxq_tuser,
  s_axis_rxq_tvalid,
  s_axis_rxq_tready,
  s_axis_rxq_tlast,
  S_AXI_ACLK,
  S_AXI_ARESETN,
  S_AXI_AWADDR,
  S_AXI_AWVALID,
  S_AXI_WDATA,
  S_AXI_WSTRB,
  S_AXI_WVALID,
  S_AXI_BREADY,
  S_AXI_ARADDR,
  S_AXI_ARVALID,
  S_AXI_RREADY,
  S_AXI_ARREADY,
  S_AXI_RDATA,
  S_AXI_RRESP,
  S_AXI_RVALID,
  S_AXI_WREADY,
  S_AXI_BRESP,
  S_AXI_BVALID,
  S_AXI_AWREADY
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axis_aclk CLK" *)
input wire axis_aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axis_resetn RST" *)
input wire axis_resetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_agg TDATA" *)
output wire [255 : 0] m_axis_agg_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_agg TKEEP" *)
output wire [31 : 0] m_axis_agg_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_agg TUSER" *)
output wire [127 : 0] m_axis_agg_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_agg TVALID" *)
output wire m_axis_agg_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_agg TREADY" *)
input wire m_axis_agg_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_agg TLAST" *)
output wire m_axis_agg_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_OQ TDATA" *)
output wire [255 : 0] m_axis_OQ_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_OQ TKEEP" *)
output wire [31 : 0] m_axis_OQ_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_OQ TUSER" *)
output wire [127 : 0] m_axis_OQ_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_OQ TVALID" *)
output wire m_axis_OQ_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_OQ TREADY" *)
input wire m_axis_OQ_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_OQ TLAST" *)
output wire m_axis_OQ_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_rxq TDATA" *)
input wire [255 : 0] s_axis_rxq_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_rxq TKEEP" *)
input wire [31 : 0] s_axis_rxq_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_rxq TUSER" *)
input wire [127 : 0] s_axis_rxq_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_rxq TVALID" *)
input wire s_axis_rxq_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_rxq TREADY" *)
output wire s_axis_rxq_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_rxq TLAST" *)
input wire s_axis_rxq_tlast;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S_AXI_ACLK CLK" *)
input wire S_AXI_ACLK;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S_AXI_ARESETN RST" *)
input wire S_AXI_ARESETN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
input wire [11 : 0] S_AXI_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
input wire S_AXI_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
input wire [31 : 0] S_AXI_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
input wire [3 : 0] S_AXI_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
input wire S_AXI_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
input wire S_AXI_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
input wire [11 : 0] S_AXI_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
input wire S_AXI_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
input wire S_AXI_RREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
output wire S_AXI_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
output wire [31 : 0] S_AXI_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
output wire [1 : 0] S_AXI_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
output wire S_AXI_RVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
output wire S_AXI_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
output wire [1 : 0] S_AXI_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
output wire S_AXI_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
output wire S_AXI_AWREADY;

  parser #(
    .C_M_AXIS_DATA_WIDTH(256),
    .C_S_AXIS_DATA_WIDTH(256),
    .C_M_AXIS_TUSER_WIDTH(128),
    .C_S_AXIS_TUSER_WIDTH(128),
    .C_S_AXI_DATA_WIDTH(32),
    .C_S_AXI_ADDR_WIDTH(12),
    .C_BASEADDR(32'H00000000),
    .ETHER_TYPE_POS(96),
    .APP_CODE_POS(112),
    .ETHER_TYPE(16'H8888),
    .APP_CODE(2'B01)
  ) inst (
    .axis_aclk(axis_aclk),
    .axis_resetn(axis_resetn),
    .m_axis_agg_tdata(m_axis_agg_tdata),
    .m_axis_agg_tkeep(m_axis_agg_tkeep),
    .m_axis_agg_tuser(m_axis_agg_tuser),
    .m_axis_agg_tvalid(m_axis_agg_tvalid),
    .m_axis_agg_tready(m_axis_agg_tready),
    .m_axis_agg_tlast(m_axis_agg_tlast),
    .m_axis_OQ_tdata(m_axis_OQ_tdata),
    .m_axis_OQ_tkeep(m_axis_OQ_tkeep),
    .m_axis_OQ_tuser(m_axis_OQ_tuser),
    .m_axis_OQ_tvalid(m_axis_OQ_tvalid),
    .m_axis_OQ_tready(m_axis_OQ_tready),
    .m_axis_OQ_tlast(m_axis_OQ_tlast),
    .s_axis_rxq_tdata(s_axis_rxq_tdata),
    .s_axis_rxq_tkeep(s_axis_rxq_tkeep),
    .s_axis_rxq_tuser(s_axis_rxq_tuser),
    .s_axis_rxq_tvalid(s_axis_rxq_tvalid),
    .s_axis_rxq_tready(s_axis_rxq_tready),
    .s_axis_rxq_tlast(s_axis_rxq_tlast),
    .S_AXI_ACLK(S_AXI_ACLK),
    .S_AXI_ARESETN(S_AXI_ARESETN),
    .S_AXI_AWADDR(S_AXI_AWADDR),
    .S_AXI_AWVALID(S_AXI_AWVALID),
    .S_AXI_WDATA(S_AXI_WDATA),
    .S_AXI_WSTRB(S_AXI_WSTRB),
    .S_AXI_WVALID(S_AXI_WVALID),
    .S_AXI_BREADY(S_AXI_BREADY),
    .S_AXI_ARADDR(S_AXI_ARADDR),
    .S_AXI_ARVALID(S_AXI_ARVALID),
    .S_AXI_RREADY(S_AXI_RREADY),
    .S_AXI_ARREADY(S_AXI_ARREADY),
    .S_AXI_RDATA(S_AXI_RDATA),
    .S_AXI_RRESP(S_AXI_RRESP),
    .S_AXI_RVALID(S_AXI_RVALID),
    .S_AXI_WREADY(S_AXI_WREADY),
    .S_AXI_BRESP(S_AXI_BRESP),
    .S_AXI_BVALID(S_AXI_BVALID),
    .S_AXI_AWREADY(S_AXI_AWREADY)
  );
endmodule
