module CPU (
    input logic clk,
    input logic rst
);
    
logic [31:0] instr;
logic negative, zero, overflow, carry_out,
Reg2Loc, 
UncondBranch, 
BRTaken, 
MemRead, 
MemToReg, 
ALUOp0, 
ALUOp1, 
MemWrite, 
ALUSrc, 
RegWrite, 
ZExt;

assign Rd = instr[4:0];
assign Rn = instr[9:5];
assign Rm = instr[20:16];
assign opcode = instr[31:21];
assign shamt =  instr[22:21];
assign imm12 =  instr[21:10];
assign dAddr9 = instr[20:12];
assign imm16 =  instr[20:5];
assign brAddr26 = instr[25:0];
assign condAddr19 = instr[23:5];

// Program Counting Logic //

logic[63:0] nextAddrPreShift,nextAddrPostShift;
mux2x64_64 ucondMux(.sel(UncondBranch),.i1({38{brAddr26[25]},brAddr26}),.i0({45{condAddr19[18],condAddr19}),.out(nextAdrr));
shifter brShifter (.value(nextAddrPreShift), .direction(0), .distance(2), .result(nextAddrPostShift));

logic [63:0] curPC, prevPC;
register pc(.clk(clk),.DataIn(curPC),.WriteEnable(1),.DataOut(prevPC));

// calculating next instruction address
logic [63:0] regAddr,brAddr;
adder_64bit regAdder(.A(prevPC),.B(4),.out(regAddr));
adder_64bit brAdder(.A(prevPC),.B(nextAddrPostShift),.out(brAddr));
mux2x64_64 brMux(.sel(BRTaken),.i1(regAddr),.i0(brAddr),.out(curPC)); // selects which addres to pass into pc

instructmem imem(.address(oldPC),.instruction(instr),.clk(clk));

// Program Counting Logic //



endmodule