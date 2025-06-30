module ROM(clk, read, addr, data_out);

	input clk, read;
	input [7:0] addr;
	
	output reg [15:0] data_out;
	
	always @(posedge clk) 
	begin
		if (read) 
		begin
			case (addr)
			
				//Register addressing
				8'h00: data_out <= 16'b0001_000001_000010; //MOV R1,R2
				8'h01: data_out <= 16'b0010_000100_000011; //ADD R4,R3
				8'h02: data_out <= 16'b0011_000010_000101; //SUB R2,R5
				8'h03: data_out <= 16'b0100_000011_000110; //AND R3,R6
				8'h04: data_out <= 16'b0101_000101_000100; //OR  R5,R4
				8'h05: data_out <= 16'b0110_000111_000001; //XOR R7,R1
				8'h06: data_out <= 16'b1010_000010_000111; //LT  R2,R7
				8'h07: data_out <= 16'b1011_000011_000010; //EQ  R3,R2

				// Single-operand operations (src ignored)
				8'h08: data_out <= 16'b0111_000100_000000; //NOT R4
				8'h09: data_out <= 16'b1000_000101_000000; //SHL R5
				8'h0A: data_out <= 16'b1001_000110_000000; //SHR R6

				//Immediate and Direct addressing
				8'h0B: data_out <= 16'b1100_000001_001111; //MVI R1, #0x0F
				8'h0C: data_out <= 16'b1101_000010_000011; //LDA R2, addr 3

				// NOP
				8'h0D: data_out <= 16'b0000_000000_000000; //NOP

				default: data_out <= 16'b0000_000000_000000; //NOP
			endcase
		end
	end

endmodule
