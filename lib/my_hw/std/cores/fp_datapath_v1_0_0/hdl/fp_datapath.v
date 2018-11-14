/*******************************************************************************
 *  File:
 *        fp_datapath.v
 *
 *  Library:
 *        my_hw/std/cores/fp_datapath
 *
 *  Module:
 *        fp_datapath
 *
 *  Author:
 *        Nadeen Gebara
 *
 *  Description:
 *        Aggregates inputs of specified input ports.
 *        (if we use destination mac of last switch from beginning, no need to change anything. But for sake of the demo, destination MAC must be overwritten).
 *
 */

//`include "input_arbiter_cpu_regs_defines.v"

`timescale 1ns/1ps

module fp_datapath
#(
    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=64,
    parameter C_S_AXIS_DATA_WIDTH=64,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter NUM_QUEUES=4,

    // AXI Registers Data Width
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 12,
    parameter C_BASEADDR            = 32'h00000000,

    parameter SRC_MAC_POS           = 48,
    parameter DEST_MAC_POS          = 0,
    parameter NEW_DEST_MAC          = 48'hFFFFFFFFFFFF,
    parameter PORTS_BITMAP	    = 4'b0011,
    parameter NUM_FP_UNITS          = 2,
    parameter FP_DATA_WIDTH         = 32,
    
    parameter MY_HEADERS_POS        = 272,         
    parameter OPP_CODE_POS          = 274,          //2  Bits
    parameter VECTOR_INDEX_POS      = 276,          //32 Bits
    parameter FIN_POS		    = 308,          //1  Bit
    parameter NUM_VARIABLES_POS     = 309,          //12 Bits
    parameter DATA_POS		    = 320,

    parameter MASTER		    =0
    //parameter SRC_MAC_0		    = 48'h0253554d4500,
    //parameter SRC_MAC_1		    = 48'h0253554d4501,
    //parameter SRC_MAC_2		    = 48'h0253554d4502,
    //parameter SRC_MAC_3		    = 48'h0253554d4503

)

(
 // Part 1: System side signals
    // Global Ports
    input axis_aclk,
    input axis_resetn,

//Input to AGG from PARSER
    
    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_0_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_0_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_0_tuser,
    input  s_axis_0_tvalid,
    output s_axis_0_tready,
    input  s_axis_0_tlast,

    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_1_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_1_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_1_tuser,
    input  s_axis_1_tvalid,
    output s_axis_1_tready,
    input  s_axis_1_tlast,

    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_2_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_2_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_2_tuser,
    input  s_axis_2_tvalid,
    output s_axis_2_tready,
    input  s_axis_2_tlast,

    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_3_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_3_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_3_tuser,
    input  s_axis_3_tvalid,
    output s_axis_3_tready,
    input  s_axis_3_tlast,



    // Master Stream Ports to output queues
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_0_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_0_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_0_tuser,
    output m_axis_0_tvalid,
    input  m_axis_0_tready,
    output m_axis_0_tlast,
    
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_1_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_1_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_1_tuser,
    output m_axis_1_tvalid,
    input  m_axis_1_tready,
    output m_axis_1_tlast,

    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_2_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_2_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_2_tuser,
    output m_axis_2_tvalid,
    input  m_axis_2_tready,
    output m_axis_2_tlast,
    
    output [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_3_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_3_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_3_tuser,
    output m_axis_3_tvalid,
    input  m_axis_3_tready,
    output m_axis_3_tlast

   // Register Interface

   // Slave AXI Ports
/*
No register interface for now
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
    output                                    S_AXI_AWREADY,
*/
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

   //computation states
 

 
//   localparam HEADER_REG_SIZE= C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1;
   
/*
********************************************************8 
 MAC and IP headers up to bit 271 --> My defined headers start at bit 272
 Since my minimum bus width is 64, and total header bits=48
 The headers will be in the same FIFO entry, independent of bus width
Width    FIFO Index:bits     //Indexing starts at 1
  64  -->  4:256-320 
  128 -->  3:256-384
  256 -->  2:256-512
  512 -->  1:0-511
********************************************************8
*/
  
   localparam MAX_PKT_SIZE            = 1600  ;
   localparam NUM_QUEUES_WIDTH        = log2(NUM_QUEUES);
   localparam IN_FIFO_DEPTH_BIT       = log2(MAX_PKT_SIZE/(C_M_AXIS_DATA_WIDTH / 8));
   localparam DATA_OFFSET_INDEX       = DATA_POS/C_M_AXIS_DATA_WIDTH;
//INPUT SIDE FSM

   localparam  NUM_INPUT_STATES         = 2;
   localparam  IDLE                     = 0;
   localparam  INSPECT_MODIFY_HEADER    = 1;
   localparam  FSM_START_AGG            = 2;
   localparam  BUBBLE_AGG	            = 3;

// OUTPUT SIDE FSM

   localparam  NUM_OUT_STATES           = 1;
   localparam  SEND_HEADER              = 0;
   localparam  WRITE_OUT_RESULT         = 1;


//Input Signals from parser

   wire [C_M_AXIS_DATA_WIDTH-1:0]        		    in_tdata[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]                     in_tkeep[NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]                          in_tuser[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                                    in_tvalid;
   wire [NUM_QUEUES-1:0]                                    in_tlast;

//Signals of Input FIFOs
   wire [C_S_AXIS_TUSER_WIDTH-1:0]                          in_fifo_out_tuser[NUM_QUEUES-1:0];
   wire [C_M_AXIS_DATA_WIDTH-1:0]                           in_fifo_out_tdata[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]                     in_fifo_out_tkeep[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]		                    in_fifo_out_tlast;
   wire [NUM_QUEUES-1:0]		                    in_fifo_nearly_full; 
   wire [NUM_QUEUES-1:0]		                    in_fifo_empty;
   reg  [NUM_QUEUES-1:0]	                            in_fifo_rd_en;


//HEADER_REGS
   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]				    tlast_reg[NUM_QUEUES-1:0];

   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg_next [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg_next[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg_next[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]				    tlast_reg_next[NUM_QUEUES-1:0];

   
  //wires out of headers_regs
   wire[C_M_AXIS_DATA_WIDTH-1:0]                            data_reg_out  [NUM_QUEUES-1:0];
   wire[C_M_AXIS_TUSER_WIDTH-1:0]                           tuser_reg_out [NUM_QUEUES-1:0];
   wire[C_M_AXIS_DATA_WIDTH/8-1:0]			    tkeep_reg_out [NUM_QUEUES-1:0];
   wire[NUM_QUEUES-1:0]					    tlast_reg_out;					    

//FSM REGS
   reg [NUM_INPUT_STATES-1:0]                               input_state[NUM_QUEUES-1:0];
   reg [NUM_INPUT_STATES-1:0]                               input_state_next[NUM_QUEUES-1:0];

   reg [NUM_OUT_STATES-1:0]                                 output_agg_state[NUM_QUEUES-1:0];
   reg [NUM_OUT_STATES-1:0]                                 output_agg_state_next[NUM_QUEUES-1:0];

   reg [31:0] 						    current_vector_index=0;          //keeps track of vector count
   reg [31:0]                                               input_vector_index[NUM_QUEUES-1:0];
   
   reg [3:0] input_write_count [NUM_QUEUES-1:0]  = {{4'b0000},{4'b0000},{4'b0000},{4'b0000}};
   reg [3:0] input_write_count_next [NUM_QUEUES-1:0]  = {{4'b0000},{4'b0000},{4'b0000},{4'b0000}};

   reg [NUM_QUEUES-1:0] start_agg		 = 0;
   reg [NUM_QUEUES-1:0] start_agg_next		 = 0;
   reg [3:0] output_write_count [NUM_QUEUES-1:0]  = {{4'b0000},{4'b0000},{4'b0000},{4'b0000}};
   reg [3:0] output_write_count_next [NUM_QUEUES-1:0]  = {{4'b0000},{4'b0000},{4'b0000},{4'b0000}};


//FP UNIT
   reg [NUM_QUEUES-1:0]             fp_valid;
   wire[FP_DATA_WIDTH-1:0]          fp_dout[NUM_FP_UNITS-1:0];
   wire[NUM_FP_UNITS-1:0]           fp_empty;
   reg [NUM_QUEUES-1:0]   	    fp_rd_en;
   wire[FP_DATA_WIDTH-1:0]          fp_axis_0_data[NUM_FP_UNITS-1:0];
   wire[FP_DATA_WIDTH-1:0]          fp_axis_1_data[NUM_FP_UNITS-1:0];
   wire[FP_DATA_WIDTH-1:0]          fp_axis_2_data[NUM_FP_UNITS-1:0];
   wire[FP_DATA_WIDTH-1:0]          fp_axis_3_data[NUM_FP_UNITS-1:0];

//Metadata FIFO Signals

   wire [NUM_QUEUES-1:0]                 meta_nearly_full;
   wire [NUM_QUEUES-1:0]                 meta_empty;

   wire [C_M_AXIS_TUSER_WIDTH-1:0]       meta_fifo_out_tuser[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  meta_fifo_out_tkeep[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 meta_fifo_out_tlast;
   reg  [NUM_QUEUES-1:0]                 meta_fifo_rd_en;
   reg  [NUM_QUEUES-1:0]                 meta_fifo_wr_en;

//Output Signals to OQs Module
   reg  [C_M_AXIS_DATA_WIDTH-1:0]        out_tdata         [NUM_QUEUES-1:0];
   reg  [((C_M_AXIS_DATA_WIDTH/8))-1:0]  out_tkeep         [NUM_QUEUES-1:0];
   reg  [C_M_AXIS_TUSER_WIDTH-1:0]       out_tuser         [NUM_QUEUES-1:0];
   reg  [NUM_QUEUES-1:0]                 out_tvalid;
   reg  [NUM_QUEUES-1:0]                 out_tlast;
   wire [NUM_QUEUES-1:0]		 out_tready;
   wire [NUM_FP_UNITS-1:0]               full;
  	
   wire debug_agg_state;
   				 
  generate
  genvar j;
  for(j=0; j<NUM_FP_UNITS;j=j+1) begin: fp_unit
  
   fp_adder_ip fp_adder_j(
  .S_AXIS_0_tdata(fp_axis_0_data[j] & {FP_DATA_WIDTH{PORTS_BITMAP[0]}}),    // input wire from 0
  .S_AXIS_0_tvalid(!(~fp_valid&PORTS_BITMAP)),  // input wire S_AXIS_A_1_tvalid
  .S_AXIS_1_tdata(fp_axis_1_data[j] & {FP_DATA_WIDTH{PORTS_BITMAP[1]}}),       // input wire from 1
  .S_AXIS_1_tvalid(!(~fp_valid&PORTS_BITMAP)),      // input wire S_AXIS_A_tvalid
  .S_AXIS_2_tdata(fp_axis_2_data[j] & {FP_DATA_WIDTH{PORTS_BITMAP[2]}}),    // input wire [31 : 0] S_AXIS_B_1_tdata
  .S_AXIS_2_tvalid(!(~fp_valid&PORTS_BITMAP)),  // input wire S_AXIS_B_1_tvalid
  .S_AXIS_3_tdata(fp_axis_3_data[j] & {FP_DATA_WIDTH{PORTS_BITMAP[3]}}),        // input wire [31 : 0] S_AXIS_B_tdata
  .S_AXIS_3_tvalid(!(~fp_valid&PORTS_BITMAP)),      // input wire S_AXIS_B_tvalid
  .aclk(axis_aclk),                          // input wire clock
  .dout(fp_dout[j]),                            // output wire [31 : 0] dout
  .empty(fp_empty[j]),                          // output wire empty
  .rd_en(!(PORTS_BITMAP&~fp_rd_en)),                          // input wire rd_en
  .full(full),
  .srst(~axis_resetn)                  // input wire fifo_srst
);

 assign fp_axis_0_data[j]= {<<8{in_fifo_out_tdata[0][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]}};
 assign fp_axis_1_data[j]= {<<8{in_fifo_out_tdata[1][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]}};
 assign fp_axis_2_data[j]= {<<8{in_fifo_out_tdata[2][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]}};
 assign fp_axis_3_data[j]= {<<8{in_fifo_out_tdata[3][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]}};

end
endgenerate
 
//CREATING META DATA FIFO
  generate
  genvar i;
  for(i=0; i<NUM_QUEUES;i=i+1) begin: queues
     fallthrough_small_fifo
        #( .WIDTH(C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),
           .MAX_DEPTH_BITS(IN_FIFO_DEPTH_BIT))
      input_fifo
        (// Outputs
         .dout                           ({in_fifo_out_tlast[i], in_fifo_out_tuser[i], in_fifo_out_tkeep[i], in_fifo_out_tdata[i]}),
         .full                           (),
         .nearly_full                    (in_fifo_nearly_full[i]),
         .prog_full                      (),
         .empty                          (in_fifo_empty[i]),
         // Inputs
         .din                            ({in_tlast[i], in_tuser[i], in_tkeep[i], in_tdata[i]}),
         .wr_en                          (in_tvalid[i] & ~in_fifo_nearly_full[i]),
         .rd_en                          (in_fifo_rd_en[i]),
         .reset                          (~axis_resetn),
         .clk                            (axis_aclk));
	

        fallthrough_small_fifo
        #(.WIDTH(C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),.MAX_DEPTH_BITS(IN_FIFO_DEPTH_BIT))
        meta_dp_fifo
        (// Outputs
         .dout                           ({meta_fifo_out_tlast[i],meta_fifo_out_tuser[i], meta_fifo_out_tkeep[i]}),
         .full                           (),
         .nearly_full                    (meta_nearly_full[i]),
         .prog_full                      (),
         .empty                          (meta_empty[i]),
         .din                            ({in_fifo_out_tlast[i], in_fifo_out_tuser[i], in_fifo_out_tkeep[i]}),
         .wr_en                          (meta_fifo_wr_en[i]),
         .rd_en                          (meta_fifo_rd_en[i]),
         .reset                          (~axis_resetn),
         .clk                            (axis_aclk));
  

  always @(in_fifo_empty,in_fifo_out_tdata[i],in_fifo_out_tkeep[i],in_fifo_out_tuser[i],in_fifo_out_tlast[i],input_state[i],meta_nearly_full,start_agg[i]) begin
      
      input_state_next[i]=input_state[i];
      in_fifo_rd_en[i]=0; 
      meta_fifo_wr_en[i]=0;
      fp_valid[i]=0;
      data_reg_next[i] =data_reg[i];
      tkeep_reg_next[i]=tkeep_reg[i];
      tlast_reg_next[i]=tlast_reg[i];
      tuser_reg_next[i]=tuser_reg[i];
      start_agg_next[i]=start_agg[i]; 
      input_write_count_next[i]=input_write_count[i];
	case(input_state[i])
	 



     IDLE: begin
          if(PORTS_BITMAP[i]==1) begin
	      if (!(in_fifo_empty&PORTS_BITMAP)) begin
        	//write values to header_reg whenever input data is valid
	        if(input_write_count[i]==DATA_OFFSET_INDEX) begin
		    input_state_next[i]=INSPECT_MODIFY_HEADER;
		    input_write_count_next[i]=4'b0000;   //will reset write count here for now
//		    in_fifo_rd_en[i]=1;
		    
                end
                else begin
		    data_reg_next[i]={in_fifo_out_tdata[i],data_reg[i] [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:C_M_AXIS_DATA_WIDTH]};                    
                    tuser_reg_next[i]={in_fifo_out_tuser[i],tuser_reg[i][C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:C_M_AXIS_TUSER_WIDTH]};                    
                    tkeep_reg_next[i]={in_fifo_out_tkeep[i],tkeep_reg[i][C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:C_M_AXIS_DATA_WIDTH/8]};                    
                    tlast_reg_next[i]={in_fifo_out_tlast[i],tlast_reg[i][3:1]};                    
	            input_write_count_next[i]=input_write_count[i]+1;
		    in_fifo_rd_en[i]=1;
                end
               end
          end
        end

//only come here when  everyone else comes
    INSPECT_MODIFY_HEADER: begin
	 if(PORTS_BITMAP[i]==1 & !(PORTS_BITMAP&meta_nearly_full)) begin
	       data_reg_next[i][DEST_MAC_POS+48-1:DEST_MAC_POS]=NEW_DEST_MAC;
	       start_agg_next[i]=1;
	       input_state_next[i]=FSM_START_AGG;
               fp_valid[i]=1;
               in_fifo_rd_en[i]=1;
               meta_fifo_wr_en[i]=1;
	       if(i==MASTER) begin
		 if(data_reg[i][FIN_POS]==1) begin
			current_vector_index=0;
		end
		else begin
			current_vector_index=current_vector_index+1;
		end
		end
	   end
	end
	
	FSM_START_AGG: begin
	if (!(PORTS_BITMAP&meta_nearly_full)) begin          //come here only if PORTS_BITMAP=1	  
		in_fifo_rd_en[i]=1;
	        fp_valid[i]=1;
         	meta_fifo_wr_en[i]=1;	
		if(in_fifo_out_tlast[i]==1) begin
 				if(!start_agg[i]) begin
				  input_state_next[i]=IDLE;
			        end
				else begin
				input_state_next[i]=BUBBLE_AGG;
			        end
			end
		 end
	end
	
	BUBBLE_AGG: begin
		if(start_agg[i]==0) begin
			input_state_next[i]=IDLE;
		end
	end		
    endcase
  end // @always
  
//OUTPUT SIDE FSM THAT HANDLES AGG
  always @(output_agg_state[i],out_tready[i],start_agg[i],output_write_count[i],fp_empty,fp_dout,meta_fifo_out_tlast[i],meta_empty) begin
    data_reg_next[i] =data_reg[i];
    tkeep_reg_next[i]=tkeep_reg[i];
    tlast_reg_next[i]=tlast_reg[i];
    tuser_reg_next[i]=tuser_reg[i];
    fp_rd_en[i]=0; 
    out_tvalid[i]=0;
    meta_fifo_rd_en[i]=0;
    output_agg_state_next[i]=output_agg_state[i];
    start_agg_next[i]=start_agg[i];	
    output_write_count_next[i]=output_write_count[i];      
  
        case(output_agg_state[i])
	SEND_HEADER: begin
        // if(((PORTS_BITMAP[i] & start_agg[i])==1) && !(PORTS_BITMAP&~start_agg)) begin 
	   if((PORTS_BITMAP[i] & start_agg[i])==1) begin 
             if(output_write_count[i]<=DATA_OFFSET_INDEX) begin
		  out_tdata[i] = data_reg_out[i];
		  out_tkeep[i] = tkeep_reg_out[i];
                  out_tlast[i] = tlast_reg_out[i];
                  out_tuser[i] = tuser_reg_out[i];
		  out_tvalid[i]= 1;
		  if(out_tready[i]==1) begin
		   output_write_count_next[i]=output_write_count[i]+1; 
                   data_reg_next[i]=data_reg[i]>>C_M_AXIS_DATA_WIDTH;
		   tkeep_reg_next[i]=tkeep_reg[i]>>C_M_AXIS_DATA_WIDTH/8;
		   tlast_reg_next[i]=tlast_reg[i]>>1;
		   tuser_reg_next[i]=tuser_reg[i]>>C_M_AXIS_TUSER_WIDTH;	  
		end
               output_agg_state_next[i]=SEND_HEADER; 
               end
               else begin
			output_write_count_next[i]=0;
	        	start_agg_next[i]=0;
			output_agg_state_next[i]=WRITE_OUT_RESULT;
			
		end           	   
	  end
	end
				
/*8 NOTE: FIFO FROM FP in fallthrough mode   8*/
	 
	WRITE_OUT_RESULT: begin
	   		out_tdata[i]={fp_dout[1],fp_dout[0]};
			out_tkeep[i]=meta_fifo_out_tkeep[i];
			out_tuser[i]=meta_fifo_out_tuser[i];
			out_tlast[i]=meta_fifo_out_tlast[i];
			if(!(PORTS_BITMAP&~(out_tready)) && !(|fp_empty) && (!(PORTS_BITMAP&meta_empty))) begin //took out dependency on meta empty
				out_tvalid[i]=1;
				fp_rd_en[i]=1;
				meta_fifo_rd_en[i]=1;
				if(out_tlast[i]==1) begin
					output_agg_state_next[i]=SEND_HEADER;
				end
			end
				
			end
		   endcase
		end //always



//what signals will impact me header_verified,message_handled


  always @(posedge axis_aclk) begin
	if(~axis_resetn) begin
		input_state[i]<=IDLE;
		output_agg_state[i]<=SEND_HEADER;		
        input_write_count[i]<=0;
		output_write_count[i]<=0; 
		out_tvalid[i]<=0;
        fp_valid[i]<=0;
        fp_rd_en[i]<=0;
         start_agg[i]<=0;
		in_fifo_rd_en<=0;
                
	//must reset kel regs here
     end
  else begin
     		data_reg[i]        <=data_reg_next[i];
    		tkeep_reg[i]       <=tkeep_reg_next[i];
    		tlast_reg[i]       <=tlast_reg_next[i];
            tuser_reg[i]       <=tuser_reg_next[i];
            input_state[i]     <=input_state_next[i];
	    output_agg_state[i]<=output_agg_state_next[i];
            start_agg[i]<=start_agg_next[i];
            output_write_count[i]<=output_write_count_next[i];
	    input_write_count[i]<=input_write_count_next[i];
           end
	end
  end
 endgenerate


// -----------------------Logic Assignment --------------------

/*8 SET VALUE OF s_axis_n_tready  8*/
   assign in_tdata[0]        = s_axis_0_tdata;
   assign in_tkeep[0]        = s_axis_0_tkeep;
   assign in_tuser[0]        = s_axis_0_tuser;
   assign in_tvalid[0]       = s_axis_0_tvalid;
   assign in_tlast[0]        = s_axis_0_tlast;
   assign s_axis_0_tready    =!in_fifo_nearly_full [0];


   assign in_tdata[1]        = s_axis_1_tdata;
   assign in_tkeep[1]        = s_axis_1_tkeep;
   assign in_tuser[1]        = s_axis_1_tuser;
   assign in_tvalid[1]       = s_axis_1_tvalid;
   assign in_tlast[1]        = s_axis_1_tlast;
   assign s_axis_1_tready    = !in_fifo_nearly_full[1];

   assign in_tdata[2]        = s_axis_2_tdata;
   assign in_tkeep[2]        = s_axis_2_tkeep;
   assign in_tuser[2]        = s_axis_2_tuser;
   assign in_tvalid[2]       = s_axis_2_tvalid;
   assign in_tlast[2]        = s_axis_2_tlast;
   assign s_axis_2_tready    = !in_fifo_nearly_full[2];

   assign in_tdata[3]        = s_axis_3_tdata;
   assign in_tkeep[3]        = s_axis_3_tkeep;
   assign in_tuser[3]        = s_axis_3_tuser;
   assign in_tvalid[3]       = s_axis_3_tvalid;
   assign in_tlast[3]        = s_axis_3_tlast;
   assign s_axis_3_tready    = !in_fifo_nearly_full[3];
  
//assigning values to signal outputs from regs

  assign data_reg_out[0]     = data_reg[0][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[0]    = tuser_reg[0][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[0]    = tkeep_reg[0][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[0]    = tlast_reg[0][0];
 
  assign data_reg_out[1]     = data_reg[1][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[1]    = tuser_reg[1][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[1]    = tkeep_reg[1][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[1]    = tlast_reg[1][0];

  assign data_reg_out[2]     = data_reg[2][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[2]    = tuser_reg[2][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[2]    = tkeep_reg[2][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[2]    = tlast_reg[2][0];

  assign m_axis_3_tdata      = data_reg[3][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[3]    = tuser_reg[3][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[3]    = tkeep_reg[3][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[3]    = tlast_reg[3][0];

  assign m_axis_0_tdata      = out_tdata[0];
  assign m_axis_0_tuser      = out_tuser[0];
  assign m_axis_0_tkeep      = out_tkeep[0];
  assign m_axis_0_tvalid     = out_tvalid[0];
  assign m_axis_0_tlast      = out_tlast[0];
  assign out_tready[0]       = m_axis_0_tready;  

  assign m_axis_1_tdata      = out_tdata[1];
  assign m_axis_1_tkeep      = out_tkeep[1];
  assign m_axis_1_tuser      = out_tuser[1];
  assign m_axis_1_tvalid     = out_tvalid[1];
  assign m_axis_1_tlast      = out_tlast[1];
  assign out_tready[1]       = m_axis_1_tready;  


  assign m_axis_2_tdata      = out_tdata[2];
  assign m_axis_2_tkeep      = out_tkeep[2];
  assign m_axis_2_tuser      = out_tuser[2];
  assign m_axis_2_tvalid     = out_tvalid[2];
  assign m_axis_2_tlast      = out_tlast[2];
  assign out_tready[2]       = m_axis_2_tready;  

  assign m_axis_3_tdata      = out_tdata[3];
  assign m_axis_3_tkeep      = out_tkeep[3];
  assign m_axis_3_tuser      = out_tuser[3];
  assign m_axis_3_tvalid     = out_tvalid[3];
  assign m_axis_3_tlast      = out_tlast[3];
  assign out_tready[3]       = m_axis_3_tready;  

  assign debug_agg_state     =(!(in_fifo_empty&PORTS_BITMAP) && !(PORTS_BITMAP&meta_nearly_full))==1?1:0;
endmodule
