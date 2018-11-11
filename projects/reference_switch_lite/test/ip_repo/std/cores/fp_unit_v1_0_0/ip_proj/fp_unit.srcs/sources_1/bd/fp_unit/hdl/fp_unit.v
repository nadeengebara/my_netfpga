//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
//Date        : Sun Nov 11 13:26:09 2018
//Host        : PRIME running 64-bit Ubuntu 16.04.5 LTS
//Command     : generate_target fp_unit.bd
//Design      : fp_unit
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "fp_unit,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=fp_unit,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "fp_unit.hwdef" *) 
module fp_unit
   (S_AXIS_0_tdata,
    S_AXIS_0_tvalid,
    S_AXIS_1_tdata,
    S_AXIS_1_tvalid,
    S_AXIS_2_tdata,
    S_AXIS_2_tvalid,
    S_AXIS_3_tdata,
    S_AXIS_3_tvalid,
    aclk,
    dout,
    empty,
    full,
    rd_en,
    srst);
  input [31:0]S_AXIS_0_tdata;
  input S_AXIS_0_tvalid;
  input [31:0]S_AXIS_1_tdata;
  input S_AXIS_1_tvalid;
  input [31:0]S_AXIS_2_tdata;
  input S_AXIS_2_tvalid;
  input [31:0]S_AXIS_3_tdata;
  input S_AXIS_3_tvalid;
  input aclk;
  output [31:0]dout;
  output empty;
  output full;
  input rd_en;
  input srst;

  wire [31:0]S_AXIS_0_1_TDATA;
  wire S_AXIS_0_1_TVALID;
  wire [31:0]S_AXIS_1_1_TDATA;
  wire S_AXIS_1_1_TVALID;
  wire [31:0]S_AXIS_2_1_TDATA;
  wire S_AXIS_2_1_TVALID;
  wire [31:0]S_AXIS_3_1_TDATA;
  wire S_AXIS_3_1_TVALID;
  wire aclk_1;
  wire [31:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_full;
  wire [31:0]floating_point_0_M_AXIS_RESULT_TDATA;
  wire floating_point_0_M_AXIS_RESULT_TVALID;
  wire [31:0]floating_point_1_M_AXIS_RESULT_TDATA;
  wire floating_point_1_M_AXIS_RESULT_TVALID;
  wire [31:0]floating_point_2_m_axis_result_tdata;
  wire floating_point_2_m_axis_result_tvalid;
  wire rd_en_1;
  wire srst_1;

  assign S_AXIS_0_1_TDATA = S_AXIS_0_tdata[31:0];
  assign S_AXIS_0_1_TVALID = S_AXIS_0_tvalid;
  assign S_AXIS_1_1_TDATA = S_AXIS_1_tdata[31:0];
  assign S_AXIS_1_1_TVALID = S_AXIS_1_tvalid;
  assign S_AXIS_2_1_TDATA = S_AXIS_2_tdata[31:0];
  assign S_AXIS_2_1_TVALID = S_AXIS_2_tvalid;
  assign S_AXIS_3_1_TDATA = S_AXIS_3_tdata[31:0];
  assign S_AXIS_3_1_TVALID = S_AXIS_3_tvalid;
  assign aclk_1 = aclk;
  assign dout[31:0] = fifo_generator_0_dout;
  assign empty = fifo_generator_0_empty;
  assign full = fifo_generator_0_full;
  assign rd_en_1 = rd_en;
  assign srst_1 = srst;
  fp_unit_fifo_generator_0_0 fifo_generator_0
       (.clk(aclk_1),
        .din(floating_point_2_m_axis_result_tdata),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .full(fifo_generator_0_full),
        .rd_en(rd_en_1),
        .srst(srst_1),
        .wr_en(floating_point_2_m_axis_result_tvalid));
  fp_unit_floating_point_0_0 floating_point_0
       (.aclk(aclk_1),
        .m_axis_result_tdata(floating_point_0_M_AXIS_RESULT_TDATA),
        .m_axis_result_tvalid(floating_point_0_M_AXIS_RESULT_TVALID),
        .s_axis_a_tdata(S_AXIS_0_1_TDATA),
        .s_axis_a_tvalid(S_AXIS_0_1_TVALID),
        .s_axis_b_tdata(S_AXIS_1_1_TDATA),
        .s_axis_b_tvalid(S_AXIS_1_1_TVALID));
  fp_unit_floating_point_0_1 floating_point_1
       (.aclk(aclk_1),
        .m_axis_result_tdata(floating_point_1_M_AXIS_RESULT_TDATA),
        .m_axis_result_tvalid(floating_point_1_M_AXIS_RESULT_TVALID),
        .s_axis_a_tdata(S_AXIS_2_1_TDATA),
        .s_axis_a_tvalid(S_AXIS_2_1_TVALID),
        .s_axis_b_tdata(S_AXIS_3_1_TDATA),
        .s_axis_b_tvalid(S_AXIS_3_1_TVALID));
  fp_unit_floating_point_1_0 floating_point_2
       (.aclk(aclk_1),
        .m_axis_result_tdata(floating_point_2_m_axis_result_tdata),
        .m_axis_result_tvalid(floating_point_2_m_axis_result_tvalid),
        .s_axis_a_tdata(floating_point_0_M_AXIS_RESULT_TDATA),
        .s_axis_a_tvalid(floating_point_0_M_AXIS_RESULT_TVALID),
        .s_axis_b_tdata(floating_point_1_M_AXIS_RESULT_TDATA),
        .s_axis_b_tvalid(floating_point_1_M_AXIS_RESULT_TVALID));
endmodule
