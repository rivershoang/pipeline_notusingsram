module btb (
	//input
	 input logic clk_i ,
	 input logic rst_ni,
    input logic [19:0] TagWriteF_i ,
    input logic [9:0]  AddrWriteF_i ,
    input logic [31:0] PCTargetWriteF_i ,
    
    input logic        WriteEnableF_i ,
    input logic        ValidWriteF_i ,
    input logic [9:0]  AddrReadF_i ,
    
	//output
	output logic [31:0] PCTargetReadF_o ,
	output logic [19:0] TagReadF_o ,
	output logic        ValidReadF_o
);

    logic [31:0] PCTarget [1023:0] ;
    logic        valid    [1023:0] ;
    logic [19:0] tag      [1023:0] ;
	 /*
	 initial begin
	 for(int i=0;i<=1023; i=i+1)
	 begin
	    PCTarget[i] <= 32'b0;
		 valid[i]    <= 1'b0;
		 tag[i]      <= 20'b0;
	 end
	 end */
    //write data
    always_ff @(posedge clk_i or negedge rst_ni) begin
	      if(!rst_ni) begin
			for(int i=0;i<=1023; i=i+1)
				begin
					PCTarget[i] <= 32'b0;
					valid[i]    <= 1'b0;
					tag[i]      <= 20'b0;
				end
			end
			else begin
			if (WriteEnableF_i) begin
            valid[AddrWriteF_i] <= ValidWriteF_i ;
            tag[AddrWriteF_i] <= TagWriteF_i ;
            PCTarget[AddrWriteF_i] <= PCTargetWriteF_i ;
         end
			end
    end

    //read data

    always_comb begin
        ValidReadF_o = valid[AddrReadF_i] ;
        TagReadF_o = tag[AddrReadF_i] ;
        PCTargetReadF_o = PCTarget[AddrReadF_i] ;
    end
            
endmodule