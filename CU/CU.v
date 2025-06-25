module CU(clk, opcode, dest, src, rom_address, rom_data, rom_read_enable, ram_write, ram_read, ram_data_in, ram_data_out, alu_op, alu_enable);

	input [3:0] opcode;
	input clk; //pass clock for ram & rom
	input [5:0] dest, src;
	
	//rom
	input [7:0] rom_address;
	input rom_read_enable; 
	output [15:0] rom_data;
	
	//ram
	reg [5:0] ram_write_addr;
	reg [5:0] ram_read_addr;
	output reg [15:0] ram_data_in;
	output [15:0] ram_data_out;
	output reg ram_write, ram_read;
	
	//alu
	output reg alu_enable;
	output reg [3:0] alu_op;
	reg [15:0] alu_a;
	reg [15:0] alu_b;
	wire [15:0] result;
	wire zero;

	always @(*) 
	begin
	
		ram_write = 0;
		ram_read = 0;
		alu_enable = 0;
		alu_op = 4'b0000;
		ram_write_addr = 6'b0;
		ram_read_addr = 6'b0;

		case(opcode)
		
			4'b0001: //MOV Instruction - MOV Dest register, source register
			begin 
				ram_write = 1;
				ram_read = 1;
				ram_read_addr = src;
				ram_data_in = ram_data_out;
				ram_write_addr = dest;
			end
			
			4'b0010: //ADD Instruction - ADD dest, src adds dest + s saves it into A
			begin 
				alu_enable = 1;
				alu_op = 4'b0001;
				ram_read = 1;
				ram_read_addr = src;
				alu_a = ram_data_out;
				ram_read_addr = dest;
				alu_b = ram_data_out;
				ram_write = 1;
				ram_write_addr = dest;
				ram_data_in = result;
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
			
			4'b1100: //MVI Instruction - MVI dest, #value
			begin 
				ram_write = 1;
				ram_write_addr = dest;
				ram_data_in = src;
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
		.read_addr(ram_read_addr),
		.write_addr(ram_write_addr),
		.data_in(ram_data_in),
		.data_out(ram_data_out),
	);
	
	ALU alu_inst  ( //ALU Integration to CU
		.a(alu_a),
		.b(alu_b),
		.alu_enable(alu_enable),
		.alu_op(alu_op),
		.result(result),
		.zero(zero),
	);


endmodule
