module ROM(clk, read, addr, data_out);

	input clk, read;
	input [2:0] addr;
	output reg [15:0] data_out;

	always @(posedge clk) 
	begin
	
		if (read) 
		begin
		
			case (addr)
			
				3'b000: data_out <= 16'b000100_000001_000010; //MOV R1,R2
				3'b001: data_out <= 16'b001000_000001_000011; //ADD R1,R3
				3'b010: data_out <= 16'b001100_000001_000100; //SUB R1,R4
				3'b011: data_out <= 16'b010000_000001_000101; //AND R1,R5
				3'b100: data_out <= 16'b010100_000001_000110; //OR R1,R6
				3'b101: data_out <= 16'b110000_111111_001010; //MVI A,10h
				3'b110: data_out <= 16'b110100_111111_000001; //LDA A,R1(Address 1)
				default: data_out <= 16'b000000_000000_000000;
			
			endcase
	
		end
	end

endmodule
