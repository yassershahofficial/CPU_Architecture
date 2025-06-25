module CU(clk, opcode, dest, src, cu_state, rom_address, rom_data, rom_read_enable, ram_write, ram_read, ram_data_in, ram_data_out, alu_op, result, alu_a, alu_b);

	input [3:0] opcode;
	input clk; //pass clock for ram & rom
	input [5:0] dest, src;
	
	output reg [2:0] cu_state = 2'b000; //keeps track of when CU is done 11 = done
	
	//rom
	input [7:0] rom_address;
	input rom_read_enable; 
	output [15:0] rom_data;
	
	//ram
	reg [5:0] ram_addr;
	output reg [15:0] ram_data_in;
	output [15:0] ram_data_out;
	output reg ram_write, ram_read;
	
	//alu
	output reg [3:0] alu_op;
	output reg [15:0] alu_a;
	output reg [15:0] alu_b;
	output wire [31:0] result;
	wire zero;

	always @(posedge clk) 
	begin
	
		ram_write = 0;
		ram_read = 0;
		alu_op = 4'b0000;
		ram_addr = 6'b0;

		case(opcode)
		
			4'b0001: //MOV Instruction - MOV Dest register, source register
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						ram_data_in = ram_data_out;
						ram_write = 1;
						ram_addr = dest;
						cu_state = 3'b111; //Done execution
					end
				endcase
			end
			
			4'b0010: //ADD Instruction - ADD dest, src adds dest + src saves it into dest
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0001;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b0001;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b0011: //SUB Instruction - SUB dest, src does dest - src saves it into dest
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0010;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b0010;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b0100: //AND Instruction - AND dest, src does dest x src saves into dest
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0011;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b0011;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			//OR
			4'b0101: //OR Instruction - OR dest, src does dest || src saves into dest
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0100;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b0100;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b0110: //XRL Instruction - XOR dest, src does dest ^ src saves into dest
			begin
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0101;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b0101;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b0111: //NOT/Complement Instruction - CPL dest, src - Complements value inside src saves into dest
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						alu_op = 4'b0110;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0110;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b1000: //Shift left Instruction - SHL reg to shift, how many bits to shift left
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b0111;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b0111;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b1001: //Shift right Instruction - SHR reg to shift, how many bits to shift right
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b1000;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b1000;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result;
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b1010: //MUL Instruction - MUL dest, src - Multiplies dest reg x src reg, least significant byte saved onto src most significant to dest 
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b1001;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b1001;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result[31:16];
						cu_state = 3'b100;
					end
					3'b100:
					begin
						alu_op = 4'b1001;
						ram_addr = src;
						ram_write = 1;
						ram_data_in = result[15:0];
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b1011: //DIV Instruction - DIV dest, src - Division dest reg / src reg, least significant byte saved onto src most significant to dest
			begin 
				case (cu_state)
					3'b000:
					begin
						ram_read = 1;
						ram_addr = dest;
						cu_state = 3'b001;
					end
					3'b001:
					begin
						alu_a = ram_data_out;
						ram_read = 1;
						ram_addr = src;
						cu_state = 3'b010;
					end
					3'b010:
					begin
						alu_b = ram_data_out;
						alu_op = 4'b1010;
						cu_state = 3'b011;
					end
					3'b011:
					begin
						alu_op = 4'b1010;
						ram_addr = dest;
						ram_write = 1;
						ram_data_in = result[31:16];
						cu_state = 3'b100;
					end
					3'b100:
					begin
						alu_op = 4'b1010;
						ram_addr = src;
						ram_write = 1;
						ram_data_in = result[15:0];
						cu_state = 3'b111;
					end
				endcase
			end
			
			4'b1100: //MVI Instruction - MVI dest, #value - saves #value into dest
			begin
				case (cu_state)
					3'b000:
					begin
						ram_write = 1;
						ram_addr = dest;
						ram_data_in = src;
						cu_state = 3'b111;
					end
				endcase
			end
			
			default: 
			begin
				ram_write = 0;
				ram_read = 0;
				alu_op = 4'b0000;
				cu_state = 3'b000;
			end
			
		endcase
	
	end
	
	ROM rom_inst ( //ROM Integration to CU
		.clk(clk),
		.read(rom_read_enable),
		.addr(rom_address),
		.data_out(rom_data),
	);
	
	RAM ram_inst ( //RAM Integration to CU
		.clk(clk),
		.write(ram_write),
		.read(ram_read),
		.addr(ram_addr),
		.data_in(ram_data_in),
		.data_out(ram_data_out),
	);
	
	ALU alu_inst  ( //ALU Integration to CU
		.a(alu_a),
		.b(alu_b),
		.alu_op(alu_op),
		.result(result),
		.zero(zero),
	);


endmodule
