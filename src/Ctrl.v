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

module Ctrl (Instruction, jmpReg, MemReadValue, ALU_out,RegWriteValue);


  input[ 8:0] Instruction;	   // machine code
  input[ 7:0] jmpReg,         // reg to check if jmp or not
				  MemReadValue,   //value read from memory
				  ALU_out;        //value computed by alu
  output reg[7:0] RegWriteValue;

   //determine what is written to register
	always@*							  
	begin
		if (Instruction[8:5]==4'b1000)
			RegWriteValue = MemReadValue;                                    //ldb
		else if (Instruction[8:5] == 4'b1010 || Instruction[8:5] == 4'b1011) 
			RegWriteValue = Instruction[4:1];                                //ldh or ldl
		else if (Instruction[8:5] == 4'b0111)                           
			RegWriteValue = Instruction[4:0];                                //mov
		else
			RegWriteValue = ALU_out;			                                //r-type
	end	

endmodule

