module IF_ID_reg (
   input  logic clk           , 
   input  logic rst_n         ,    
   input  logic flush         ,
   input  logic enable        ,

   input  logic [31:0] instr_F,
   input  logic [31:0] pc_F   ,
   
   output logic [31:0] instr_D,
   output logic [31:0] pc_D
);

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin 
         instr_D     <= 0;
         pc_D        <= 0;
      end else if (flush) begin 
         instr_D     <= 0;
         pc_D        <= 0;
      end else if (enable) begin
         instr_D     <= instr_F;
         pc_D        <= pc_F;
      end else if (~enable) begin
         instr_D     <= instr_D;
         pc_D        <= pc_D;
      end
   end

endmodule 