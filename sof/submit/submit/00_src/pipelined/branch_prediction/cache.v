module cache (
   input  wire          clk,
                        //rst_n,
                        w_en,
   input  wire [31:0]   targetted_PC_in,
   input  wire [19:0]   tag_in,
   input  wire [9:0]    w_addr, r_addr,        // 1024 branch instructions history
   output wire [31:0]   targetted_PC_out,
   output wire [19:0]   tag_out,
   output wire          cache_vld
); 

   integer i;

   // 20 bit tag + 32 bit targetted - 2 bit wasted + 1 bit cache-valid = 51 bits
   // tag - cache valid - targetted PC (30)
   reg [50:0] cache [0:1023];

   always @(posedge clk) begin
      // if (~rst_n) begin
      //    for (i = 0; i < 1024; i = i + 1) begin
      //       cache[i][30] <= 0;
      //    end
      // end
      // else begin
         if (w_en) begin
            cache[w_addr] <= {tag_in, 1'b1, targetted_PC_in[31:2]};
         end
      // end
   end

   assign {tag_out, cache_vld, targetted_PC_out} = {cache[r_addr], 2'b00};

endmodule