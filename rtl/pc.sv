module pc (
   input  logic clk           ,
   input  logic rst_n         ,
   input  logic pc_enable     ,
   input  logic [31:0] pc_in  , 
   output logic [31:0] pc_out
);
  
   always_ff @(posedge clk or negedge rst_n) begin 
      if (!rst_n) begin 
         pc_out <= 0;
      end else if (pc_enable) begin 
         pc_out <= pc_in;
      end else if (~pc_enable) begin 
         pc_out <= pc_out;
      end
   end

endmodule
  
