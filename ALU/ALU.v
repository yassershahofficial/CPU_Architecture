module ALU (a, b, alu_op, alu_enable, result, zero);

	input [15:0] a,b;
	input [3:0] alu_op;
	input alu_enable;
	output reg [15:0] result;
	output zero;

	assign zero = (result == 0);

	always @(*) 
	begin
	
		if (alu_enable)
		begin
		
			case (alu_op)
				4'b0001: result = a + b;
				4'b0010: result = a - b;
				4'b0011: result = a & b;
				4'b0100: result = a | b;
				4'b0101: result = a ^ b;
				4'b0110: result = ~a;
				4'b0111: result = a << 1;
				4'b1000: result = a >> 1;
				4'b1001: result = (a < b) ? 16'd1 : 16'd0;
				4'b1010: result = (a == b) ? 16'd1 : 16'd0;
				default: result = 16'd0;
			endcase
			
		end
		
		else 
		begin
			result = 16'd0;
		end
	end

endmodule
