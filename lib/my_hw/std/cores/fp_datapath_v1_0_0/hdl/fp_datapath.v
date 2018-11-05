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
module fp_datapath
#(
    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=256,
    parameter C_S_AXIS_DATA_WIDTH=256,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter NUM_QUEUES=4,

    // AXI Registers Data Width
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 12,
    parameter C_BASEADDR            = 32'h00000000,

    parameter SRC_MAC_OFFSET        = 48,
    parameter DEST_MAC_OFFSET       = 0,
    parameter NEW_DEST_MAC          = 48'hFFFFFFFFFFFF
    parameter PORTS_BITMAP	    = 4'hF
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
    output m_axis_3_tlast,

   // Register Interface

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
    output                                    S_AXI_AWREADY,

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
   
   localparam  NUM_QUEUES_WIDTH = log2(NUM_QUEUES);
   localparam HEADER_REG_SIZE= C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1;
   
   localparam  NUM_STATES = 3;
   localparam  IDLE       = 0;
   localparam  READ_1     = 1;
   localparam  AGGREGATE  = 2;
   localparam  ERR        = 3;

//Input FIFO SIgnals

   wire [NUM_QUEUES-1:0]                 in_nearly_full;
   wire [NUM_QUEUES-1:0]                 in_empty;
   wire [C_M_AXIS_DATA_WIDTH-1:0]        in_tdata      [NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  in_tkeep      [NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       in_tuser      [NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 in_tvalid;
   wire [NUM_QUEUES-1:0]                 in_tlast;
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       in_fifo_out_tuser[NUM_QUEUES-1:0];
   wire [C_M_AXIS_DATA_WIDTH-1:0]        in_fifo_out_tdata[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  in_fifo_out_tkeep[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 in_fifo_out_tlast;
   reg [NUM_QUEUES-1:0]                  in_fifo_rd_en;

// wire                                  fifo_tvalid;
// wire                                  fifo_tlast;
  


//Metadata FIFO Signals

   wire [NUM_QUEUES-1:0]                 meta_nearly_full;
   wire [NUM_QUEUES-1:0]                 meta_empty;
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  meta_tkeep      [NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       meta_tuser      [NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 meta_tvalid;
   wire [NUM_QUEUES-1:0]                 meta_tlast;
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       meta_fifo_out_tuser[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  meta_fifo_out_tkeep[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 meta_fifo_out_tlast;
   reg  [NUM_QUEUES-1:0]                  meta_fifo_rd_en;


//SIMPLIFICATIONS FOR REG

   wire [NUM_QUEUES-1:0] reg_tlast_0;  
   wire [NUM_QUEUES-1:0] reg_tlast_1;
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  reg_0_tkeep      [NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       reg_0_tuser      [NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  reg_1_tkeep      [NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       reg_1_tuser      [NUM_QUEUES-1:0];
   wire [C_M_AXIS_DATA_WIDTH-1:0]        in_fifo_out_tdata[NUM_QUEUES-1:0];
   wire [C_M_AXIS_DATA_WIDTH-1:0]        in_fifo_out_tdata[NUM_QUEUES-1:0];

  



   //My declared signals & regs
   wire					 data_ready; //indicates that portmap matches fifo not empty
   reg [11 downto 0] 			 frame_count;

   reg state,state_next;
   
   reg [HEADER_REG_SIZE-1:0] header_reg [NUM_QUEUES-1:0];

  generate
  genvar i;
  for(i=0; i<NUM_QUEUES;i=i+1) begin : datapath_in_queues
	fallthrough_small_fifo
        #( .WIDTH(C_M_AXIS_DATA_WIDTH+C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),.MAX_DEPTH_BITS(IN_FIFO_DEPTH_BIT))
        in_dp_fifo
        (// Outputs
         .dout                           ({in_fifo_out_tlast[i], in_fifo_out_tuser[i], in_fifo_out_tkeep[i], fifo_out_tdata[i]}),
         .full                           (),
         .nearly_full                    (in_nearly_full[i]),
         .prog_full                      (),
         .empty                          (in_empty[i]),
         // Inputs
         .din                            ({in_tlast[i], in_tuser[i], in_tkeep[i], in_tdata[i]}),
         .wr_en                          (in_tvalid[i] & ~in_nearly_full[i]),
         .rd_en                          (in_fifo_rd_en[i]),
         .reset                          (~axis_resetn),
         .clk                            (axis_aclk));
   end
   endgenerate
               

  generate
  genvar i;
  for(i=0; i<NUM_QUEUES;i=i+1) begin : metadata_queues
	fallthrough_small_fifo
        #( .WIDTH(C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),.MAX_DEPTH_BITS(IN_FIFO_DEPTH_BIT))
        in_dp_fifo
        (// Outputs
         .dout                           ({meta_fifo_out_tlast[i],meta_fifo_out_tuser[i], meta_fifo_out_tkeep[i]}),
         .full                           (),
         .nearly_full                    (meta_nearly_full[i]),
         .prog_full                      (),
         .empty                          (meta_empty[i]),
         // Inputs
         .din                            ({meta_tlast[i], meta_tuser[i], meta_tkeep[i]}),
         .wr_en                          (in_tvalid[i] & ~nearly_full[i]),
         .rd_en                          (meta_fifo_rd_en[i]),
         .reset                          (~axis_resetn),
         .clk                            (axis_aclk));
   end
   endgenerate


// -----------------------Logic Assignment --------------------


   assign in_tdata[0]        = s_axis_0_tdata;
   assign in_tkeep[0]        = s_axis_0_tkeep;
   assign in_tuser[0]        = s_axis_0_tuser;
   assign in_tvalid[0]       = s_axis_0_tvalid;
   assign in_tlast[0]        = s_axis_0_tlast;
   assign s_axis_0_tready    = !in_nearly_full[0];

   assign in_tdata[1]        = s_axis_1_tdata;
   assign in_tkeep[1]        = s_axis_1_tkeep;
   assign in_tuser[1]        = s_axis_1_tuser;
   assign in_tvalid[1]       = s_axis_1_tvalid;
   assign in_tlast[1]        = s_axis_1_tlast;
   assign s_axis_1_tready    = !in_nearly_full[1];

   assign in_tdata[2]        = s_axis_2_tdata;
   assign in_tkeep[2]        = s_axis_2_tkeep;
   assign in_tuser[2]        = s_axis_2_tuser;
   assign in_tvalid[2]       = s_axis_2_tvalid;
   assign in_tlast[2]        = s_axis_2_tlast;
   assign s_axis_2_tready    = !in_nearly_full[2];

   assign in_tdata[3]        = s_axis_3_tdata;
   assign in_tkeep[3]        = s_axis_3_tkeep;
   assign in_tuser[3]        = s_axis_3_tuser;
   assign in_tvalid[3]       = s_axis_3_tvalid;
   assign in_tlast[3]        = s_axis_3_tlast;
   assign s_axis_3_tready    = !in_nearly_full[3];
  
   assign data_ready = (~in_empty ==  PORTS_BITMAP) & (PORTS_BITMAP !==h'0);


  always @ (*) begin
      state_next=state;
      in_rd_en=h'0;     

	case(state)

          IDLE: begin
		if(data_ready==1) begin
	          header_reg[0]<={in_fifo_out_tlast[0], in_fifo_out_tuser[0], in_fifo_out_tkeep[0], fifo_out_tdata[0]};
                  header_reg[1]<={in_fifo_out_tlast[1], in_fifo_out_tuser[1], in_fifo_out_tkeep[1], fifo_out_tdata[1]};
                  header_reg[2]<={in_fifo_out_tlast[2], in_fifo_out_tuser[2], in_fifo_out_tkeep[2], fifo_out_tdata[2]};
                  header_reg[3]<={in_fifo_out_tlast[3], in_fifo_out_tuser[3], in_fifo_out_tkeep[3], fifo_out_tdata[3]};
		in_rd_en<=PORTS_BITMAP;
		state_next<=READ_1;
	       end
         end

         READ_1:begin


	end

     endcase

  end  




	always @(posedge axis_clk) begin
		if(~axis_resetn) begin
			state<=IDLE;
			frame_count<=0;
                end
		else begin
                        state<=state_next;
                end 
        end

endmodule
