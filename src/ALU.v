// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// 


	 
module ALU(InputA,InputB,OP,Out,Over);

	input [ 7:0] InputA;
	input [ 7:0] InputB;
	input [ 3:0] OP;
	output reg [7:0] Out; // logic in SystemVerilog
	output reg Over;      //write this to reg 12

	always@* // always_comb in systemverilog
	begin 
		Out = 0;
		case (OP)
		4'b0000: {Over, Out} = {1'b0,InputA} + {1'b0,InputB}; // ADD
		4'b0001: Out = InputA << InputB;				            // Shift left
		4'b0010: Out = InputA >> InputB;                      // Shift right
		4'b0011: Out = InputA & InputB; // AND
		4'b0100: Out = InputA | InputB; // OR
		4'b0101: Out = InputA ^ InputB; // XOR
		4'b0110: Out = InputA < InputB;// SLT
		4'b0111: Out = InputB;          // MOV
		default: Out = InputA + InputB;
	  endcase
	
	end 

endmodule