module RAM(clk, write, read, read_addr, write_addr, data_in, data_out);

	input clk, write, read;
	input [5:0] read_addr;
	input [5:0] write_addr;
	input [15:0] data_in;

	output reg [15:0] data_out;
	reg [15:0] memory [0:63];

	always @(posedge clk) 
	begin 
	
		if (read)
			data_out <= memory[read_addr]; //read first then write
	
		if (write)
			memory[write_addr] <= data_in;
			
		
	end

endmodule

//RAM Address = (Register Banks)
//RAM[63] = Accumulator (Register A)
//RAM[62] = Register B
//RAM[61] = Register C
//RAM[60] = Register D