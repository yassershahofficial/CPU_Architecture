module FSM(clk, reset, pc, ir_load, rom_read_enable, state);

	input clk, reset;

	output reg [2:0] pc, ir_load;
	output reg [1:0] state;
	output reg rom_read_enable;

	parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;

	always @(posedge clk or posedge reset) 
	begin

		if (reset) 
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
					state <= EXECUTE;
					
				end
				
				EXECUTE: 
				begin
				
					pc <= pc + 1;
					state <= FETCH;
					
				end
			endcase
		end
	end

endmodule
