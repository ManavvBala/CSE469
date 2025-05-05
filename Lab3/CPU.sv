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
assign imm12 =  instr[21:10];
assign dAddr9 = instr[20:12];
assign brAddr26 = instr[25:0];
assign condAddr19 = instr[23:5];

// CPU CONTROL //
ControlUnit control(.*);
// CPU CONTROL //

// Program Counting Logic //
logic temp, brSelect;
and #(50ps) AND1 (temp,BRTaken, zero);
OR #(50ps) OR1 (brSelect, UncondBranch, temp);

logic[63:0] nextAddrPreShift,nextAddrPostShift;
mux2xN_N ucondMux(.sel(brSelect),.i1({38{brAddr26[25]},brAddr26}),.i0({45{condAddr19[18]},condAddr19}),.out(nextAddrPreShift));
// NEED ANOTHER MUX HERE FOR BR (i0 = ucondMux, i1 = Regfile.readData1, sel = ControlUnit.BRegister, out = brShifter)
// then change brshifter in to out of new mux
shifter brShifter (.value(nextAddrPreShift), .direction(0), .distance(2), .result(nextAddrPostShift));

logic [63:0] curPC, prevPC;
PC pc(.clk(clk),.DataIn(curPC),.DataOut(prevPC));

// calculating next instruction address
logic [63:0] regAddr,brAddr;
adder_64bit regAdder(.A(prevPC),.B(4),.out(regAddr)); // add 4 to pc
// NEED MUX HERE
adder_64bit brAdder(.A(prevPC),.B(nextAddrPostShift),.out(brAddr));
mux2x64_64 brMux(.sel(BRTaken),.i1(brAddr),.i0(regAddr),.out(curPC)); // selects which addres to pass into pc

instructmem imem(.address(prevPC),.instruction(instr),.clk(clk));

// Program Counting Logic //

// Register File Logic //
logic [4:0] Ab;
mux2xN_N #(WIDTH = 5) reglocmux(.i1(Rm),.i0(Rd),.sel(Reg2Loc),.out(Ab));

logic [63:0] Rd1, Rd2;
logic [63:0] regfileWriteData;
// NEED TO ADD BL Address MUX: (in0 = Rd, in1 = 5'd30, sel = ControlUnit.BL, out = writeAddr)
// NEED TO ADD BL WriteData MUX: (in0 = DataMemMUX, in1 = PC+4 (should just be regAddr), sel = BL, out = RegFile.writeData) 
rf regfile(.ReadRegister1(Rn),.ReadRegister2(Ab),
.WriteRegister(Rd),.WriteData(regfileWriteData),
.RegWrite(RegWrite),.clk(clk),.ReadData1(Rd1),.ReadData2(Rd2));



// Register File Logic //

// ALU Logic //

logic[63:0] AluMuxIn,ALUin;
mux2xN_N immsrccmux(.i1({55{1'b0},imm12}),.i0({55{dAddr9[8]},dAddr9}),.sel(ZExt),.out(AluMuxIn));
mux2xN_N alusrcmux(.i1(AluMuxIn),.i0(Rd2),.sel(ALUSrc),.out(ALUin));

logic[63:0] aluOut;
alu mainAlu(.A(Rd1),B(ALUin),.cntrl({0,ALUOp0,ALUOp1}),
.result(aluOut),.negative(negative),.zero(zero),
.overflow(overflow),.carry_out(carry_out));

// ALU Logic

// NEED TO ADD data memory //
logic [63:0] dataMemReadData; // needs to go to mux (along with alu result)
datamem dataMemory (.address(aluOut), .write_enable(MemWrite), .read_enable(MemRead)
                    .write_data(Rd2), .clk, .read_data(dataMemReadData), .xfer_size(4'd4));
mux2xN_N memtoregmux(.in1(dataMemReadData), .in0(aluOut), .sel(MemToReg), .out(regfileWriteData));
// data memory //

endmodule