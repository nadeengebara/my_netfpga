//
// Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
//
/*******************************************************************************
 *  File:
 *        parser.v
 *
 *  Library:
 *        hw/std/cores/parser
 *
 *  Module:
 *        parser
 *
 *  Author:
 *        Nadeen Gebara
 * 		
 *  Description:
    Parser that determines the appropriate datapath to which packets are to be forwarded based on the EtherType and/or APPCODE
        
 *
 */


`timescale 1ns/1ps

module fp_adder
#(
FP_DATA_WIDTH=32


)
(
    // Part 1: System side signals
    // Global Ports
    input aclk,
    input srst,

    // Master Stream Ports to AGGREGATOR 
    input [FP_DATA_WIDTH - 1:0] S_AXIS_0_tdata,
    input S_AXIS_0_tvalid,
    input [FP_DATA_WIDTH - 1:0] S_AXIS_1_tdata,
    input S_AXIS_1_tvalid,
    input [FP_DATA_WIDTH - 1:0] S_AXIS_2_tdata,
    input S_AXIS_2_tvalid,
    input [FP_DATA_WIDTH - 1:0] S_AXIS_3_tdata,
    input S_AXIS_3_tvalid,
    output [FP_DATA_WIDTH-1:0] dout,
    output empty,
    output full,
    input rd_en

);


//Instantiations

//signals

  wire [FP_DATA_WIDTH-1:0] fp0_result;
  wire 			   fp0_result_valid;
  wire [FP_DATA_WIDTH-1:0] fp1_result;
  wire			   fp1_result_valid;
  wire [FP_DATA_WIDTH-1:0] fp2_result; 
  wire 			   fp2_result_valid;




axi_fp_unit fp_unit_0 (
    .s_axis_a_tdata        (S_AXIS_0_tdata),
    .s_axis_a_tvalid       (S_AXIS_0_tvalid),
    .s_axis_b_tdata        (S_AXIS_1_tdata),
    .s_axis_b_tvalid       (S_AXIS_1_tvalid),
    .m_axis_result_tdata   (fp0_result),
    .m_axis_result_tvalid  (fp0_result_valid),
    .aclk                  (aclk)
);

axi_fp_unit fp_unit_1 (
    .s_axis_a_tdata        (S_AXIS_1_tdata),
    .s_axis_a_tvalid       (S_AXIS_1_tvalid),
    .s_axis_b_tdata        (S_AXIS_2_tdata),
    .s_axis_b_tvalid       (S_AXIS_2_tvalid),
    .m_axis_result_tdata   (fp1_result),
    .m_axis_result_tvalid  (fp1_result_valid),
    .aclk                  (aclk)
);

axi_fp_unit fp_unit_2 (
    .s_axis_a_tdata        (fp0_result),
    .s_axis_a_tvalid       (fp0_result_valid),
    .s_axis_b_tdata        (fp1_result),
    .s_axis_b_tvalid       (fp1_result_valid),
    .m_axis_result_tdata   (fp2_result),
    .m_axis_result_tvalid  (fp2_result_valid),
    .aclk                  (aclk)
);


result_fifo result_fifo_0 (
    .full                  (full),
    .din                   (fp2_result),
    .wr_en                 (fp2_result_valid),
    .empty                 (empty),
    .dout                  (dout),
    .rd_en                 (rd_en),
    .clk                   (aclk),
    .srst                  (srst)
);

endmodule
