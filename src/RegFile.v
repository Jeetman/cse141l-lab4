// Module Name:    RegFile 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is your register file.
// If you have more or less bits for your registers, update the value of D.
// Ex. If you only supports 8 registers. Set D = 3

/* parameters are compile time directives 
       this can be an any-size reg_file: just override the params!
*/
module RegFile (Clk,opsWrite,loadHigh,jmp,isMov,loadByte,OverFlow,jmpReg,Waddr,DataIn,DataOutA,DataOutB,MemWriteValue);
	parameter W=8, D=4;  // W = data path width (Do not change); D = pointer width (You may change)
	input                Clk,
	  			 			   opsWrite,
								loadHigh,
								jmp,
								isMov,
								loadByte,
								OverFlow;
	input        [D-1:0] Waddr,
								jmpReg;
	input        [W-1:0] DataIn;
	output reg   [W-1:0] DataOutA;			  
	output reg   [W-1:0] DataOutB;
   output reg   [W-1:0] MemWriteValue;	

// W bits wide [W-1:0] and 2**4 registers deep 	 
reg [W-1:0] Registers[(2**D)-1:0];	  // or just registers[16-1:0] if we know D=4 always



// NOTE:
// READ is combinational
// WRITE is sequential

always@*
begin
 //read from OPS register 
 if(jmp)
	begin
		DataOutA = Registers[jmpReg];
		DataOutB = Registers[13];
	end
 else 
	begin
		DataOutA = Registers[Registers[13][7:4]];	  
		DataOutB = Registers[Registers[13][3:0]];  
   end	
 MemWriteValue = Registers[Registers[13][7:4]];	
end

// sequential (clocked) writes 
always @ (posedge Clk)
  if (isMov)
	  Registers[Registers[13][7:4]] <= DataIn;
  else if (loadByte)
     Registers[Registers[13][3:0]] <= DataIn;
  else if (opsWrite && loadHigh)
	  Registers[13][7:4] <= DataIn[3:0];
  else if (opsWrite && !loadHigh)
	  Registers[13][3:0] <= DataIn[3:0];
  else if (jmp)
	  ;
  else
    begin
	  Registers[Waddr] <= DataIn;
	  Registers[12] <= OverFlow;
	 end
endmodule
