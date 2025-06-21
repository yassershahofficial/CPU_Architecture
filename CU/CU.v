module CU(opcode, ram_write, ram_read, alu_op, alu_enable);

	input [3:0] opcode;

	output reg ram_write, ram_read, alu_enable;
	output reg [3:0] alu_op;

	always @(*) 
	begin
	
		ram_write = 0;
		ram_read = 0;
		alu_enable = 0;
		alu_op = 4'b0000;

		case(opcode)
		
			//MOV
			4'b0001:  
			begin 
				ram_write = 1;
				ram_read = 1;
			end
			
			//ADD
			4'b0010: 
			begin 
				alu_enable = 1;
				alu_op = 4'b0001;
				ram_read = 1;
			end
			
			//SUB
			4'b0011: 
			begin 
				alu_enable = 1;
				alu_op = 4'b0010;
				ram_read = 1;
			end
			
			//AND
			4'b0100: 
			begin 
				alu_enable = 1;
				alu_op = 4'b0011;
				ram_read = 1;
			end
			
			//OR
			4'b0101: 
			begin 
				alu_enable = 1;
				alu_op = 4'b0100;
				ram_read = 1;
			end
			
			//XOR
			4'b0110: 
			begin
				alu_enable = 1;
				alu_op = 4'b0101;
				ram_read = 1;
			end
			
			//NOT
			4'b0111: 
			begin 
				alu_enable = 1;
				alu_op = 4'b0110;
				ram_read = 1;
			end
			
			//SHL
			4'b1000: 
			begin 
				alu_enable = 1;
				alu_op = 4'b0111;
				ram_read = 1;
			end
			
			//SHR
			4'b1001: 
			begin 
				alu_enable = 1;
				alu_op = 4'b1000;
				ram_read = 1;
			end
			
			//Less Than
			4'b1010: 
			begin 
				alu_enable = 1;
				alu_op = 4'b1001;
				ram_read = 1;
			end
			
			//Equal
			4'b1011: 
			begin 
				alu_enable = 1;
				alu_op = 4'b1010;
				ram_read = 1;
			end
			
			default: 
			begin
				ram_write = 0;
				ram_read = 0;
				alu_enable = 0;
				alu_op = 4'b0000;
			end
			
		endcase
		
	end

endmodule
