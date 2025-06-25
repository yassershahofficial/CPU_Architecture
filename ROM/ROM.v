module ROM(clk, read, addr, data_out);

	input clk, read;
	input [7:0] addr;
	output reg [15:0] data_out;

	always @(posedge clk) 
	begin
	
		if (read) 
		begin
		
			case (addr)
				
				8'h00:  data_out <= 16'b1100000001000001; //MVI R1,#01H
				8'h01:  data_out <= 16'b1100000010000010; //MVI R2,#02H
				8'h02:  data_out <= 16'b0010000010000001; //ADD R2,R1
				8'h03:  data_out <= 16'b1100111111001010; //MVI A,#10H
				8'h04:  data_out <= 16'b0001000001000010; //MOV R1,R2
				8'h05:  data_out <= 16'b0010000001000011; //ADD R1,R3
				8'h06:  data_out <= 16'b0011000101000001; //SUB R5,R1
				8'h07:  data_out <= 16'b0100000001000101; //AND R1,R5
				8'h08:  data_out <= 16'b0101000001000110; //OR R1,R6
				8'h09:  data_out <= 16'b1100111111001010; //MVI A,#10H
				8'h012: data_out <= 16'b0111111111111111; //CPL A, A
				8'h013: data_out <= 16'b1010111111111110; //MUL A,B
				
				
				//Testbench
				//CPL dest, src - Complements value inside src saves into dest
				//8'h00: data_out <= 16'b1100111111000001; //MVI A,#01H
				//8'h01: data_out <= 16'b0111111111111111; //CPL A, A
				
				//AND dest, src does dest x src saves into dest
				//8'h00: data_out <= 16'b1100111111000011; //MVI A,#03H
				//8'h01: data_out <= 16'b1100111110000110; //MVI B,#06H
				//8'h02: data_out <= 16'b0100111111111110; //AND A,B
				
				//SHL reg to shift, how many bits to shift left
				//8'h00: data_out <= 16'b1100111111000011; //MVI A,#03H
				//8'h01: data_out <= 16'b1100111110000110; //MVI B,#06H
				//8'h02: data_out <= 16'b1000111111111110; //SHL A,B - shift left A register by 6 bits
				
				//SHR reg to shift, how many bits to shift right
				//8'h00: data_out <= 16'b1100111111111111; //MVI A,#3FH
				//8'h01: data_out <= 16'b1100111110000010; //MVI B,#02H
				//8'h02: data_out <= 16'b1001111111111110; //SHL A,B - shift right A register by 2 bits
				
				////MUL Instruction - MUL dest, src - Multiplies dest reg x src reg, result[31:16] => dest  result[15:0] => src
				//8'h00: data_out <= 16'b1100111111111111; //MVI A,#3FH
				//8'h01: data_out <= 16'b1100111110111111; //MVI B,#3FH
				//8'h02: data_out <= 16'b1010111111111110; //MUL A,B
				//8'h03: data_out <= 16'b1100111111111111; //MVI A,#3FH
				//8'h04: data_out <= 16'b1010111110111111; //MUL B,A
				
				default: data_out <= 16'b0000000000000000; 
			
			endcase

		end
	end

endmodule
