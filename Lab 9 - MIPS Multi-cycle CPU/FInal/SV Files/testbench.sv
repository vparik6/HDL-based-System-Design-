/*
module testbench();
	logic clk,reset,zero,pcen;
	logic [5:0] op;
	logic [5:0] funct;
	logic [14:0] controls;
	logic [3:0] state;
	logic [2:0] alucontrol;
	logic  memwrite, irwrite, regwrite,alusrca, iord, memtoreg, regdst;
	logic [1:0] alusrcb, pcsrc;
 
controller dut(clk, reset, op, funct, zero,
					 pcen, memwrite, irwrite, regwrite,
					 alusrca, iord, memtoreg, regdst,
					 alusrcb, pcsrc, alucontrol, state,controls);
 
always
    begin
      clk = 1; # 5; clk = 0; # 5;
    end
initial
begin
  //beq:
  op=6'b000100;
  zero=1;
  reset=1;#10;
  reset=0;#10;

  zero=0;#10;
  
  //lw:
  op=6'b100011;#60;
  
  //sw:
  op=6'b101011;#20;
  
  //add:
  op=6'b000000;
  funct=6'b100000;#20;
  
  //sub:
  op=6'b000000;
  funct=6'b100010;#20;
  
  //and:
  op=6'b000000;
  funct=6'b100100;#20;
  
  //or:
  op=6'b000000;
  funct=6'b100101;#20;
  
  //slt:
  op=6'b000000;
  funct=6'b101010;#20;
  
  //addi:
  op=6'b000000;#20;
  
  //j:
  op=6'b000000;
end
  
endmodule
*/

// Example testbench for MIPS processor

module testbench();

  logic        clk;
  logic        reset;
  logic [3:0]  state;
  logic [31:0] pc, instr, aluresult;
  logic [31:0] writedata, dataadr;
  logic        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, state, pc, instr, aluresult, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check that 7 gets written to address 84
  always@(negedge clk)
    begin
      if(memwrite) begin
        if(dataadr === 84 & writedata === 7) begin
          $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule
