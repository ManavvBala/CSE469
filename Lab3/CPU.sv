`timescale 1ns/10ps
module CPU (
    input logic clk,
    input logic rst
);

    logic [31:0] instr;
    logic negative, zero, overflow, carry_out;
    logic Reg2Loc, 
          UncondBranch, 
          BRTaken, 
          MemRead, 
          MemToReg, 
          ALUOp0, 
          ALUOp1, 
          MemWrite, 
          ALUSrc, 
          RegWrite, 
          ZExt,
          BranchLink,
          BranchRegister,
          CheckForLT;

    logic [4:0] Rd, Rn, Rm;
    logic [11:0] imm12;
    logic [8:0] dAddr9;
    logic [25:0] brAddr26;
    logic [18:0] condAddr19;
    logic [10:0] opcode;

    assign Rd = instr[4:0];
    assign Rn = instr[9:5];
    assign Rm = instr[20:16];
    assign opcode = instr[31:21];
    assign imm12 =  instr[21:10];
    assign dAddr9 = instr[20:12];
    assign brAddr26 = instr[25:0];
    assign condAddr19 = instr[23:5];

    // CPU CONTROL //
ControlUnit control (
    .opcode(opcode),
    .negative(negative),
    .zero(zero),
    .overflow(overflow),
    .carry_out(carry_out),
    .Reg2Loc(Reg2Loc),
    .UncondBranch(UncondBranch),
    .BRTaken(BRTaken),
    .MemRead(MemRead),
    .MemToReg(MemToReg),
    .ALUOp0(ALUOp0),
    .ALUOp1(ALUOp1),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ZExt(ZExt),
    .BranchLink(BranchLink),
    .BranchRegister(BranchRegister),
    .CheckForLT(CheckForLT)
);
   // CPU CONTROL //

    // Program Counting Logic //
    logic temp = 0;
	logic brSelect;
    logic notZero, negativeSelect;
    logic condBranchResult;

    not #(50ps) NOT1 (zero, notZero);
    and #(50ps) AND2 (negativeSelect, notZero, negative);

    mux2xN_N condBrancMux (
        .i0(zero),
        .i1(negativeSelect),
        .sel(CheckForLT),
        .out(temp)
    );

    and #(50ps) BranchAND (condBranchResult, temp, BRTaken);
    or  #(50ps) BranchOR (brSelect, UncondBranch, condBranchResult);

    logic [63:0] Rd1, Rd2;
    logic [63:0] nextAddrPreShift, nextAddrPostShift;
    logic [63:0] BRMuxout;

    mux2xN_N #(64) ucondMux (
        .sel(UncondBranch),
        .i1({{38{brAddr26[25]}}, brAddr26}),
        .i0({{45{condAddr19[18]}}, condAddr19}),
        .out(nextAddrPreShift)
    );

    mux2xN_N #(64) BRMux (
        .i0(nextAddrPreShift),
        .i1(Rd1),
        .sel(BranchRegister),
        .out(BRMuxout)
    );

    shifter brShifter (
        .value(BRMuxout),
        .direction(0),
        .distance(2),
        .result(nextAddrPostShift)
    );

    logic [63:0] curPC, prevPC;
    PC pc (
        .clk(clk),
        .DataIn(curPC),
        .DataOut(prevPC),
		  .rst(rst)
    );

    logic [63:0] regAddr, brAddr;
    adder_64bit regAdder (
        .A(prevPC),
        .B(64'd4),
        .out(regAddr)
    );

    adder_64bit brAdder (
        .A(prevPC),
        .B(nextAddrPostShift),
        .out(brAddr)
    );

    mux2xN_N #(64) brMux (
        .sel(brSelect),
        .i1(brAddr),
        .i0(regAddr),
        .out(curPC)
    );

    instructmem imem (
        .address(prevPC),
        .instruction(instr),
        .clk(clk)
    );
    // Program Counting Logic //

    // Register File Logic //
    logic [4:0] Ab;
    mux2xN_N #(5) reglocmux (
        .i1(Rm),
        .i0(Rd),
        .sel(Reg2Loc),
        .out(Ab)
    );

    logic [63:0] memtoregmuxout;
    logic [63:0] regfileWriteData;
    logic [4:0] regfileWriteReg;

    mux2xN_N #(5) BLAddrMux (
        .i0(Rd),
        .i1(5'd30),
        .sel(BranchLink),
        .out(regfileWriteReg)
    );

    mux2xN_N #(64) BLDataMux (
        .i0(memtoregmuxout),
        .i1(regAddr),
        .sel(BranchLink),
        .out(regfileWriteData)
    );

    regfile rf (
        .ReadRegister1(Rn),
        .ReadRegister2(Ab),
        .WriteRegister(regfileWriteReg),
        .WriteData(regfileWriteData),
        .RegWrite(RegWrite),
        .clk(clk),
        .ReadData1(Rd1),
        .ReadData2(Rd2)
    );
    // Register File Logic //

    // ALU Logic //
    logic [63:0] AluMuxIn, ALUin;

    mux2xN_N #(64) immsrccmux (
        .i1({{53{1'b0}}, imm12}),
        .i0({{55{dAddr9[8]}}, dAddr9}),
        .sel(ZExt),
        .out(AluMuxIn)
    );

    mux2xN_N #(64) alusrcmux (
        .i1(AluMuxIn),
        .i0(Rd2),
        .sel(ALUSrc),
        .out(ALUin)
    );

    logic [63:0] aluOut;
    alu mainAlu (
        .A(Rd1),
        .B(ALUin),
        .cntrl({1'b0, ALUOp1, ALUOp0}),
        .result(aluOut),
        .negative(negative),
        .zero(zero),
        .overflow(overflow),
        .carry_out(carry_out)
    );
    // ALU Logic //

    // Data Memory //
    logic [63:0] dataMemReadData;

    datamem dataMemory (
        .address(aluOut),
        .write_enable(MemWrite),
        .read_enable(MemRead),
        .write_data(Rd2),
        .clk(clk),
        .read_data(dataMemReadData),
        .xfer_size(4'd4)
    );

    mux2xN_N #(64) memtoregmux (
        .i1(dataMemReadData),
        .i0(aluOut),
        .sel(MemToReg),
        .out(memtoregmuxout)
    );
    // Data Memory //

endmodule
