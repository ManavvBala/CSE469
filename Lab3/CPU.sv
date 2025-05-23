`timescale 1ns/10ps
module CPU (
    input logic clk,
    input logic rst
);

    logic [31:0] instrIF,instrID;
    logic negative, zero, overflow, carry_out;
    logic Reg2Loc, 
          UncondBranch, 
          BRTaken, 
          MemReadID, MemReadEX, MemReadMem, 
          MemToRegID, MemToRegEX, MemToRegMem, 
          ALUOpID0, ALUOpEX0,
          ALUOpID1, ALUOpEX1,
          MemWriteID,MemWriteEX, MemWriteMem, 
          ALUSrc,
          RegWriteID, RegWriteEX, RegWriteMem, RegWriteWB, 
          ZExt,
          BranchLink,
          BranchRegister,
          CheckForLT,
		  SetFlagID, SetFlagEX;

    logic [4:0] RdID, RdEX, RdMem, RdWB, Rn, Rm;
    logic [11:0] imm12;
    logic [8:0] dAddr9;
    logic [25:0] brAddr26;
    logic [18:0] condAddr19;
    logic [10:0] opcode;
    

    assign RdID = instrID[4:0];
    assign Rn = instrID[9:5];
    assign Rm = instrID[20:16];
    assign opcode = instrID[31:21];
    assign imm12 =  instrID[21:10];
    assign dAddr9 = instrID[20:12];
    assign brAddr26 = instrID[25:0];
    assign condAddr19 = instrID[23:5];
	 
	logic alu_zero, alu_negative, alu_overflow, alu_carry;
	// control unit doesnt actually need the alu flags
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
    .MemRead(MemReadID),
    .MemToReg(MemToRegID),
    .ALUOp0(ALUOpID0),
    .ALUOp1(ALUOpID1),
    .MemWrite(MemWriteID),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWriteID),
    .ZExt(ZExt),
    .BranchLink(BranchLink),
    .BranchRegister(BranchRegister),
    .CheckForLT(CheckForLT),
	 .SetFlag(SetFlagID)
);

    // registers to push through control signals
    D_FF ALUOpR0 (.q(ALUOpEX0), .d(ALUOpID0), .rst, .clk);
	D_FF ALUOpR1 (.q(ALUOpEX1), .d(ALUOpID1), .rst, .clk);
	
	D_FF flagSetR (.q(SetFlagEX), .d(SetFlagID), .rst, .clk);
	
	D_FF MemWriteR0 (.q(MemWriteEX), .d(MemWriteID), .rst, .clk);
	D_FF MemWriteR1 (.q(MemWriteMem), .d(MemWriteEX), .rst, .clk);
	
	D_FF MemReadR0  (.q(MemReadEX), .d(MemReadID), .rst, .clk);
	D_FF MemReadR1 (.q(MemReadMem), .d(MemReadEX), .rst, .clk);
	
	D_FF MemToRegR0 (.q(MemToRegEX), .d(MemToRegID), .rst, .clk);
	D_FF MemToRegR1 (.q(MemToRegMem), .d(MemToRegEX), .rst, .clk);
	
	D_FF RegWriteR0 (.q(RegWriteEX), .d(RegWriteID), .rst, .clk);
	D_FF RegWriteR1 (.q(RegWriteMem), .d(RegWriteEX), .rst, .clk);
	D_FF RegWriteR2 (.q(RegWriteWB), .d(RegWriteMem), .rst, .clk);



   // CPU CONTROL //

    // Program Counting Logic //
    logic temp = 0;
	logic brSelect;
    logic notZero, negativeSelect;
    logic condBranchResult;

	xor #(50ps) xorCheck (negativeSelect, negative, overflow);
    mux2xN_N condBrancMux (
        .i0(alu_zero),
        .i1(negativeSelect),
        .sel(CheckForLT),
        .out(temp)
    );

    and #(50ps) BranchAND (condBranchResult, temp, BRTaken);
    or  #(50ps) BranchOR (brSelect, UncondBranch, condBranchResult);

    logic [63:0] Rd1, Rd2;
    logic [63:0] nextAddrPreShift, nextAddrPostShift;
    logic [63:0] BRMuxout;
	 
	 // sign extension
    mux2xN_N #(64) ucondMux (
        .sel(UncondBranch),
        .i1({{38{brAddr26[25]}}, brAddr26}),
        .i0({{45{condAddr19[18]}}, condAddr19}),
        .out(nextAddrPreShift)
    );
	 
    logic [63:0] finalPCMuxIntermediate;
    logic [63:0] curPC, prevPC;

    mux2xN_N #(64) FinalPCMUX (
        .i0(finalPCMuxIntermediate),
        .i1(Rd2),
        .sel(BranchRegister),
        .out(curPC)
    );

    shifter brShifter (
        .value(nextAddrPreShift),
        .direction(0),
        .distance(2),
        .result(nextAddrPostShift)
    );

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
        .out(finalPCMuxIntermediate)
    );

    instructmem imem (
        .address(prevPC),
        .instruction(instrIF),
        .clk(clk)
    );


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
	 
	 // flag register (only outputs used for B.LT)
	 flag_register regflag (.in_zero(alu_zero), .in_negative(alu_negative), .in_overflow(alu_overflow), .in_carry(alu_carry),
						 .out_zero(zero),    .out_negative(negative),    .out_overflow(overflow),    .out_carry(carry_out),
						 .clk, .rst(rst), .enable(SetFlagEx));

    logic [63:0] aluOut;

    alu mainAlu (
        .A(Rd1),
        .B(ALUin),
        .cntrl({1'b0, ALUOp1, ALUOp0}),
        .result(aluOut),
        .negative(alu_negative),
        .zero(alu_zero),
        .overflow(alu_overflow),
        .carry_out(alu_carry)
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
        .xfer_size(4'd8)
    );

    mux2xN_N #(64) memtoregmux (
        .i1(dataMemReadData),
        .i0(aluOut),
        .sel(MemToReg),
        .out(memtoregmuxout)
    );
    // Data Memory //

    // IF - ID Pipe
    DFF_N IFIDp1 (.q(instrID),.d(instrIF),.rst,.clk);

    // ID - EX Pipes
    DFF_N IDEXP1(#5)(.q(RdEX),.d(RdId),.rst,.clk);

    // EX - Mem Pipes
    DFF_N IDEXP1(#5)(.q(RdMem),.d(RdEX),.rst,.clk);

    // Mem - WB Pipes
	DFF_N MemWB1(#5)(.q(WriteDataWB), .d(WriteDataMem), .rst, .clk);
	DFF_N MemWB2(#5)(.q(RdWB), .d(RdMem), .rst, .clk);




endmodule
