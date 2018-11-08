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
    parameter NEW_DEST_MAC          = 48'hFFFFFFFFFFFF,
    parameter PORTS_BITMAP	    = 4'hF,
    parameter NUM_FP_UNITS          = 2,
    parameter FP_DATA_WIDTH         = 32,
    
    parameter MY_HEADERS_POS        = 272,         
    parameter OPP_CODE_POS          = 274,          //2  Bits
    parameter VECTOR_INDEX_POS      = 276,          //32 Bits
    parameter FIN_POS		    = 308,          //1  Bit
    parameter NUM_VARIABLES	    = 309,          //12 Bits
    parameter DATA_POS		    = 320
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
  );

 
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
   localparam NUM_QUEUES_WIDTH        = log2(NUM_QUEUES);
   localparam IN_FIFO_DEPTH_BIT       = log2(MAX_PKT_SIZE/(C_M_AXIS_DATA_WIDTH / 8));
   localparam HEADERS_OFFSET_INDEX    = MY_HEADERS_POS/C_M_AXIS_DATA_WIDTH;
   localparam DATA_OFFSET_INDEX       = DATA_POS/C_M_AXIS_DATA_WIDTH;     
  
//INPUT SIDE FSM

   localparam  NUM_INPUT_STATES         = 3;
   localparam  IDLE                     = 0;
   localparam  INSPECT_HEADER           = 1;
   localparam  WAIT_BARRIER             = 2;
   localparam  START_AGG                = 3;
   localparam  HANDLE_ERROR             = 4;
   localparam  FLUSH_INPUTS		= 5;
   localparam  BUBBLE_AGG	        = 6;
   localparam  BUBBLE_FLUSH             = 7;

// OUTPUT SIDE FSM

   localparam  NUM_OUT_STATES           = 3;
   localparam  MODIFY_HEADERS           = 0;
   localparam  SEND_HEADERS             = 1;
   localparam  WRITE_OUT_RESULT         = 2;
   localparam  INPUT_SIDE_ERROR         = 3;


//HEADER_REGS
   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]				    tlast_reg[NUM_QUEUES-1:0];
   
  //wires out of headers_regs
   wire[C_M_AXIS_DATA_WIDTH-1:0]                            data_reg_out  [NUM_QUEUES-1:0];
   wire[C_M_AXIS_TUSER_WIDTH-1:0]                           tuser_reg_out [NUM_QUEUES-1:0];
   wire[C_M_AXIS_DATA_WIDTH/8-1:0]			    tkeep_reg_out [NUM_QUEUES-1:0];
   wire[NUM_QUEUES-1:0]					    tlast_reg_out;					    

//FSM REGS
   reg [NUM_INPUT_STATES-1:0]       input_state[NUM_QUEUES-1:0];
   reg [NUM_INPUT_STATES-1:0]       input_state_next[NUM_QUEUES-1:0];

   reg [NUM_OUT_STATES-1:0]         output_agg_state;
   reg [NUM_OUT_STATES-1:0]         output_agg_state_next;


//Metadata FIFO Signals

   wire [NUM_QUEUES-1:0]                 meta_nearly_full;
   wire [NUM_QUEUES-1:0]                 meta_empty;
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  meta_tkeep      [NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       meta_tuser      [NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 meta_tlast;

   wire [C_M_AXIS_TUSER_WIDTH-1:0]       meta_fifo_out_tuser[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  meta_fifo_out_tkeep[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 meta_fifo_out_tlast;
   reg  [NUM_QUEUES-1:0]                 meta_fifo_rd_en;
   reg  [NUM_QUEUES-1:0]                 meta_fifo_wr_en;

//Input Signals from parser

   wire [C_M_AXIS_DATA_WIDTH-1:0]        in_tdata         [NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]  in_tkeep         [NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]       in_tuser         [NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                 in_tvalid;
   wire [NUM_QUEUES-1:0]                 in_tlast;
   reg  [NUM_QUEUES-1:0]		 in_tready;

//Output Signals to OQs
 
   reg  [C_M_AXIS_DATA_WIDTH-1:0]        out_tdata         [NUM_QUEUES-1:0];
   reg  [((C_M_AXIS_DATA_WIDTH/8))-1:0]  out_tkeep         [NUM_QUEUES-1:0];
   reg  [C_M_AXIS_TUSER_WIDTH-1:0]       out_tuser         [NUM_QUEUES-1:0];
   reg  [NUM_QUEUES-1:0]                 out_tvalid;
   reg  [NUM_QUEUES-1:0]                 out_tlast;
   wire [NUM_QUEUES-1:0]		 out_tready;

  					 
   
   
   
        

//Signaling across FSMs
   reg error_message_sent;
   reg done_with_headers;
   reg [31:0] current_vector_index=0;
   reg [31:0] input_vector_index[NUM_QUEUES-1:0];
   
   reg [3:0] input_write_count [NUM_QUEUES-1:0]  = {NUM_QUEUES{4'b0000}};
   reg [3:0] output_write_count [NUM_QUEUES-1:0]  = {NUM_QUEUES{4'b0000}};
        
   reg [NUM_QUEUES-1:0] drop                     = {NUM_QUEUES{1'b0}};
   reg [NUM_QUEUES-1:0] header_verified          = {NUM_QEUES{1'b0}};
   reg [NUM_QUEUES-1:0] start_agg		 = {NUM_QEUES{1'b0}};
   reg [NUM_QUEUES-1:0] send_error_message 	 = {NUM_QEUES{1'b0}};


// Signals to fp_unit
   reg [NUM_QUEUES-1:0]     fp_unit_valid         = {NUM_QEUES{1'b0}};
   reg fp_queue_rd_en        			  = 0;
   wire[FP_DATA_WIDTH-1:0] fp_result [NUM_FP_UNITS-1:0];
   wire[NUM_FP_UNITS-1:0]  fp_queue_empty;

//loop
integer l=0;



generate 
   genvar j;
   for(j=0;j<NUM_FP_UNITS;j=j+1) begin : fp_units
   fp_unit_0 (
  .S_AXIS_A_1_tdata(in_tdata[0][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]),    // input wire from 0
  .S_AXIS_A_1_tvalid(fp_unit_valid[0]),  // input wire S_AXIS_A_1_tvalid
  .S_AXIS_A_tdata(in_tdata[1][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]),       // input wire from 1
  .S_AXIS_A_tvalid(fp_unit_valid[1]),      // input wire S_AXIS_A_tvalid
  .S_AXIS_B_1_tdata(in_tdata[2][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]),    // input wire [31 : 0] S_AXIS_B_1_tdata
  .S_AXIS_B_1_tvalid(fp_unit_valid[2]),  // input wire S_AXIS_B_1_tvalid
  .S_AXIS_B_tdata(in_tdata[3][(j+1)*FP_DATA_WIDTH-1:j*FP_DATA_WIDTH]),        // input wire [31 : 0] S_AXIS_B_tdata
  .S_AXIS_B_tvalid(fp_unit_valid[3]),      // input wire S_AXIS_B_tvalid
  .clock(axis_aclk),                          // input wire clock
  .data_count(),                // output wire [4 : 0] data_count
  .dout(fp_result[j]),                            // output wire [31 : 0] dout
  .empty(fp_queue_empty[j]),                          // output wire empty
  .fifo_srst(~axis_resetn),                  // input wire fifo_srst
  .rd_en(fp_queue_rd_en[j])                          // input wire rd_en
);
end
endgenerate;


//CREATING META DATA FIFO
  generate
  genvar i;
  for(i=0; i<NUM_QUEUES;i=i+1) begin : metadata_queues
	fallthrough_small_fifo
        #( .WIDTH(C_M_AXIS_TUSER_WIDTH+C_M_AXIS_DATA_WIDTH/8+1),.MAX_DEPTH_BITS(IN_FIFO_DEPTH_BIT))
        meta_dp_fifo
        (// Outputs
         .dout                           ({meta_fifo_out_tlast[i],meta_fifo_out_tuser[i], meta_fifo_out_tkeep[i]}),
         .full                           (),
         .nearly_full                    (meta_nearly_full[i]),
         .prog_full                      (),
         .empty                          (meta_empty[i]),
         // Inputs
         .din                            ({meta_tlast[i], meta_tuser[i], meta_tkeep[i]}),
         .wr_en                          (meta_fifo_wr_en[i]),
         .rd_en                          (meta_fifo_rd_en[i]),
         .reset                          (~axis_resetn),
         .clk                            (axis_aclk));
   end

//what signals will impact me header_verified,message_handled
  always @(input_state[i], in_tdata[i],in_tkeep[i],in_tuser[i],in_tlast[i],in_tvalid[i],header_verified[i],error_message_sent,done_with_headers) begin
      input_state_next=input_state;
      start_agg=0;
      send_error_message=0;
      in_tready=0;
      case(input_state[i])
	IDLE: begin 
		header_verified[i]=0;
		    
	if (PORTS_BITMAP[i]==1) begin
        	//write values to header_reg whenever input data is valid
		in_tready[i]=1;
                data_reg[i][(input_write_count[i]+1)*(C_M_AXIS_DATA_WIDTH)-1:(input_write_count[i]*C_M_AXIS_DATA_WIDTH)]=in_tdata[i];                    
                tuser_reg[i][(input_write_count[i]+1)*(C_M_AXIS_TUSER_WIDTH)-1:(input_write_count[i]*C_M_AXIS_TUSER_WIDTH)]=in_tuser[i];                    
                tkeep_reg[i][(input_write_count[i]+1)*(C_M_AXIS_DATA_WIDTH/8)-1:(input_write_count[i]*C_M_AXIS_DATA_WIDTH/8)]=in_tkeep[i];                    
                tlast_reg[i][(input_write_count[i]+1:input_wite_count]=in_tlast[i];                    
		if(input_write_count[i]===DATA_OFFSET_INDEX-1) begin
			input_state_next[i]=INSPECT_HEADER;
			input_write_count[i]=4'b0000;   //will reset write count here for now
		end
		else begin
			input_write_count[i]=input_write_count[i]+1;
                end
            end
        end

	INSPECT_HEADER: begin
	     if (PORTS_BITMAP[i]==1) begin
		input_vector_index=data_reg[VECTOR_INDEX_POS+31:VECTOR_INDEX_POS]
		if(input_vector_index[i]!==current_vector_index) begin
			drop[i]=1;
                end
		else begin 
			drop[i]=0;
                end
		header_verified[i]=0;
		input_state_next[i]=WAIT_BARRIER;
	     end
        end

	WAIT_BARRIER: begin 
		if(header_verified==PORTS_BITMAP) begin
			if(drop!==0) begin
				input_state_next=HANDLE_ERROR
			end
			else begin
				start_agg[i]=1;
				input_state_next=START_AGG;
			end
		end
	end

	HANDLE_ERROR: begin
		send_error_message[i]=1;
		input_state_next=FLUSH_INPUTS;
	end

        FLUSH_INPUTS: begin
		in_tready[i]=1;
		if(in_tvalid[i]==1 && in_tlast[i]==1 && error_message_sent==1) begin
			input_state_next=IDLE;
		end
		else if(in_tlast[i]==1 &&in_tvalid[i]==1) begin
			input_state_next=BUBBLE_FLUSH;
		end
	end

	BUBBLE_FLUSH: begin
		if(error_message_sent==1) begin
			input_state_next=IDLE;
		end
	end

	START_AGG: begin
                if(PORTS_BITMAP[i]==1) begin
		 if(in_tvalid==PORTS_BITMAP && !(meta_nearly_full & PORTS_BITMAP)) begin
		  in_tready[i]=1;
		  meta_fifo_wr_en[i]=1;
		  fp_unit_valid[i]=1;
			if(in_tlast[i] ==1 && done_with_headers) begin
				input_state_next=idle;
			end
			else if (in_tlast[i]==1) begin
				input_state_next[i]=BUBBLE_AGG;
			end
		 end
		end
	end
	
	BUBBLE_AGG: begin
		if(done_with_headers==1) begin
			input_state_next[i]=IDLE;
		end
	end		
    endcase
  end // @always


  always @(posedge axis_clk) begin
	if(~axis_resetn) begin
			input_state[i]<=IDLE;
			//must reset kel regs here
                end
		else begin
                        input_state[i]<=input_state_next[i];
           end
	end



   endgenerate

//OUTPUT SIDE FSM THAT HANDLES AGG
  always @(*) begin

	case(output_agg_state)
	
	MODIFY_HEADERS: begin
		if(start_agg==PORTS_BITMAP) begin
	//	current_vector_index=current_vector_index+1;
		//MODIFY DESTINATION MACS
		for (l = 0; l < NUM_QUEUES; l = l + 1) begin									if(PORTS_BITMAP[l]==1) begin
		      data_reg[l][DEST_MAC_OFFSET+48-1:DEST_MAC_OFFSET]<=NEW_DEST_MAC;
         	   end
      		end
		state_next=SEND_HEADERS;
		end
	 end
		

	SEND_HEADERS: begin
			
		for (l = 0; l < NUM_QUEUES; l = l + 1) begin									if(PORTS_BITMAP[l]==1) begin
	   		out_tdata[l]=data_reg_out[l];
			out_tkeep[l]=tkeep_reg_out;
			out_tuser[l]=tuser_reg_out;
			out_tlast[l]=tlast_reg_out;
			if(output_write_count[l]<DATA_OFFSET_INDEX-1) begin
				out_tvalid[l]=1;
				if(out_tready[l]==1) begin
					output_write_count[l]=output_write_count[l+1];
					data_reg[l]=data_reg[l]>>C_M_AXIS_DATA_WIDTH;
					tkeep_reg[l]=tkeep_reg[l]>>C_M_AXIS_DATA_WIDTH/8;
					tlast_reg[l]=tlast_reg[l]>>1;
					tuser_reg[l]=tuser_reg[l]>>C_M_AXIS_TUSER_WIDTH;
				end
			end
			else begin
				out_tvalid=0;				
				done[l]=1;
			end
		   end
		end
		if(PORTS_BITMAP==done) begin
			done={NUM_QUEUES{4'b0}};
			state_next=
		

// wire                                  fifo_tvalid;
// wire                                  fifo_tlast;
  


 /*  

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
               
*/

// -----------------------Logic Assignment --------------------

/*8 SET VALUE OF s_axis_n_tready  8*/
   assign in_tdata[0]        = s_axis_0_tdata;
   assign in_tkeep[0]        = s_axis_0_tkeep;
   assign in_tuser[0]        = s_axis_0_tuser;
   assign in_tvalid[0]       = s_axis_0_tvalid;
   assign in_tlast[0]        = s_axis_0_tlast;
   assign s_axis_0_tready    = in_tready[0];

   assign meta_tkeep[0]      = s_axis_0_tkeep;
   assign meta_tuser[0]      = s_axis_0_tuser;
   assign meta_tlast[0]      = s_axis_0_tlast;

   assign in_tdata[1]        = s_axis_1_tdata;
   assign in_tkeep[1]        = s_axis_1_tkeep;
   assign in_tuser[1]        = s_axis_1_tuser;
   assign in_tvalid[1]       = s_axis_1_tvalid;
   assign in_tlast[1]        = s_axis_1_tlast;
   assign s_axis_1_tready    = in_tready[1];

   assign in_tdata[2]        = s_axis_2_tdata;
   assign in_tkeep[2]        = s_axis_2_tkeep;
   assign in_tuser[2]        = s_axis_2_tuser;
   assign in_tvalid[2]       = s_axis_2_tvalid;
   assign in_tlast[2]        = s_axis_2_tlast;
   assign s_axis_2_tready    = in_tready[2];

   assign in_tdata[3]        = s_axis_3_tdata;
   assign in_tkeep[3]        = s_axis_3_tkeep;
   assign in_tuser[3]        = s_axis_3_tuser;
   assign in_tvalid[3]       = s_axis_3_tvalid;
   assign in_tlast[3]        = s_axis_3_tlast;
   assign s_axis_3_tready    = in_tready[3];
  
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

  assign data_reg_out[3]     = data_reg[3][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[3]    = tuser_reg[3][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[3]    = tkeep_reg[3][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[3]    = tlast_reg[3][0];


//assigning 


endmodule
