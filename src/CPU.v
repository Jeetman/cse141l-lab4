// Module Name:    CPU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This is the TopLevel of your project
// Testbench will create an instance of your CPU and test it
// You may add a LUT if needed
// Set Ack to 1 to alert testbench that your CPU finishes doing a program or all 3 programs



	 
module CPU(Reset, Start, Clk,Ack);

	input Reset;		// init/reset, active high
	input Start;		// start next program
	input Clk;			// clock -- posedge used inside design
	output reg Ack;   // done flag from DUT

	
	
	wire [ 10:0] PgmCtr,        // program counter
			      PCTarg;
	wire [ 8:0] Instruction;   // our 9-bit instruction
	wire [ 3:0] Instr_opcode;  // out 3-bit opcode
	wire [ 7:0] ReadA, ReadB;  // reg_file outputs
	wire [ 7:0] InA, InB, 	   // ALU operand inputs
					ALU_out;       // ALU result
	wire [ 7:0] RegWriteValue, // data in to reg file
					MemWriteValue, // data in to data_memory
					MemReadValue;  // data out from data_memory
	wire        MemWrite,	   // data_memory write enable
					MovInst,
					OverFlow,
				   Zero,		      // ALU output = 0 flag
					Jump,	         // to program counter: jump 
					BranchEn;	   // to program counter: branch enable
	reg  [15:0] CycleCt;	      // standalone; NOT PC!

	// Fetch = Program Counter + Instruction ROM
	// Program Counter
  InstFetch IF1 (
	.Reset       (Reset   ) , 
	.Start       (Start   ) ,  
	.Clk         (Clk     ) ,  
	.BranchRelEn (BranchEn) ,  // branch enable
   .Target      (ReadB  ) ,
	.ProgCtr     (PgmCtr  )	   // program count = index to instruction memory
	);	
	
		// instruction ROM
  InstROM IR1(
	.InstAddress   (PgmCtr), 
	.InstOut       (Instruction)
	);
	
	//Check if hlt instr
	always@*							  
	begin
		if (Instruction[8:5] == 4'b1111)
			Ack = 1;  
		else 
			Ack = 0;
	end
	
	//check if mov instr
   assign MovInst = Instruction[8:5] == 4'b0111;
	//check if ldl / ldh
	assign OpsInst = Instruction[8:5] == 4'b1010 || Instruction[8:5] == 4'b1011;
	//check if ldh instr
	assign LoadHigh = Instruction[8:5] == 4'b1010;
	//check if ldb instr
	assign LoadInst = Instruction[8:5] == 4'b1000;
	//check if str instr
	assign MemWrite = (Instruction[8:5] == 4'b1001); 
	//check if jmp instr
	assign Jump = Instruction[8:5] == 4'b1100;
	assign BranchEn = Jump ? ReadA : 0;
	
	// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction),    // from instr_ROM
	.MemReadValue (MemReadValue),
	.ALU_out      (ALU_out),
	.RegWriteValue (RegWriteValue)
   );

	//Reg file
	// Modify D = *Number of bits you use for each register*
   // Width of register is 8 bits, do not modify
	RegFile #(.W(8),.D(4)) RF1 (
		.Clk    	  (Clk)		   ,
		.opsWrite  (OpsInst)	,
		.loadHigh  (LoadHigh),
		.jmp		  (Jump)			,
		.jmpReg    (Instruction[4:1]),
		.Waddr     (Instruction[4:1]),
		.isMov     (MovInst)         ,
		.loadByte  (LoadInst)      ,
		.OverFlow  (OverFlow)		,
		.DataIn    (RegWriteValue) , 
		.DataOutA  (ReadA        ) , 
		.DataOutB  (ReadB		 ),
		.MemWriteValue (MemWriteValue)
	);
	
	
	// connect RF out to ALU in
	assign InA = MemWrite ? Instruction[4:0] : ReadA;						                      
	assign InB = LoadInst ? Instruction[4:0] : ReadB;
	assign Instr_opcode = Instruction[8:5];
	

	// Arithmetic Logic Unit
	ALU ALU1(
	  .InputA(InA),      	  
	  .InputB(InB),
	  .OP(Instr_opcode),				  
	  .Out(ALU_out),		  			
	  .Over(OverFlow)
	);
	 
	 
	// Data Memory
	 	DataMem DM1(
		.DataAddress  (ALU_out)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (MemWriteValue), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  	  (Clk)     ,
		.Reset		  (Reset)
	);

	
	
// count number of instructions executed
// Help you with debugging
	always @(posedge Clk)
	  if (Start == 1)	   // if(start)
		 CycleCt <= 0;
	  else if(Ack == 0)   // if(!halt)
		 CycleCt <= CycleCt+16'b1;

endmodule