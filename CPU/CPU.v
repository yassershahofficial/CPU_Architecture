module CPU(clk, reset, rom_data, ram_data_in, ram_write, ram_read, alu_enable, rom_address, ram_addr, ram_data_out, alu_op);

	input clk, reset;
	input [15:0] rom_data, ram_data_in;

	output ram_write, ram_read, alu_enable;
	output [7:0] rom_address;
	output [5:0] ram_addr;
	output [15:0] ram_data_out;
	output [3:0] alu_op;

	reg [15:0] IR;
	
	wire [7:0] pc;
	wire [1:0] state;
	wire ir_load, rom_read_enable;
	wire [3:0] opcode = IR[15:12];
	wire [5:0] dest = IR[11:6];
	wire [5:0] src = IR[5:0];

	always @(posedge clk) 
	begin

		if (ir_load)
			IR <= rom_data;
	end

	FSM fsm_inst (
		.clk(clk),
		.reset(reset),
		.pc(pc),
		.rom_read_enable(rom_read_enable),
		.state(state),
		.ir_load(ir_load)
	);

	CU cu_inst (
		.opcode(opcode),
		.ram_write(ram_write),
		.ram_read(ram_read),
		.alu_op(alu_op),
		.alu_enable(alu_enable)
	);

	assign rom_address = pc; //test
	assign ram_addr = (state == 2'b10) ? dest : 6'b000000;
	assign ram_data_out = ram_data_in; // Placeholder for full datapath

endmodule
