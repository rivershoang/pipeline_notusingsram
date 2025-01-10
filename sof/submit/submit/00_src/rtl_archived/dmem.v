// module DMEM #(
//    parameter DATA_WIDTH = 8, 
//    parameter ADDR_WIDTH = 11,
//    parameter BYTE_NUM   = 2**ADDR_WIDTH
// )(
//    input  wire                   clk, 
//                                  w_en,
// 	input  wire [DATA_WIDTH-1:0]  w_data,
// 	input  wire [ADDR_WIDTH-1:0]  addr,
// 	output wire [DATA_WIDTH-1:0]  r_data
// );

// 	reg [DATA_WIDTH-1:0] RAM [0:BYTE_NUM-1];

// 	always @ (posedge clk) begin
// 		if (w_en) begin
// 			RAM[addr] <= w_data;
//       end
//       else begin
// 		   RAM[addr] <= RAM[addr];
//       end
// 	end

// 	assign r_data = RAM[addr];

// endmodule

module dmem #(
   parameter DATA_WIDTH = 8, 
   parameter ADDR_WIDTH = 11,
   parameter BYTE_NUM   = 2**ADDR_WIDTH
)(
   input  wire                   clk, 
                                 w_en,
	input  wire [DATA_WIDTH-1:0]  w_data,
	input  wire [ADDR_WIDTH-1:0]  addr,
	output wire [DATA_WIDTH-1:0]  r_data,
                                 BYTE0,
                                 BYTE1,
                                 BYTE2,
                                 BYTE3
);

	reg [DATA_WIDTH-1:0] RAM [0:BYTE_NUM-1];

	always @ (posedge clk) begin
		if (w_en) begin
			RAM[addr] <= w_data;
      end
      else begin
		   RAM[addr] <= RAM[addr];
      end
	end

	assign r_data = RAM[addr];
   assign BYTE0 = RAM[{addr[10:2], 2'b0}];
   assign BYTE1 = RAM[{addr[10:2], 2'b0}+1];
   assign BYTE2 = RAM[{addr[10:2], 2'b0}+2];
   assign BYTE3 = RAM[{addr[10:2], 2'b0}+3];

endmodule








