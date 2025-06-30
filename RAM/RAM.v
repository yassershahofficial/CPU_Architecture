module RAM(clk, write, read, addr, data_in, data_out);

	input clk, write, read;
	input [5:0] addr;
	input [15:0] data_in;

	output reg [15:0] data_out;
	reg [15:0] memory [0:63];

	integer i;
	
	initial 
	begin
		// Produce Unique Values for all my RAM contents
		for (i = 0; i < 64; i = i + 1) 
		begin
			memory[i] = i * 3 + 7; 
		end
	end

	always @(posedge clk) 
	begin
	
		if (write) memory[addr] <= data_in;
		
		if (read) data_out <= memory[addr];
		
	end

endmodule
