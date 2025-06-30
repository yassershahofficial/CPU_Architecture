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

			4'b0001: // MOV
			begin 
				ram_read = 1;
				ram_write = 1;
			end

			4'b0010: // ADD
			begin 
				alu_enable = 1;
				alu_op = 4'b0001;
				ram_read = 1;
				ram_write = 1;
			end

			4'b0011: // SUB
			begin 
				alu_enable = 1;
				alu_op = 4'b0010;
				ram_read = 1;
				ram_write = 1;
			end

			4'b0100: // AND
			begin 
				alu_enable = 1;
				alu_op = 4'b0011;
				ram_read = 1;
				ram_write = 1;
			end

			4'b0101: // OR
			begin 
				alu_enable = 1;
				alu_op = 4'b0100;
				ram_read = 1;
				ram_write = 1;
			end

			4'b0110: // XOR
			begin 
				alu_enable = 1;
				alu_op = 4'b0101;
				ram_read = 1;
				ram_write = 1;
			end

			4'b0111: // NOT
			begin 
				alu_enable = 1;
				alu_op = 4'b0110;
				ram_read = 1;
				ram_write = 1;
			end

			4'b1000: // SHL
			begin 
				alu_enable = 1;
				alu_op = 4'b0111;
				ram_read = 1;
				ram_write = 1;
			end

			4'b1001: // SHR
			begin 
				alu_enable = 1;
				alu_op = 4'b1000;
				ram_read = 1;
				ram_write = 1;
			end

			4'b1010: // LT 
			begin 
				alu_enable = 1;
				alu_op = 4'b1001;
				ram_read = 1;
				ram_write = 1;
			end

			4'b1011: // EQ 
			begin 
				alu_enable = 1;
				alu_op = 4'b1010;
				ram_read = 1;
				ram_write = 1;
			end

			4'b1100: // MVI 
			begin 
				ram_write = 1;
			end

			4'b1101: // LDA 
			begin 
				ram_read = 1;
				ram_write = 1;
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
