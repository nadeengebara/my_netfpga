//-
// Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
//
/*******************************************************************************
 *  File:
 *        parser.v
 *
 *  Library:
 *        hw/std/cores/input_arbiter
 *
 *  Module:
 *        parser
 *
 *  Author:
 *        Nadeen Gebara
 * 		
 *  Description:
   Parses bit from HOP to determine whether it should be forwarded to Aggregation pipeline or  Output Queues
   
  
   
   
 *
 */

`timescale 1ns/1ps

module parser
#(
    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=256,
    parameter C_S_AXIS_DATA_WIDTH=256,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
  
    
    // AXI Registers Data Width
    parameter C_S_AXI_DATA_WIDTH    = 32,          
    parameter C_S_AXI_ADDR_WIDTH    = 12,          
    parameter C_BASEADDR            = 32'h00000000,
    
    // PARSING OFFSETS
    parameter ETHER_TYPE_POS        = 96,   //16 Bits
    parameter APP_CODE_POS           = 112, 
    parameter ETHER_TYPE            = 16'h8888,
    parameter APP_CODE           = 2'b01    
)
(
    // Part 1: System side signals
    // Global Ports
    input axis_aclk,
    input axis_resetn,

    // Master Stream Ports to AGGREGATOR 
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_agg_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_agg_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_agg_tuser,
    output m_axis_agg_tvalid,
    input  m_axis_agg_tready,
    output m_axis_agg_tlast,
    
    // Master Stream Ports to OQs
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_OQ_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_OQ_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_OQ_tuser,
    output m_axis_OQ_tvalid,
    input  m_axis_OQ_tready,
    output m_axis_OQ_tlast,

    // Slave Stream Ports (interface to RX queue)
    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_rxq_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_rxq_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_rxq_tuser,
    input  s_axis_rxq_tvalid,
    output s_axis_rxq_tready,
    input  s_axis_rxq_tlast,
    
    // Slave AXI Ports
    input                                     S_AXI_ACLK,
    input                                     S_AXI_ARESETN,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_AWADDR,
    input                                     S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S_AXI_WSTRB,
    input                                     S_AXI_WVALID,
    input                                     S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_ARADDR,
    input                                     S_AXI_ARVALID,
    input                                     S_AXI_RREADY,
    output                                    S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_RDATA,
    output     [1 : 0]                        S_AXI_RRESP,
    output                                    S_AXI_RVALID,
    output                                    S_AXI_WREADY,
    output     [1 :0]                         S_AXI_BRESP,
    output                                    S_AXI_BVALID,
    output                                    S_AXI_AWREADY
    // stats
    //output reg pkt_fwd */

);

 function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
   endfunction // log2

   // ------------ Internal Params --------

    
   localparam NUM_STATES = 3;
   localparam IDLE = 0;
   localparam PARSE_HEADER = 1;
   localparam WRITE_FIRST_BEAT=2;
   localparam WRITE=3;
   localparam CONT_WRITE=4;
   
  
  

   localparam MAX_PKT_SIZE = 2000; // In bytes
   localparam IN_FIFO_DEPTH_BIT = log2(MAX_PKT_SIZE/(C_M_AXIS_DATA_WIDTH / 8));
   localparam FIRST_BEAT_FIFO_DEPTH = log2(MAX_PKT_SIZE/(C_M_AXIS_DATA_WIDTH / 8));

   // ------------- Regs/ wires -----------
   
   // Signals 
   
   //Signals from nf_10g interface
   wire in_rxq_tvalid;
   wire in_rxq_tlast;
   wire [C_M_AXIS_DATA_WIDTH - 1:0]  in_rxq_tdata;
   wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] in_rxq_tkeep;
   wire [C_S_AXIS_TUSER_WIDTH-1:0] in_rxq_tuser;
  
   
   //Signals from fifo
   wire fifo_nearly_full;
   wire fifo_empty;
   wire [C_S_AXIS_TUSER_WIDTH-1:0] fifo_out_tuser;
   wire [C_M_AXIS_DATA_WIDTH - 1:0] fifo_out_tdata;
   wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0]fifo_out_tkeep;
   wire fifo_out_tlast;
   wire fifo_tvalid;
   
   // Signals from OQ and AGGREGATOR
   wire in_OQ_tready;
   wire in_agg_tready;

   //Signal I want
   reg [15:0] ethertype;
   reg [1:0] appcode;
 
   
   
   // Registers
   reg  fifo_rd_en;
   reg  agg_packet;
   reg [NUM_STATES-1:0]                state;
   reg [NUM_STATES-1:0]                state_next;
      
   
   //Modules
   fallthrough_small_fifo
        #( .WIDTH(C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),
           .MAX_DEPTH_BITS(IN_FIFO_DEPTH_BIT))
      in_arb_fifo
        (// Outputs
         .dout                           ({fifo_out_tlast, fifo_out_tuser, fifo_out_tkeep, fifo_out_tdata}),
         .full                           (),
         .nearly_full                    (fifo_nearly_full),
	 .prog_full                      (),
         .empty                          (fifo_empty),
         // Inputs
         .din                            ({in_rxq_tlast, in_rxq_tuser, in_rxq_tkeep, in_rxq_tdata}),
         .wr_en                          (in_rxq_tvalid & ~nearly_full),
         .rd_en                          (fifo_rd_en),
         .reset                          (~axis_resetn),
         .clk                            (axis_aclk));
   
 

 //Logic signal assignments   -- As long as fifo is not almost full, continuously write to it
    
    // Input side
   assign in_rxq_tvalid     = s_axis_rxq_tvalid;
   assign in_rxq_tlast      = s_axis_rxq_tlast;
   assign in_rxq_tdata      = s_axis_rxq_tdata;
   assign in_rxq_tkeep      = s_axis_rxq_tkeep;
   assign in_rxq_tuser      = s_axis_rxq_tuser;
   assign s_axis_rxq_tready = !fifo_nearly_full;
   
   
   //output side

   assign m_axis_agg_tdata = fifo_out_tdata;
   assign m_axis_agg_tkeep = fifo_out_tkeep;
   assign m_axis_agg_tuser = fifo_out_tuser;
   assign m_axis_agg_tlast = fifo_out_tlast;
   assign m_axis_agg_tvalid= agg_packet & ((state==WRITE_FIRST_BEAT) | (~fifo_empty&(state==WRITE | state==CONT_WRITE))) ;
   assign in_agg_tready    = m_axis_agg_tready;
   
   assign m_axis_OQ_tdata = fifo_out_tdata;
   assign m_axis_OQ_tkeep = fifo_out_tkeep;
   assign m_axis_OQ_tuser = fifo_out_tuser;
   assign m_axis_OQ_tlast = fifo_out_tlast;
   assign m_axis_OQ_tvalid= ~agg_packet & ((state==WRITE_FIRST_BEAT) | (~fifo_empty&(state==WRITE | state==CONT_WRITE)));
   assign in_OQ_tready    = m_axis_OQ_tready;
   
 
     

   always @(*) begin
      state_next      = state;
      fifo_rd_en      = 0;
     

      case(state)
        /* cycle between input queues until one is not empty */
        IDLE: begin
        agg_packet=0;
           if(!fifo_empty ) begin
                 state_next = PARSE_HEADER;
                 fifo_rd_en= 1;
           end
        end

       PARSE_HEADER: begin
           /* Determine type of packet */
		            ethertype=fifo_out_tdata[ETHER_TYPE_POS+15:ETHER_TYPE_POS];
                appcode=fifo_out_tdata[APP_CODE_POS+1:APP_CODE_POS];
          
          if(( ethertype==ETHER_TYPE) || (appcode==APP_CODE)) begin  //set to or to work with regular switch. Ideally &&
                     agg_packet=1;      
           end
                  state_next=WRITE_FIRST_BEAT;
        end
        
        WRITE_FIRST_BEAT: begin
          if ( (agg_packet&&in_agg_tready) || (!agg_packet && in_OQ_tready)) begin
                 state_next=WRITE;
          end
        end
        
        WRITE: begin
        if(!fifo_empty) begin
              if((agg_packet&&in_agg_tready) || (!agg_packet && in_OQ_tready)) begin
                 state_next = CONT_WRITE;
                 fifo_rd_en= 1;
          end
        end
      end
         CONT_WRITE: begin
           /* if this is the last word then write it and get out */
        if((agg_packet&&in_agg_tready&&m_axis_agg_tlast) || (!agg_packet&&in_OQ_tready&&m_axis_OQ_tlast)) begin
              state_next = IDLE;
	      fifo_rd_en= 1;
         end
           /* otherwise read and write as usual */
           else if ( ((agg_packet&&in_agg_tready)||(!agg_packet&&in_OQ_tready))&& !fifo_empty) begin
              fifo_rd_en= 1;
           end  
        end

      endcase // case(state)
   end // always @ (*)

   always @(posedge axis_aclk) begin
      if(~axis_resetn) begin
         state <= IDLE;
      end
      else begin
         state <= state_next;
      end
   end



endmodule
