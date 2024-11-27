module data_memory #(
   parameter int unsigned DMEM_W = 11
) (
   input  logic [DMEM_W-1:0] addr  ,
   input  logic [3:0]        bmask ,
   input  logic              wr_en ,
   input  logic [31:0]       w_data,
   output logic [31:0]       r_data,
   input  logic              clk  
); 

   logic [3:0][7:0] dmem [0:2**(DMEM_W-2)-1];

   always_ff @(posedge clk) begin : proc_data
      if (wr_en) begin
         if (bmask[0]) begin 
         dmem[addr[DMEM_W-1:2]][0] <= w_data [ 7: 0]; 
         end
         if(bmask[1]) begin
         dmem[addr[DMEM_W-1:2]][1] <= w_data [15: 8]; 
         end
         if (bmask[2]) begin 
         dmem[addr[DMEM_W-1:2]][2] <= w_data [23:16];
         end
         if (bmask[3]) begin 
         dmem[addr[DMEM_W-1:2]][3] <= w_data [31:24]; 
         end
      end
   end

   assign r_data = dmem[addr[DMEM_W-1:2]];

endmodule
