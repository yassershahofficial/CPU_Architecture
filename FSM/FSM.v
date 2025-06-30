module FSM (clk, reset, ir_load, rom_read_enable, state, pc);

	input clk, reset;
	
	output reg ir_load, rom_read_enable;
	output reg [2:0] state;
	output reg [7:0] pc;
	
	parameter FETCH = 3'b000, DECODE = 3'b001;
	parameter EXEC1 = 3'b010, EXEC2 = 3'b011, EXEC3 = 3'b100, EXEC4 = 3'b101;

	always @(posedge clk or posedge reset) 
		begin
		
			if(reset) 
			begin
				pc <= 0;
				state <= FETCH;
				rom_read_enable <= 0;
				ir_load <= 0;
			end
			
			else 
			begin
				case (state)
				
					FETCH: 
					begin
						rom_read_enable <= 1;
						ir_load <= 1;
						state <= DECODE;
					end
					
					DECODE: 
					begin
						rom_read_enable <= 0;
						ir_load <= 0;
						state <= EXEC1;
					end
					
					EXEC1: state <= EXEC2;
					
					EXEC2: state <= EXEC3;
					
					EXEC3: state <= EXEC4;
					
					EXEC4: 
					begin
						pc <= pc + 1;
						state <= FETCH;
					end
				
				endcase
			end
		end

endmodule
