`timescale 1ns/10ps
module CPU (
    input logic clk,  // Clock signal
    input logic rst   // Reset signal
);

    //==============================================================================
    // SIGNAL DECLARATIONS FOR ALL PIPELINE STAGES
    //==============================================================================
    
    // Instruction signals through the pipeline
    logic [31:0] instrIF;   // Instruction fetched from instruction memory
    logic [31:0] instrID;   // Instruction in decode stage
    
    // Data path signals through pipeline stages
    // ID = Instruction Decode, EX = Execute, MEM = Memory, WB = Writeback
    logic [63:0] Rd1ID, Rd2ID;         // Register values read in ID stage
    logic [63:0] Rd1EX, Rd2EX;         // Register values in EX stage
    logic [63:0] ALUResultEX;          // ALU output in EX stage
    logic [63:0] ALUResultMem;         // ALU result in MEM stage
    logic [63:0] ALUResultWB;          // ALU result in WB stage
    logic [63:0] Rd2Mem;               // Value to be stored in memory (MEM stage)
    logic [63:0] DataMemOutMem;        // Data read from memory in MEM stage
    logic [63:0] DataMemOutWB;         // Data read from memory in WB stage
    logic [63:0] WriteData, WriteDataWB; // Final data to write back to registers
    
    // ALU flags for conditional operations
    logic negative, zero, overflow, carry_out;
    logic alu_zero, alu_negative, alu_overflow, alu_carry;
    
    // Control signals in ID stage
    logic Reg2Loc;        // 0: Rd as second reg, 1: Rm as second reg
    logic UncondBranch;   // 1: Unconditional branch
    logic BRTaken;        // 1: Branch taken
    logic MemReadID;      // 1: Read from memory
    logic MemToRegID;     // 0: ALU result to reg, 1: Memory data to reg
    logic ALUOpID0, ALUOpID1;  // ALU operation control
    logic MemWriteID;     // 1: Write to memory
    logic ALUSrc;         // 0: Register for ALU B input, 1: Immediate
    logic RegWriteID;     // 1: Write to register file
    logic ZExt;           // 0: Sign extend, 1: Zero extend
    logic BranchLink;     // 1: Branch with link (store return address)
    logic BranchRegister; // 1: Branch to register
    logic CheckForLT;     // 1: Check for less than condition
    logic SetFlagID;      // 1: Update CPU flags
    
    // Control signals in EX stage
    logic MemReadEX, MemToRegEX, ALUOpEX0, ALUOpEX1;
    logic MemWriteEX, ALUSrcEX, RegWriteEX, ZExtEX, SetFlagEX;
    
    // Control signals in MEM stage
    logic MemReadMem, MemToRegMem, MemWriteMem, RegWriteMem;
    
    // Control signals in WB stage
    logic MemToRegWB, RegWriteWB;
    
    // Register addresses through the pipeline
    logic [4:0] RnID, RmID, RdID;  // Register addresses in ID stage
    logic [4:0] RnEX, RmEX, RdEX;  // Register addresses in EX stage
    logic [4:0] RdMem, RdWB;       // Destination register in MEM and WB stages
    logic [4:0] WriteReg;          // Final register address for writeback
    
    // Immediate values and addressing
    logic [11:0] imm12ID, imm12EX;    // 12-bit immediate
    logic [8:0] dAddr9ID, dAddr9EX;    // 9-bit data address
    logic [25:0] brAddr26;             // 26-bit branch address
    logic [18:0] condAddr19;           // 19-bit conditional branch address
    logic [10:0] opcode;               // Instruction opcode
    
    //==============================================================================
    // INSTRUCTION DECODE
    //==============================================================================
    
    // Extract fields from instruction
    assign RdID = instrID[4:0];        // Destination register
    assign RnID = instrID[9:5];        // First source register
    assign RmID = instrID[20:16];      // Second source register
    assign opcode = instrID[31:21];    // Operation code
    assign imm12ID = instrID[21:10];   // 12-bit immediate value
    assign dAddr9ID = instrID[20:12];  // 9-bit data memory address
    assign brAddr26 = instrID[25:0];   // 26-bit branch address
    assign condAddr19 = instrID[23:5]; // 19-bit conditional branch address
    
    //==============================================================================
    // CONTROL UNIT
    //==============================================================================
    
    // Main CPU control unit - generates control signals based on opcode and flags
    ControlUnit control (
        .opcode(opcode),               // Input: Instruction opcode
        .negative(negative),           // Input: Negative flag
        .zero(zero),                   // Input: Zero flag
        .overflow(overflow),           // Input: Overflow flag
        .carry_out(carry_out),         // Input: Carry flag
        .Reg2Loc(Reg2Loc),             // Output: Register addressing mode
        .UncondBranch(UncondBranch),   // Output: Unconditional branch control
        .BRTaken(BRTaken),             // Output: Branch taken
        .MemRead(MemReadID),           // Output: Memory read enable
        .MemToReg(MemToRegID),         // Output: Memory to register bypass
        .ALUOp0(ALUOpID0),             // Output: ALU operation bit 0
        .ALUOp1(ALUOpID1),             // Output: ALU operation bit 1
        .MemWrite(MemWriteID),         // Output: Memory write enable
        .ALUSrc(ALUSrc),               // Output: ALU B-input source
        .RegWrite(RegWriteID),         // Output: Register write enable
        .ZExt(ZExt),                   // Output: Zero extension control
        .BranchLink(BranchLink),       // Output: Branch with link
        .BranchRegister(BranchRegister), // Output: Branch to register
        .CheckForLT(CheckForLT),       // Output: Check for less than
        .SetFlag(SetFlagID)            // Output: Set CPU flags
    );

    //==============================================================================
    // PIPELINE REGISTERS: ID/EX STAGE
    //==============================================================================
    
    // Control signals propagated from ID to EX stage
    D_FF ALUOpR0 (.q(ALUOpEX0), .d(ALUOpID0), .rst, .clk);  // ALU operation bit 0
    D_FF ALUOpR1 (.q(ALUOpEX1), .d(ALUOpID1), .rst, .clk);  // ALU operation bit 1
    D_FF flagSetR (.q(SetFlagEX), .d(SetFlagID), .rst, .clk); // Set flags
    D_FF MemWriteR0 (.q(MemWriteEX), .d(MemWriteID), .rst, .clk); // Memory write
    D_FF MemReadR0 (.q(MemReadEX), .d(MemReadID), .rst, .clk);    // Memory read
    D_FF MemToRegR0 (.q(MemToRegEX), .d(MemToRegID), .rst, .clk); // Memory to reg
    D_FF RegWriteR0 (.q(RegWriteEX), .d(RegWriteID), .rst, .clk); // Register write
    D_FF ALUSrcR (.q(ALUSrcEX), .d(ALUSrc), .rst, .clk);          // ALU source
    D_FF ZExtR (.q(ZExtEX), .d(ZExt), .rst, .clk);                // Zero extension
    
    // Data signals propagated from ID to EX stage
    DFF_N #(5) RnR (.q(RnEX), .d(RnID), .rst, .clk);     // First source reg address
    DFF_N #(5) RmR (.q(RmEX), .d(RmID), .rst, .clk);     // Second source reg address
    DFF_N #(5) RdR (.q(RdEX), .d(RdID), .rst, .clk);     // Destination reg address
    DFF_N #(12) imm12R (.q(imm12EX), .d(imm12ID), .rst, .clk); // 12-bit immediate
    DFF_N #(9) dAddr9R (.q(dAddr9EX), .d(dAddr9ID), .rst, .clk); // 9-bit address
    DFF_N #(64) Rd1R (.q(Rd1EX), .d(Rd1ID), .rst, .clk); // Register data 1
    DFF_N #(64) Rd2R (.q(Rd2EX), .d(Rd2ID), .rst, .clk); // Register data 2

    //==============================================================================
    // PIPELINE REGISTERS: EX/MEM STAGE
    //==============================================================================
    
    // Control signals propagated from EX to MEM stage
    D_FF MemWriteR1 (.q(MemWriteMem), .d(MemWriteEX), .rst, .clk);  // Memory write
    D_FF MemReadR1 (.q(MemReadMem), .d(MemReadEX), .rst, .clk);     // Memory read
    D_FF MemToRegR1 (.q(MemToRegMem), .d(MemToRegEX), .rst, .clk);  // Memory to reg
    D_FF RegWriteR1 (.q(RegWriteMem), .d(RegWriteEX), .rst, .clk);  // Register write
    
    // Data signals propagated from EX to MEM stage
    DFF_N #(5) RdEX_MEM (.q(RdMem), .d(RdEX), .rst, .clk);   // Destination reg
    DFF_N #(64) ALUResultEX_MEM (.q(ALUResultMem), .d(ALUResultEX), .rst, .clk); // ALU result
    DFF_N #(64) Rd2EX_MEM (.q(Rd2Mem), .d(Rd2EX), .rst, .clk); // Store data

    //==============================================================================
    // PIPELINE REGISTERS: MEM/WB STAGE
    //==============================================================================
    
    // Control signals propagated from MEM to WB stage
    D_FF RegWriteR2 (.q(RegWriteWB), .d(RegWriteMem), .rst, .clk);    // Register write
    D_FF MemToRegR2 (.q(MemToRegWB), .d(MemToRegMem), .rst, .clk);    // Memory to reg
    
    // Data signals propagated from MEM to WB stage
    DFF_N #(5) RdMEM_WB (.q(RdWB), .d(RdMem), .rst, .clk);   // Destination reg
    DFF_N #(64) ALUResultMEM_WB (.q(ALUResultWB), .d(ALUResultMem), .rst, .clk); // ALU result
    DFF_N #(64) DataMemOutMEM_WB (.q(DataMemOutWB), .d(DataMemOutMem), .rst, .clk); // Memory data

    //==============================================================================
    // PROGRAM COUNTER LOGIC
    //==============================================================================
    
    // Branch condition logic
    logic temp = 0;
    logic brSelect;
    logic notZero, negativeSelect;
    logic condBranchResult;

    // XOR of negative and overflow flags for less-than comparison
    xor #(50ps) xorCheck (negativeSelect, negative, overflow);
    
    // Select branch condition: zero or (negative XOR overflow)
    mux2xN_N condBrancMux (
        .i0(alu_zero),           // Zero flag
        .i1(negativeSelect),     // Less than condition
        .sel(CheckForLT),        // Select less than check
        .out(temp)               // Condition result
    );

    // AND condition with branch taken control
    and #(50ps) BranchAND (condBranchResult, temp, BRTaken);
    
    // OR unconditional branch with conditional result
    or  #(50ps) BranchOR (brSelect, UncondBranch, condBranchResult);

    // Address calculation for branches
    logic [63:0] nextAddrPreShift, nextAddrPostShift;
    logic [63:0] BRMuxout;
	 
    // Select between unconditional branch address (brAddr26) and conditional address (condAddr19)
    // with sign extension
    mux2xN_N #(64) ucondMux (
        .sel(UncondBranch),
        .i1({{38{brAddr26[25]}}, brAddr26}),     // Sign-extend 26-bit addr
        .i0({{45{condAddr19[18]}}, condAddr19}), // Sign-extend 19-bit addr
        .out(nextAddrPreShift)                   // Selected address
    );
	 
    logic [63:0] finalPCMuxIntermediate;
    logic [63:0] curPC, prevPC;

    // Select between calculated branch address and register branch (BranchRegister)
    mux2xN_N #(64) FinalPCMUX (
        .i0(finalPCMuxIntermediate),  // Calculated branch address
        .i1(Rd2ID),                   // Address from register
        .sel(BranchRegister),         // Branch to register?
        .out(curPC)                   // Final PC value
    );

    // Shift branch address left by 2 bits (multiply by 4)
    shifter brShifter (
        .value(nextAddrPreShift),  // Input address
        .direction(0),             // Left shift
        .distance(2),              // Shift by 2 bits
        .result(nextAddrPostShift) // Shifted address
    );

    // Program counter register
    PC pc (
        .clk(clk),
        .DataIn(curPC),    // New PC value
        .DataOut(prevPC),  // Current PC value
        .rst(rst)
    );

    // Calculate PC+4 (next sequential instruction)
    logic [63:0] regAddr, brAddr;
    adder_64bit regAdder (
        .A(prevPC),
        .B(64'd4),
        .out(regAddr)
    );

    // Calculate branch target address: PC + (sign-extended offset << 2)
    adder_64bit brAdder (
        .A(prevPC),
        .B(nextAddrPostShift),
        .out(brAddr)
    );

    // Select between PC+4 and branch target address
    mux2xN_N #(64) brMux (
        .sel(brSelect),        // Branch selection signal
        .i1(brAddr),           // Branch target address
        .i0(regAddr),          // PC+4
        .out(finalPCMuxIntermediate)  // Selected next PC
    );

    // Instruction memory
    instructmem imem (
        .address(prevPC),         // Current PC
        .instruction(instrIF),    // Fetched instruction
        .clk(clk)
    );

    //==============================================================================
    // IF/ID PIPELINE REGISTER
    //==============================================================================
    
    // Pipeline register to pass instruction from IF to ID stage
    DFF_N #(32) IF_ID_instr (.q(instrID), .d(instrIF), .rst, .clk);

    //==============================================================================
    // REGISTER FILE LOGIC
    //==============================================================================
    
    // Select between Rd and Rm as second register to read
    logic [4:0] Ab;
    mux2xN_N #(5) reglocmux (
        .i1(RmID),        // Second source register (Rm)
        .i0(RdID),        // Destination register (Rd)
        .sel(Reg2Loc),    // Register selection control
        .out(Ab)          // Selected register address
    );

    // Handle Branch and Link write address - select between Rd or x30 (link register)
    mux2xN_N #(5) BLAddrMux (
        .i0(RdWB),         // Normal destination register
        .i1(5'd30),        // x30 is link register
        .sel(BranchLink),  // Branch with link?
        .out(WriteReg)     // Final write register address
    );

    // Select between ALU result and Data Memory output for writeback
    mux2xN_N #(64) memToRegWB_mux (
        .i1(DataMemOutWB),  // Data from memory
        .i0(ALUResultWB),   // ALU result
        .sel(MemToRegWB),   // Memory to register control
        .out(WriteData)     // Selected data
    );

    // Handle Branch and Link write data - select between normal data or return address
    mux2xN_N #(64) BLDataMux (
        .i0(WriteData),    // Normal data to write
        .i1(regAddr),      // PC+4 for return address
        .sel(BranchLink),  // Branch with link?
        .out(WriteDataWB)  // Final data to write
    );

    // Register File
    regfile rf (
        .ReadRegister1(RnID),     // First source register address
        .ReadRegister2(Ab),       // Second source register address
        .WriteRegister(WriteReg), // Destination register address
        .WriteData(WriteDataWB),  // Data to write to register
        .RegWrite(RegWriteWB),    // Register write enable
        .clk(clk),                // Clock
        .ReadData1(Rd1ID),        // First source register value
        .ReadData2(Rd2ID)         // Second source register value
    );

    //==============================================================================
    // ALU LOGIC
    //==============================================================================
    
    logic [63:0] AluImmMuxOut, ALUBInput;

    // Extended immediate value selection - zero extend or sign extend
    mux2xN_N #(64) immExtMux (
        .i1({{52{1'b0}}, imm12EX}),       // Zero extend imm12
        .i0({{55{dAddr9EX[8]}}, dAddr9EX}), // Sign extend dAddr9
        .sel(ZExtEX),                      // Zero extension control
        .out(AluImmMuxOut)                 // Extended immediate
    );

    // Choose between register or immediate for ALU B input
    mux2xN_N #(64) alusrcmux (
        .i1(AluImmMuxOut),  // Immediate value
        .i0(Rd2EX),         // Register value
        .sel(ALUSrcEX),     // ALU source control
        .out(ALUBInput)     // Selected ALU B input
    );
	 
    // Flag register - stores flags for conditional operations
    flag_register regflag (
        .in_zero(alu_zero),        // ALU zero flag input
        .in_negative(alu_negative), // ALU negative flag input
        .in_overflow(alu_overflow), // ALU overflow flag input
        .in_carry(alu_carry),       // ALU carry flag input
        .out_zero(zero),            // Zero flag output
        .out_negative(negative),    // Negative flag output
        .out_overflow(overflow),    // Overflow flag output
        .out_carry(carry_out),      // Carry flag output
        .clk,                       // Clock
        .rst(rst),                  // Reset
        .enable(SetFlagEX)          // Flag update enable
    );

    // Main ALU - performs arithmetic and logic operations
    alu mainAlu (
        .A(Rd1EX),                       // First operand
        .B(ALUBInput),                   // Second operand
        .cntrl({1'b0, ALUOpEX1, ALUOpEX0}), // ALU operation code
        .result(ALUResultEX),            // ALU result
        .negative(alu_negative),         // Negative flag
        .zero(alu_zero),                 // Zero flag
        .overflow(alu_overflow),         // Overflow flag
        .carry_out(alu_carry)            // Carry flag
    );

    //==============================================================================
    // MEMORY STAGE
    //==============================================================================
    
    // Data Memory
    datamem dataMemory (
        .address(ALUResultMem),     // Memory address
        .write_enable(MemWriteMem), // Memory write enable
        .read_enable(MemReadMem),   // Memory read enable
        .write_data(Rd2Mem),        // Data to write
        .clk(clk),                  // Clock
        .read_data(DataMemOutMem),  // Data read from memory
        .xfer_size(4'd8)            // Transfer size (8 bytes)
    );

endmodule