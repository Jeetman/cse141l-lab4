// Module Name:    Ctrl 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is the control decoder (combinational, not clocked)
// Out of all the files, you'll probably write the most lines of code here
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
// There may be more outputs going to other modules

module Ctrl (Instruction, jmpReg, Jump, BranchEn);


  input[ 8:0] Instruction;	   // machine code
  input[ 7:0] jmpReg;         // value of reg passed to jmp cmd
  output reg Jump,
              BranchEn;

	// jump on right shift that generates a zero
	always@*
	begin
	  if(Instruction[8:5] ==  4'b1100) // jump = 1100
		 begin
			Jump = 1;
			if( jmpReg == 1 )
				BranchEn = 1;
		 end
	  else
		 begin
			Jump = 0;
			BranchEn = 0;
		 end
	  /*
	  if(Instruction[2:0] ==  3'b110 /*AND some other conditions are true) // assuming 110 is your branch instruction
		 BranchEn = 1;
	  else
		 BranchEn = 0;
	   */ 
	end


endmodule

