module inst_mem #(
   parameter DATA_WIDTH = 32, 
   parameter ADDR_WIDTH = 13,
   parameter REG_NUM    = (2**ADDR_WIDTH)/4     // (2^addr_w)/4
)(
	input  wire [ADDR_WIDTH-1:0]   raddr,
	output wire [DATA_WIDTH-1:0]   rdata
);

	reg [DATA_WIDTH-1:0] ROM [0:REG_NUM-1];

	initial
	begin
		$readmemh("E:/Lecture/ComputerArchitecture/pipeline_notusingsram/test/hazard/s_nam.txt", ROM);
	end
	
	assign rdata = ROM[raddr[ADDR_WIDTH-1:2]];

endmodule
