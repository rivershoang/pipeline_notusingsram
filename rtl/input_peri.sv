/* verilator lint_off WIDTHEXPAND */

module input_peri (
   input  logic [ 7:0] addr  ,
   input  logic [31:0] io_sw ,
   input  logic [ 3:0] io_btn,
   output logic [31:0] rdata
);

   always_comb begin
      case (addr) 
         8'h00: rdata = io_sw;
         8'h10: rdata = {28'b0, io_btn};
         default: rdata = 32'h0;
      endcase 
   end

endmodule


