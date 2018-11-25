//FSMD Design
//Avoided the use of combinational signalling. Everything is updated with the clock
//IGNORED CASE WHEN PORT BITMAP IS NOT 1 FOR NOW
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
    parameter PORTS_BITMAP          = 4'b0011,
    parameter NUM_FP_UNITS          = 2,
    parameter FP_DATA_WIDTH         = 32,

    parameter MY_HEADERS_POS        = 272,
    parameter OPP_CODE_POS          = 274,          //2  Bits
    parameter VECTOR_INDEX_POS      = 276,          //32 Bits
    parameter FIN_POS               = 308,          //1  Bit
    parameter NUM_VARIABLES_POS     = 309,          //12 Bits
    parameter DATA_POS              = 320,

    parameter MASTER                =0
    //parameter SRC_MAC_0                   = 48'h0253554d4500,
    //parameter SRC_MAC_1                   = 48'h0253554d4501,
    //parameter SRC_MAC_2                   = 48'h0253554d4502,
    //parameter SRC_MAC_3                   = 48'h0253554d4503

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
);

   function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
   endfunction 
   
   localparam MAX_PKT_SIZE            = 1600  ;
   localparam NUM_QUEUES_WIDTH        = log2(NUM_QUEUES);
   localparam IN_FIFO_DEPTH_BIT       = log2(MAX_PKT_SIZE/(C_M_AXIS_DATA_WIDTH / 8));
   localparam DATA_OFFSET_INDEX       = DATA_POS/C_M_AXIS_DATA_WIDTH;

   //INPUT SIDE FSM

   localparam  NUM_INPUT_STATES         = 3;
   localparam  IDLE                     = 0;
   localparam  INSPECT_MODIFY_HEADER    = 1;
   localparam  FSM_AGG                  = 2;
   localparam  BUBBLE_AGG               = 3;
   localparam  FORWARD_OUT_RESULT       = 4;
   localparam  INPUT_ERROR              = 5;  //SIMPLY DROP PACKETS

// OUTPUT SIDE FSM (DO I REALLY NEED THIS ?)

   localparam  NUM_OUT_STATES           = 2;
   localparam  IDLE_OUT                 = 0;
   localparam  SEND_HEADER              = 1;
   localparam  WRITE_OUT_RESULT         = 2;
   
   
   
//HEADER_REGS
   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]                              tlast_reg[NUM_QUEUES-1:0];

   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg_next [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg_next[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg_next[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]                              tlast_reg_next[NUM_QUEUES-1:0];
   
   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg_output [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg_output[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg_output[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]                              tlast_reg_output[NUM_QUEUES-1:0];
 
   reg [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:0]          data_reg_output_next [NUM_QUEUES-1:0];
   reg [C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:0]         tuser_reg_output_next[NUM_QUEUES-1:0];
   reg [C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:0]        tkeep_reg_output_next[NUM_QUEUES-1:0];
   reg [DATA_OFFSET_INDEX-1:0]                              tlast_reg_output_next[NUM_QUEUES-1:0];
    


//FSM REGS
   reg [NUM_INPUT_STATES-1:0]           input_state[NUM_QUEUES-1:0];
   reg [NUM_INPUT_STATES-1:0]           input_state_next[NUM_QUEUES-1:0];

   reg [NUM_OUT_STATES-1:0]             output_agg_state[NUM_QUEUES-1:0];
   reg [NUM_OUT_STATES-1:0]             output_agg_state_next[NUM_QUEUES-1:0];

//Internal book keeping regs
   reg [31:0]                           current_vector_index[NUM_QUEUES-1:0]; //keeps track of vector count
   reg [31:0]                           current_vector_index_next[NUM_QUEUES-1:0];

   reg [31:0]                           input_vector_index[NUM_QUEUES-1:0];

   reg [3:0]                            input_write_count [NUM_QUEUES-1:0];
   reg [3:0]                            input_write_count_next [NUM_QUEUES-1:0];

   reg [NUM_QUEUES-1:0]                 start_agg;
   reg [NUM_QUEUES-1:0]                 start_agg_next;
   
  reg [NUM_QUEUES-1:0]                 header_error;
  reg [NUM_QUEUES-1:0]                 header_error_next;

  reg [NUM_QUEUES-1:0]                 done_with_headers;
  reg [NUM_QUEUES-1:0]                 done_with_headers_next;

   reg [3:0]                            output_write_count [NUM_QUEUES-1:0] ;
   reg [3:0]                            output_write_count_next [NUM_QUEUES-1:0];

   wire                                 correct_headers;
   wire                                 wrong_headers;
   wire                                 agg_write_out;
   reg [NUM_QUEUES-1:0]                 error;


// Actual Connectivity Wires   

//Input Signals from parser

   wire [C_M_AXIS_DATA_WIDTH-1:0]                           in_tdata[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]                     in_tkeep[NUM_QUEUES-1:0];
   wire [C_M_AXIS_TUSER_WIDTH-1:0]                          in_tuser[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                                    in_tvalid;
   wire [NUM_QUEUES-1:0]                                    in_tlast;

//Signals of Input FIFOs
   wire [C_S_AXIS_TUSER_WIDTH-1:0]                          in_fifo_out_tuser[NUM_QUEUES-1:0];
   wire [C_M_AXIS_DATA_WIDTH-1:0]                           in_fifo_out_tdata[NUM_QUEUES-1:0];
   wire [((C_M_AXIS_DATA_WIDTH/8))-1:0]                     in_fifo_out_tkeep[NUM_QUEUES-1:0];
   wire [NUM_QUEUES-1:0]                                    in_fifo_out_tlast;
   wire [NUM_QUEUES-1:0]                                    in_fifo_nearly_full;
   wire [NUM_QUEUES-1:0]                                    in_fifo_empty;
   reg [NUM_QUEUES-1:0]                                     in_fifo_rd_en;
 //  reg [NUM_QUEUES-1:0] 				    delayed_fifo_empty;

  
// Signals of FP UNIT
//FP UNIT
  //regs (might change to fp_rd_en to a wire)
   reg [NUM_QUEUES-1:0]             fp_valid;
   wire[NUM_QUEUES-1:0]            fp_rd_en;

//wires
   wire[FP_DATA_WIDTH-1:0]          fp_dout[NUM_FP_UNITS-1:0];
   wire[NUM_FP_UNITS-1:0]           fp_empty;
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

   wire  [NUM_QUEUES-1:0]                 meta_fifo_rd_en;
   reg  [NUM_QUEUES-1:0]                 meta_fifo_wr_en;
   
//rd_en might become a wire as well


//Output Signals to OQs Module
   reg  [C_M_AXIS_DATA_WIDTH-1:0]        out_tdata         [NUM_QUEUES-1:0];
   reg  [((C_M_AXIS_DATA_WIDTH/8))-1:0]  out_tkeep         [NUM_QUEUES-1:0];
   reg  [C_M_AXIS_TUSER_WIDTH-1:0]       out_tuser         [NUM_QUEUES-1:0];

 
   reg  [NUM_QUEUES-1:0]                 out_tlast;
   wire [NUM_QUEUES-1:0]                 out_tready;
   wire [NUM_FP_UNITS-1:0]               full;
   wire  [NUM_QUEUES-1:0]                out_tvalid;
   
    //wires out of headers_regs
     wire[C_M_AXIS_DATA_WIDTH-1:0]                            data_reg_out  [NUM_QUEUES-1:0];
     wire[C_M_AXIS_TUSER_WIDTH-1:0]                           tuser_reg_out [NUM_QUEUES-1:0];
     wire[C_M_AXIS_DATA_WIDTH/8-1:0]                tkeep_reg_out [NUM_QUEUES-1:0];
     wire[NUM_QUEUES-1:0]                        tlast_reg_out;                

   //  reg[NUM_QUEUES-1:0]  toggle;
//Data Path Logic Signal Assignments:
   assign  wrong_headers   = !((PORTS_BITMAP)&~(header_error));  //header_error gets updated with clock
   assign  correct_headers = !((PORTS_BITMAP)&~(start_agg));     // start_agg updated with clock
   assign  agg_write_out   = !(PORTS_BITMAP&~(out_tready)) && !(|fp_empty) && (!(PORTS_BITMAP&meta_empty)); //all these signals are synchornous
  
  
  // FP UNIT
  
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
  .dout({<<8{fp_dout[j]}}),                            // output wire [31 : 0] dout
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

//CREATING META DATA FIFO and input fifo
  generate
  genvar i;
  for(i=0; i<NUM_QUEUES;i=i+1) begin: my_queues
  
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

                                                      

always @(in_fifo_empty,meta_nearly_full,input_write_count[i],data_reg[i],in_fifo_out_tdata[i],in_fifo_out_tkeep[i],in_fifo_out_tuser[i],in_fifo_out_tlast[i],input_state[i],correct_headers,out_tready[i])begin

  input_write_count_next[i]=input_write_count[i];
  data_reg_next[i]=data_reg[i];
  start_agg_next[i]=start_agg[i];
  header_error_next[i]=header_error[i];
  current_vector_index_next[i]=current_vector_index[i];
  
  fp_valid[i]=0;
  meta_fifo_wr_en[i]=0;
  in_fifo_rd_en[i]=0;
  error[i]=0;
    
  case(input_state[i])
    
    //Only write headers to header regs when available by all participating ports. Problem arises when
    //I don't get data from one of the ports
        IDLE: begin
          //Reset values
          start_agg_next[i]=0;
          header_error_next[i]=0;
	  
          //if a port is participating in agg, wait until other packets are received and update headers reg.
          if (PORTS_BITMAP[i]==1 && (!(in_fifo_empty&PORTS_BITMAP))) begin
            if (input_write_count[i]<DATA_OFFSET_INDEX) begin
              data_reg_next [i]={in_fifo_out_tdata[i],data_reg[i] [C_M_AXIS_DATA_WIDTH*DATA_OFFSET_INDEX-1:C_M_AXIS_DATA_WIDTH]};
              tuser_reg_next[i]={in_fifo_out_tuser[i],tuser_reg[i][C_M_AXIS_TUSER_WIDTH*DATA_OFFSET_INDEX-1:C_M_AXIS_TUSER_WIDTH]};
              tkeep_reg_next[i]={in_fifo_out_tkeep[i],tkeep_reg[i][C_M_AXIS_DATA_WIDTH/8*DATA_OFFSET_INDEX-1:C_M_AXIS_DATA_WIDTH/8]};
              tlast_reg_next[i]={in_fifo_out_tlast[i],tlast_reg[i][3:1]};
              input_write_count_next[i]=input_write_count[i]+1;
              in_fifo_rd_en[i]=1;
            end 
            else begin
            input_write_count_next[i]=0;
            end
          end
          //for now, if either portsbitmap is 1 or it is 0 and criteria of available headers not met, do nothing
    end //IDLE
    
    INSPECT_MODIFY_HEADER: begin            //I ONLY COME HERE IF I AM PARTICIPATING IN AGG
        input_vector_index[i] ={<<8{data_reg[i][VECTOR_INDEX_POS+31:VECTOR_INDEX_POS]}};
        if (input_vector_index[i]==current_vector_index[i]) begin
          data_reg_next[i][DEST_MAC_POS+48-1:DEST_MAC_POS]<=NEW_DEST_MAC;
          start_agg_next[i]=1;
          if(correct_headers==1) begin
            current_vector_index_next[i]=current_vector_index[i]+1;
          end
        end
        else begin
          header_error_next[i]=1;
        end;
    end //INSPECT_MODIFY_HEADER

    
    FSM_AGG: begin
      if(!(in_fifo_empty&PORTS_BITMAP)  && !(PORTS_BITMAP&meta_nearly_full)) begin
        fp_valid[i]=1;
        meta_fifo_wr_en[i]=1;
        in_fifo_rd_en[i]=1;
      end
      else begin
        fp_valid[i]=0;
        meta_fifo_wr_en[i]=0;
        in_fifo_rd_en[i]=0;
      end
    end
    
    BUBBLE_AGG: begin
        fp_valid[i]=0;
        meta_fifo_wr_en[i]=0;
        in_fifo_rd_en[i]=0;
    end
    
    FORWARD_OUT_RESULT: begin
        if(!(in_fifo_empty[i])&&out_tready[i]) begin
        in_fifo_rd_en[i]=1;
        end
    end
    
    INPUT_ERROR:begin
     error[i]=1;
     in_fifo_rd_en[i]=1;
    end
     
    default: begin
    
    end
      
  endcase
end  //@always        
          
          
          
//NSL
          
always @(input_state[i],input_write_count[i],correct_headers,wrong_headers,in_fifo_out_tlast[i],done_with_headers[i]) begin

  input_state_next[i]=input_state[i];
 
  
  case(input_state[i])
  
    IDLE: begin
       if (PORTS_BITMAP[i]==1 && input_write_count[i]==DATA_OFFSET_INDEX) begin   //if i'm done writing regs, got to inspect modify headers
        input_state_next[i]=INSPECT_MODIFY_HEADER;
       end
       else if (PORTS_BITMAP[i]==0 && !(in_fifo_empty[i])) begin  //I just need to forward out this result.
        input_state_next[i]=FORWARD_OUT_RESULT;
        end
      end //IDLE
    
    INSPECT_MODIFY_HEADER: begin    //wait until it has been determined whether header is correct or wrong
      if(correct_headers==1) begin
        input_state_next[i]=FSM_AGG;
      end
      else if (wrong_headers==1) begin
        input_state_next[i]=INPUT_ERROR;
      end
    end
    
    FSM_AGG: begin
      if(in_fifo_out_tlast[i]==1) begin
        if(done_with_headers[i]==1) begin
          input_state_next[i]=IDLE;
        end
        else begin
          input_state_next[i]=BUBBLE_AGG;
        end
      end
    end
    
    BUBBLE_AGG: begin
      if(done_with_headers[i]==1) begin
          input_state_next[i]=IDLE;
      end
    end
    
    FORWARD_OUT_RESULT:begin
      if(in_fifo_out_tlast[i]==1) begin
          input_state_next[i]=IDLE;
      end
     end
    
    default:begin
    end
    

  endcase
end  
   
      
   
//WRITE FSM  

always @(output_agg_state[i],output_write_count[i],meta_fifo_out_tlast[i],data_reg[i],tlast_reg[i],tkeep_reg[i],tuser_reg[i],out_tready[i],fp_dout) begin
    
    data_reg_output_next[i] =data_reg_output[i];
    tkeep_reg_output_next[i]=tkeep_reg_output[i];
    tlast_reg_output_next[i]=tlast_reg_output[i];
    tuser_reg_output_next[i]=tuser_reg_output[i];
    done_with_headers_next[i]=done_with_headers[i];
    output_write_count_next[i]=output_write_count[i]; 
    
    
    case(output_agg_state[i])

        IDLE_OUT: begin
         done_with_headers_next[i]=0;
         data_reg_output_next[i]  = data_reg[i];
         tkeep_reg_output_next[i] = tkeep_reg[i];
         tlast_reg_output_next[i] = tlast_reg[i];
         tuser_reg_output_next[i] = tuser_reg[i];
         out_tdata[i] = 0;
         out_tkeep[i] = 0;
         out_tlast[i] = 0;
         out_tuser[i] = 0;
         end
         
      SEND_HEADER: begin
        out_tdata[i] = data_reg_out[i];
        out_tkeep[i] = tkeep_reg_out[i];
        out_tlast[i] = tlast_reg_out[i];
        out_tuser[i] = tuser_reg_out[i];
        
          if (out_tready[i]==1) begin
            output_write_count_next[i]=output_write_count[i]+1;
            data_reg_output_next[i]=data_reg_output[i]>>C_M_AXIS_DATA_WIDTH;
            tkeep_reg_output_next[i]=tkeep_reg_output[i]>>C_M_AXIS_DATA_WIDTH/8;
            tlast_reg_output_next[i]=tlast_reg_output[i]>>1;
            tuser_reg_output_next[i]=tuser_reg_output[i]>>C_M_AXIS_TUSER_WIDTH;
            if(output_write_count[i]==DATA_OFFSET_INDEX-1) begin
               output_write_count_next[i]=0;
               done_with_headers_next[i]=1;
             end
        
	  end
       end
      
      
      WRITE_OUT_RESULT: begin
        out_tdata[i]={fp_dout[1],fp_dout[0]};
        out_tkeep[i]=meta_fifo_out_tkeep[i];
        out_tuser[i]=meta_fifo_out_tuser[i];
        out_tlast[i]=meta_fifo_out_tlast[i];
        if(meta_fifo_out_tlast[i] && out_tvalid[i] && agg_write_out==1) begin
            done_with_headers_next[i]=0;
          end
        end
    endcase
  end //always
           

//NSL
always @(output_agg_state[i],output_write_count[i],out_tready[i],correct_headers,wrong_headers,meta_fifo_out_tlast[i],agg_write_out,out_tvalid[i]) begin

  output_agg_state_next[i]=output_agg_state[i];
  
  case(output_agg_state[i])
  
      IDLE_OUT: begin
        if((PORTS_BITMAP[i]==1) && (correct_headers==1)) begin
          output_agg_state_next[i]=SEND_HEADER;
        end
      end

      SEND_HEADER: begin
        if(output_write_count[i]==DATA_OFFSET_INDEX-1 && out_tready[i]==1) begin
          output_agg_state_next[i]=WRITE_OUT_RESULT;
        end
      end
      
      WRITE_OUT_RESULT:begin
        if(meta_fifo_out_tlast[i] && out_tvalid[i] && agg_write_out==1) begin
            output_agg_state_next[i]=IDLE;
        end
      end
    endcase
 end
 
  always @(posedge axis_aclk) begin
    if(~axis_resetn) begin
        input_state[i]<=IDLE;
        output_agg_state[i]<=IDLE_OUT;
        input_write_count[i]<=0;
        output_write_count[i]<=0;
        start_agg[i]<=0;
        done_with_headers[i]<=0;
        current_vector_index[i]<=0;
	//delayed_fifo_empty<=4'hf;
    end
     else begin
        data_reg[i]           <= data_reg_next[i];
        tkeep_reg[i]          <= tkeep_reg_next[i];
        tlast_reg[i]          <= tlast_reg_next[i];
        tuser_reg[i]          <= tuser_reg_next[i];
        data_reg_output[i]    <= data_reg_output_next[i];
        tkeep_reg_output[i]   <= tkeep_reg_output_next[i];
        tlast_reg_output[i]   <= tlast_reg_output_next[i];
        tuser_reg_output[i]   <= tuser_reg_output_next[i];
        input_state[i]        <= input_state_next[i];
        output_agg_state[i]   <= output_agg_state_next[i];
        start_agg[i]          <= start_agg_next[i];
        output_write_count[i] <= output_write_count_next[i];
        input_write_count[i]  <= input_write_count_next[i];
        done_with_headers[i]  <= done_with_headers_next[i]; 
        current_vector_index[i]<=current_vector_index_next[i];
	//delayed_fifo_empty    <=in_fifo_empty;
     	//if(input_state[i]==FSM_AGG) begin
//		toggle[i]<=~toggle[i];
//	end
     end
  end //always


  assign out_tvalid[i] =((PORTS_BITMAP[i]==1)&&((output_agg_state[i]==SEND_HEADER)||((output_agg_state[i]==WRITE_OUT_RESULT)&&(agg_write_out==1))))?1:0;
//||((output_agg_state[i]==WRITE_OUT_RESULT) &&(agg_write_out==1))||((PORTS_BITMAP[i]==0) && (input_state[i]==FORWARD_OUT_RESULT)&&!(in_fifo_empty[i])))?1'b1:1'b0; //other condition is state=write_out_result
  assign fp_rd_en[i]        =  out_tvalid[i] &&(output_agg_state[i]==WRITE_OUT_RESULT);
  assign meta_fifo_rd_en[i] = out_tvalid[i] &&(output_agg_state[i]==WRITE_OUT_RESULT);

  
end   //myqueus
endgenerate


 
 //NOT IN GENERATE BLOCK
 
//Input side signal assignments
   assign in_tdata[0]        = s_axis_0_tdata;
   assign in_tkeep[0]        = s_axis_0_tkeep;
   assign in_tuser[0]        = s_axis_0_tuser;
   assign in_tvalid[0]       = s_axis_0_tvalid;
   assign in_tlast[0]        = s_axis_0_tlast;
   assign s_axis_0_tready    = !in_fifo_nearly_full [0];


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

  assign data_reg_out [0]    = data_reg_output[0][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[0]    = tuser_reg_output[0][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[0]    = tkeep_reg_output[0][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[0]    = tlast_reg_output[0][0];

  assign data_reg_out [1]    = data_reg_output[1][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[1]    = tuser_reg_output[1][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[1]    = tkeep_reg_output[1][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[1]    = tlast_reg_output[1][0];

  assign data_reg_out [2]    = data_reg_output[2][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[2]    = tuser_reg_output[2][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[2]    = tkeep_reg_output[2][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[2]    = tlast_reg_output[2][0];

  assign data_reg_out [3]    = data_reg_output[3][C_M_AXIS_DATA_WIDTH-1:0];
  assign tuser_reg_out[3]    = tuser_reg_output[3][C_M_AXIS_TUSER_WIDTH-1:0];
  assign tkeep_reg_out[3]    = tkeep_reg_output[3][C_M_AXIS_DATA_WIDTH/8-1:0];
  assign tlast_reg_out[3]    = tlast_reg_output[3][0];

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

endmodule  
