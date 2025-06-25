module FSM(clk, reset, pc, rom_read_enable, current_state, next_state, ir_load);

	input clk, reset;
	
	output reg [7:0] pc;
	output reg [1:0] current_state, next_state;
	output reg rom_read_enable, ir_load;

	parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;

	always @(posedge clk or posedge reset) 
	begin

		if (reset) 
		begin
		
			pc <= 0;
			current_state <= FETCH;
			next_state <= FETCH;
			rom_read_enable <= 0;
			ir_load <= 0;
			
		end 
		
		else 
		begin
		
			case (next_state)
			
				FETCH: 
				begin
				
					rom_read_enable <= 1;
					ir_load <= 0;
					current_state <= FETCH;
					next_state <= DECODE;
					
				end
				
				DECODE: 
				begin
				
					rom_read_enable <= 0;
					ir_load <= 1;
					current_state <= DECODE;
					next_state <= EXECUTE;
					
				end
				
				EXECUTE: 
				begin
					ir_load <= 0;
					pc <= pc + 1;
					current_state <= EXECUTE;
					next_state <= FETCH;
					
				end
			endcase
		end
	end

endmodule
