module ROM(clk, read, addr, data_out);

	input clk, read;
	input [7:0] addr;
	output reg [15:0] data_out;

	always @(posedge clk) 
	begin
	
		if (read) 
		begin
		
			case (addr)
				8'h00: data_out <= 16'b1100000001000001; //MVI R1,#01H
				8'h01: data_out <= 16'b1100000010000010; //MVI R2,#02H
				8'h02: data_out <= 16'b0010000010000001; //ADD R2,R1
				8'h03: data_out <= 16'b1100111111001010; //MVI A,#10H
				8'h04: data_out <= 16'b0001000001000010; //MOV R1,R2
				8'h05: data_out <= 16'b0010000001000011; //ADD R1,R3
				8'h06: data_out <= 16'b0011000100000001; //SUB R4,R1
				8'h07: data_out <= 16'b0100000001000101; //AND R1,R5
				8'h08: data_out <= 16'b0101000001000110; //OR R1,R6
				8'h09: data_out <= 16'b1100111111001010; //MVI A,#10H
				8'h010: data_out <= 16'b1101111111000001; //LDA A,000001 (R1/RAM Memory 1)
				8'h011: data_out <= 16'b1101111111000011; //LDA A,000011 (R1/RAM Memory 3)
				default: data_out <= 16'b0000000000000000; 
			
			endcase

		end
	end

endmodule
