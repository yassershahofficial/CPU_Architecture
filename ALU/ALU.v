module ALU(a, b, alu_op, result, zero);

	input [15:0] a, b;
	input [3:0] alu_op;
	
	output reg [15:0] result;
	output zero;

	assign zero = (result == 0);

	always @(*) 
	begin
		case (alu_op)
			4'b0001: result = a + b; //ADD
			4'b0010: result = a - b; //SUB
			4'b0011: result = a & b; //AND
			4'b0100: result = a | b; //OR
			4'b0101: result = a ^ b; //XOR
			4'b0110: result = ~a; //NOT (on operand A)
			4'b0111: result = a << 1; //Logical shift left
			4'b1000: result = a >> 1; //Logical shift right
			4'b1001: result = (a < b) ? 16'd1 : 16'd0; //Less than
			4'b1010: result = (a == b) ? 16'd1 : 16'd0; //Equal
			default: result = 0;
			
		endcase
	end

endmodule
