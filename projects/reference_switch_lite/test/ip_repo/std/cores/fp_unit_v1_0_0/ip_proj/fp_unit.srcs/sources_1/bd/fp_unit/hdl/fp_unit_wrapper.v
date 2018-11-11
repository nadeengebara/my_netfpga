//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
//Date        : Sun Nov 11 13:26:09 2018
//Host        : PRIME running 64-bit Ubuntu 16.04.5 LTS
//Command     : generate_target fp_unit_wrapper.bd
//Design      : fp_unit_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module fp_unit_wrapper
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

  wire [31:0]S_AXIS_0_tdata;
  wire S_AXIS_0_tvalid;
  wire [31:0]S_AXIS_1_tdata;
  wire S_AXIS_1_tvalid;
  wire [31:0]S_AXIS_2_tdata;
  wire S_AXIS_2_tvalid;
  wire [31:0]S_AXIS_3_tdata;
  wire S_AXIS_3_tvalid;
  wire aclk;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire srst;

  fp_unit fp_unit_i
       (.S_AXIS_0_tdata(S_AXIS_0_tdata),
        .S_AXIS_0_tvalid(S_AXIS_0_tvalid),
        .S_AXIS_1_tdata(S_AXIS_1_tdata),
        .S_AXIS_1_tvalid(S_AXIS_1_tvalid),
        .S_AXIS_2_tdata(S_AXIS_2_tdata),
        .S_AXIS_2_tvalid(S_AXIS_2_tvalid),
        .S_AXIS_3_tdata(S_AXIS_3_tdata),
        .S_AXIS_3_tvalid(S_AXIS_3_tvalid),
        .aclk(aclk),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_en(rd_en),
        .srst(srst));
endmodule
