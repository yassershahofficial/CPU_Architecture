module CPU (
    clk, reset, state, pc, IR, dest, src, reg_a, reg_b,
    reg_read, reg_write, ram_addr,
    alu_enable, alu_op, alu_result, zero_flag
);

	input clk, reset;

	//FSM
	output [2:0] state;
	output [7:0] pc;
	output [15:0] IR;

	//Internal Registers
	output [5:0] dest, src;
	output reg [15:0] reg_a, reg_b;
	output reg_read, reg_write;

	//RAM
	output [5:0] ram_addr;

	//ALU
	output alu_enable;
	output [3:0] alu_op;
	output [15:0] alu_result;
	output zero_flag;

	//Internal Wires
	wire [15:0] rom_data;
	wire [15:0] ram_data_in;
	wire [15:0] ram_data_out;
	wire rom_read_enable;
	wire ram_read_internal;
	wire ram_write_internal;
	wire alu_enable_internal;
	wire ir_load;

	//Internal Registers
	reg [15:0] IR_internal;
	reg [15:0] ram_data_buffer;

	reg was_exec1, was_exec2;
	reg prev_was_exec1, prev_was_exec2;
	reg [15:0] delayed_data;

	wire [3:0] opcode = IR_internal[15:12];
	wire [5:0] dest_internal = IR_internal[11:6];
	wire [5:0] src_internal = IR_internal[5:0];

	//ROM
	ROM rom_inst (
		.clk(clk),
		.read(rom_read_enable),
		.addr(pc),
		.data_out(rom_data)
	);

	//RAM/Register File
	RAM ram_inst (
		.clk(clk),
		.write(ram_write_internal),
		.read(ram_read_internal),
		.addr(ram_addr),
		.data_in(ram_data_out),
		.data_out(ram_data_in)
	);

	//FSM
	FSM fsm_inst (
		.clk(clk),
		.reset(reset),
		.pc(pc),
		.rom_read_enable(rom_read_enable),
		.state(state),
		.ir_load(ir_load)
	);

	//Control Unit
	CU cu_inst (
		.opcode(opcode),
		.ram_write(ram_write_internal),
		.ram_read(ram_read_internal),
		.alu_op(alu_op),
		.alu_enable(alu_enable_internal)
	);

	//ALU
	ALU alu_inst (
		.a(reg_a),
		.b(reg_b),
		.alu_op(alu_op),
		.alu_enable(alu_enable),
		.result(alu_result),
		.zero(zero_flag)
	);

	//Instruction Register Load
	always @(posedge clk) 
	begin
		if (ir_load) IR_internal <= rom_data;
	end

	//Operand loading with 1 Cycle Delay
	always @(posedge clk) 
	begin
	//i need to track if state was exec1/exec2
		prev_was_exec1 <= was_exec1;
		prev_was_exec2 <= was_exec2;

		was_exec1 <= (state == 3'b010); // LOAD dest
		was_exec2 <= (state == 3'b011); // LOAD src

		delayed_data <= ram_data_in; // Store RAM output

		if (prev_was_exec1) reg_a <= delayed_data;
		if (prev_was_exec2) reg_b <= delayed_data;
	end

	//Address Decoder
	assign ram_addr = (state == 3'b010) ? dest_internal :
							(state == 3'b011) ? src_internal  :
							(state == 3'b101) ? dest_internal : 6'd0;

	//Control Signal Timing
	assign IR = IR_internal;
	assign dest = dest_internal;
	assign src = src_internal;
	assign reg_read  = ((state == 3'b010) || (state == 3'b011)) ? ram_read_internal  : 1'b0;
	assign reg_write = (state == 3'b101) ? ram_write_internal : 1'b0;
	assign alu_enable = (state == 3'b100) ? alu_enable_internal : 1'b0;

	//Data for Write-Back
	assign ram_data_out = alu_result;

endmodule
