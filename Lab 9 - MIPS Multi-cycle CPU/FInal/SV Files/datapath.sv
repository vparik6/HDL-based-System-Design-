
// Complete the datapath module below.
// The datapath unit is a structural verilog module. That is,
// it is composed of instances of its sub-modules. For example,
// the instruction register is instantiated as a 32-bit flopenr.
// The other submodules are likewise instantiated.
module datapath(input logic  clk, reset,
					 input logic  pcen, irwrite, regwrite,
					 input logic  alusrca, iord, memtoreg, regdst,
					 input logic  [1:0] alusrcb, pcsrc,
					 input logic  [2:0] alucontrol, 
					 output logic [5:0] op, funct,
					 output logic zero,
					 output logic [31:0] adr, writedata, pc, instr, aluresult, 
					 input logic  [31:0] readdata);
	
 	// Below are the internal signals of the datapath module.
	logic [4:0]  writereg;
	logic [31:0] pcnext;
	logic [31:0] data, srca, srcb;
	logic [31:0] a,b,A,B;
	logic [31:0] aluout, result;
	logic [31:0] signimm; // the sign-extended immediate
	logic [31:0] signimmsh; // the sign-extended immediate shifted left by 2
	//logic [31:0] wd3, rd1, rd2;
 
	// op and funct fields to controller
	assign op = instr[31:26];
	assign funct = instr[5:0];
	assign writedata = B;

	// Your datapath hardware goes below. Instantiate each of the submodules
	// that you need. Remember that alu's, mux's and various other
	// versions of parameterizable modules are available in textbook 7.6
	// Here, parameterizable 3:1 and 4:1 muxes are provided below for your use.
	// Remember to give your instantiated modules applicable names
	// such as pcreg (PC register), wdmux (Write Data Mux), etc.
	// so it's easier to understand.
	// ADD CODE HERE
	// datapath
	
	 // next PC logic
  flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);
  flopenr #(32) instrReg(clk, reset, irwrite, readdata, instr);
  flopr 	 #(32) dataReg(clk, reset, readdata, data);
  flopr 	 #(32) rega(clk, reset, a, A);
  flopr 	 #(32) regb(clk, reset, b, B);
  flopr 	 #(32) aluReg(clk, reset, aluresult, aluout);
  
  sl2         immsh(signimm, signimmsh);
  signext     se(instr[15:0], signimm);
  //zeroext     ze(instr[15:0], zeroimm);
  
  mux2 #(32)  srcamux(pc, A, alusrca, srca);
  mux2 #(32)  pcmux2(pc, aluout, iord, adr);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11], regdst, writereg);
  mux2 #(32)  resmux(aluout, data, memtoreg, result);
  mux3 #(32)  pcmux3(aluresult, aluout, {pc[31:28], instr[25:0], 2'b00}, 
                    pcsrc, pcnext);

  // register file logic
  regfile     rf(clk, regwrite, instr[25:21], instr[20:16], writereg, result, a, b);

   // ALU logic
  mux4 #(32)  srcbmux(B, 32'd4, signimm, signimmsh, alusrcb, srcb);
  alu         alu(.A(srca), .B(srcb), .F(alucontrol), .Y(aluresult), .zero(zero));
endmodule

	 