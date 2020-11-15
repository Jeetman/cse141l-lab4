// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// 


	 
module ALU(InputA,InputB,OP,Out,Zero);

	input [ 7:0] InputA;
	input [ 7:0] InputB;
	input [ 3:0] OP;
	output reg [7:0] Out; // logic in SystemVerilog
	output reg Zero;      //write this to reg 12
	output reg Overflow;

	always@* // always_comb in systemverilog
	begin 
		Out = 0;
		case (OP)
		3'b0000: {Overflow, Out} = {1b'0,InputA} + {1b'0,InputB}; // ADD
		3'b0111: Out = InputA + InputB; // MOV
		//Add reset of instructions mapping TODO
		3'b0110: Out = InputA - InputB; // SLT
		3'b0011: Out = InputA & InputB; // AND
		3'b0100: Out = InputA | InputB; // OR
		3'b0101: Out = InputA ^ InputB; // XOR
		3'b0001: Out = InputA << 1;				// Shift left
		3'b0010: Out = {1'b0,InputA[7:1]};   // Shift right
		default: Out = 0;
	  endcase
	
	end 

	always@*							  // assign Zero = !Out;
	begin
		case(Out)
			'b0     : Zero = 1'b1;
			default : Zero = 1'b0;
      endcase
	end


endmodule