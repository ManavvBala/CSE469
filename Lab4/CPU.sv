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
    logic UncondBranchEX, BRTakenEX, CheckForLTEX, BranchLinkEX, BranchRegisterEX;
    
    // Control signals in MEM stage
    logic MemReadMem, MemToRegMem, MemWriteMem, RegWriteMem;
    logic UncondBranchMem, BRTakenMem, CheckForLTMem, BranchLinkMem, BranchRegisterMem;
    
    // Control signals in WB stage
    logic MemToRegWB, RegWriteWB, BranchLinkWB;
    
    // Flag propagation through pipeline
    logic SetFlagMem;
    logic alu_zero_mem, alu_negative_mem, alu_overflow_mem, alu_carry_mem;
    
    // Register addresses through the pipeline
    logic [4:0] RnID, RmID, RdID;  // Register addresses in ID stage
    logic [4:0] RnEX, RmEX, RdEX;  // Register addresses in EX stage
    logic [4:0] RdMem, RdWB;       // Destination register in MEM and WB stages
    logic [4:0] WriteReg;          // Final register address for writeback
    
    // Immediate values and addressing
    logic [11:0] imm12ID, imm12EX;    // 12-bit immediate
    logic [8:0] dAddr9ID, dAddr9EX;    // 9-bit data address
    logic [25:0] brAddr26ID, brAddr26EX, brAddr26Mem;  // 26-bit branch address
    logic [18:0] condAddr19ID, condAddr19EX, condAddr19Mem; // 19-bit conditional branch address
    logic [10:0] opcode;               // Instruction opcode
    
    // PC and address calculation signals
    logic [63:0] PCID, PCEX, PCMem;   // PC values through pipeline
    logic [63:0] regAddrMem;          // PC+4 for branch and link in MEM stage
    
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
    assign brAddr26ID = instrID[25:0]; // 26-bit branch address
    assign condAddr19ID = instrID[23:5]; // 19-bit conditional branch address
    
    //==============================================================================
    // CONTROL UNIT
    //==============================================================================
    
    // Main CPU control unit - generates control signals based on opcode
    // Note: Branch decisions now made in MEM stage, so flags not used here
    ControlUnit control (
        .opcode(opcode),               // Input: Instruction opcode
        .negative(1'b0),               // Not needed for control generation
        .zero(1'b0),                   // Not needed for control generation
        .overflow(1'b0),               // Not needed for control generation
        .carry_out(1'b0),              // Not needed for control generation
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
    D_FF ALUOpR0 (.q(ALUOpEX0), .d(ALUOpID0), .reset(rst), .clk(clk));  // ALU operation bit 0
    D_FF ALUOpR1 (.q(ALUOpEX1), .d(ALUOpID1), .reset(rst), .clk(clk));  // ALU operation bit 1
    D_FF flagSetR (.q(SetFlagEX), .d(SetFlagID), .reset(rst), .clk(clk)); // Set flags
    D_FF MemWriteR0 (.q(MemWriteEX), .d(MemWriteID), .reset(rst), .clk(clk)); // Memory write
    D_FF MemReadR0 (.q(MemReadEX), .d(MemReadID), .reset(rst), .clk(clk));    // Memory read
    D_FF MemToRegR0 (.q(MemToRegEX), .d(MemToRegID), .reset(rst), .clk(clk)); // Memory to reg
    D_FF RegWriteR0 (.q(RegWriteEX), .d(RegWriteID), .reset(rst), .clk(clk)); // Register write
    D_FF ALUSrcR (.q(ALUSrcEX), .d(ALUSrc), .reset(rst), .clk(clk));          // ALU source
    D_FF ZExtR (.q(ZExtEX), .d(ZExt), .reset(rst), .clk(clk));                // Zero extension
    
    // Branch control signals propagated to EX stage
    D_FF UncondBranchR0 (.q(UncondBranchEX), .d(UncondBranch), .reset(rst), .clk(clk));
    D_FF BRTakenR0 (.q(BRTakenEX), .d(BRTaken), .reset(rst), .clk(clk));
    D_FF CheckForLTR0 (.q(CheckForLTEX), .d(CheckForLT), .reset(rst), .clk(clk));
    D_FF BranchLinkR0 (.q(BranchLinkEX), .d(BranchLink), .reset(rst), .clk(clk));
    D_FF BranchRegisterR0 (.q(BranchRegisterEX), .d(BranchRegister), .reset(rst), .clk(clk));
    
    // Data signals propagated from ID to EX stage
    DFF_N #(5) RnR (.q(RnEX), .d(RnID), .reset(rst), .clk(clk));     // First source reg address
    DFF_N #(5) RmR (.q(RmEX), .d(RmID), .reset(rst), .clk(clk));     // Second source reg address
    DFF_N #(5) RdR (.q(RdEX), .d(RdID), .reset(rst), .clk(clk));     // Destination reg address
    DFF_N #(12) imm12R (.q(imm12EX), .d(imm12ID), .reset(rst), .clk(clk)); // 12-bit immediate
    DFF_N #(9) dAddr9R (.q(dAddr9EX), .d(dAddr9ID), .reset(rst), .clk(clk)); // 9-bit address
    DFF_N #(64) Rd1R (.q(Rd1EX), .d(Rd1ID), .reset(rst), .clk(clk)); // Register data 1
    DFF_N #(64) Rd2R (.q(Rd2EX), .d(Rd2ID), .reset(rst), .clk(clk)); // Register data 2
    DFF_N #(64) PCR0 (.q(PCEX), .d(PCID), .reset(rst), .clk(clk));   // PC value
    DFF_N #(26) brAddr26R0 (.q(brAddr26EX), .d(brAddr26ID), .reset(rst), .clk(clk)); // 26-bit branch addr
    DFF_N #(19) condAddr19R0 (.q(condAddr19EX), .d(condAddr19ID), .reset(rst), .clk(clk)); // 19-bit cond addr

    //==============================================================================
    // PIPELINE REGISTERS: EX/MEM STAGE
    //==============================================================================
    
    // Control signals propagated from EX to MEM stage
    D_FF MemWriteR1 (.q(MemWriteMem), .d(MemWriteEX), .reset(rst), .clk(clk));  // Memory write
    D_FF MemReadR1 (.q(MemReadMem), .d(MemReadEX), .reset(rst), .clk(clk));     // Memory read
    D_FF MemToRegR1 (.q(MemToRegMem), .d(MemToRegEX), .reset(rst), .clk(clk));  // Memory to reg
    D_FF RegWriteR1 (.q(RegWriteMem), .d(RegWriteEX), .reset(rst), .clk(clk));  // Register write
    D_FF SetFlagR1 (.q(SetFlagMem), .d(SetFlagEX), .reset(rst), .clk(clk));     // Set flags
    
    // Branch control signals propagated to MEM stage
    D_FF UncondBranchR1 (.q(UncondBranchMem), .d(UncondBranchEX), .reset(rst), .clk(clk));
    D_FF BRTakenR1 (.q(BRTakenMem), .d(BRTakenEX), .reset(rst), .clk(clk));
    D_FF CheckForLTR1 (.q(CheckForLTMem), .d(CheckForLTEX), .reset(rst), .clk(clk));
    D_FF BranchLinkR1 (.q(BranchLinkMem), .d(BranchLinkEX), .reset(rst), .clk(clk));
    D_FF BranchRegisterR1 (.q(BranchRegisterMem), .d(BranchRegisterEX), .reset(rst), .clk(clk));
    
    // Data signals propagated from EX to MEM stage
    DFF_N #(5) RdEX_MEM (.q(RdMem), .d(RdEX), .reset(rst), .clk(clk));   // Destination reg
    DFF_N #(64) ALUResultEX_MEM (.q(ALUResultMem), .d(ALUResultEX), .reset(rst), .clk(clk)); // ALU result
    DFF_N #(64) Rd2EX_MEM (.q(Rd2Mem), .d(Rd2EX), .reset(rst), .clk(clk)); // Store data
    DFF_N #(64) PCR1 (.q(PCMem), .d(PCEX), .reset(rst), .clk(clk));     // PC value
    DFF_N #(26) brAddr26R1 (.q(brAddr26Mem), .d(brAddr26EX), .reset(rst), .clk(clk)); // 26-bit branch addr
    DFF_N #(19) condAddr19R1 (.q(condAddr19Mem), .d(condAddr19EX), .reset(rst), .clk(clk)); // 19-bit cond addr
    
    // ALU flags propagated to MEM stage
    D_FF alu_zero_R (.q(alu_zero_mem), .d(alu_zero), .reset(rst), .clk(clk));
    D_FF alu_negative_R (.q(alu_negative_mem), .d(alu_negative), .reset(rst), .clk(clk));
    D_FF alu_overflow_R (.q(alu_overflow_mem), .d(alu_overflow), .reset(rst), .clk(clk));
    D_FF alu_carry_R (.q(alu_carry_mem), .d(alu_carry), .reset(rst), .clk(clk));

    //==============================================================================
    // PIPELINE REGISTERS: MEM/WB STAGE
    //==============================================================================
    
    // Control signals propagated from MEM to WB stage
    D_FF RegWriteR2 (.q(RegWriteWB), .d(RegWriteMem), .reset(rst), .clk(clk));    // Register write
    D_FF MemToRegR2 (.q(MemToRegWB), .d(MemToRegMem), .reset(rst), .clk(clk));    // Memory to reg
    D_FF BranchLinkR2 (.q(BranchLinkWB), .d(BranchLinkMem), .reset(rst), .clk(clk)); // Branch link
	 
	 // Forwarding signals
    logic [1:0] ForwardA, ForwardB;
    logic [63:0] ForwardAMuxOut, ForwardBMuxOut;
    logic [63:0] ALUBInput;
    logic [63:0] regAddrWB;
    
    // Data signals propagated from MEM to WB stage
    DFF_N #(5) RdMEM_WB (.q(RdWB), .d(RdMem), .reset(rst), .clk(clk));   // Destination reg
    DFF_N #(64) ALUResultMEM_WB (.q(ALUResultWB), .d(ALUResultMem), .reset(rst), .clk(clk)); // ALU result
    DFF_N #(64) DataMemOutMEM_WB (.q(DataMemOutWB), .d(DataMemOutMem), .reset(rst), .clk(clk)); // Memory data
    DFF_N #(64) regAddrR (.q(regAddrWB), .d(regAddrMem), .reset(rst), .clk(clk)); // PC+4 for branch link


    
    // FORWARDING UNIT
    ForwardingUnit forwardingUnit (
        .IDEX_Rn(RnEX), 
        .IDEX_Rm(RmEX), 
        .EXMEM_Rd(RdMem), 
        .EXMEM_RegWrite(RegWriteMem),
        .MEMWB_Rd(RdWB), 
        .MEMWB_RegWrite(RegWriteWB), 
        .ForwardA(ForwardA), 
        .ForwardB(ForwardB)
    );
    
    // FORWARDING MUXES
    mux4xN_N #(64) ForwardAMux (
        .i00(Rd1EX), 
        .i01(WriteDataWB), 
        .i10(ALUResultMem), 
        .i11(64'b0), 
        .sel(ForwardA), 
        .out(ForwardAMuxOut)
    );
    mux4xN_N #(64) ForwardBMux (
        .i00(ALUBInput), 
        .i01(WriteDataWB), 
        .i10(ALUResultMem), 
        .i11(64'b0), 
        .sel(ForwardB), 
        .out(ForwardBMuxOut)
    );

    //==============================================================================
    // BRANCH DECISION LOGIC IN MEM STAGE
    //==============================================================================
    
    // Branch condition logic in MEM stage using propagated flags
    logic brSelect;
    logic negativeSelect;
    logic condBranchResult;
    logic temp;

    // Update CPU flags based on ALU results in MEM stage
    flag_register regflag (
        .in_zero(alu_zero_mem),        // ALU zero flag input
        .in_negative(alu_negative_mem), // ALU negative flag input
        .in_overflow(alu_overflow_mem), // ALU overflow flag input
        .in_carry(alu_carry_mem),       // ALU carry flag input
        .out_zero(zero),               // Zero flag output
        .out_negative(negative),       // Negative flag output
        .out_overflow(overflow),       // Overflow flag output
        .out_carry(carry_out),         // Carry flag output
        .clk(clk),                     // Clock
        .reset(rst),                     // Reset
        .enable(SetFlagMem)            // Flag update enable
    );

    // XOR of negative and overflow flags for less-than comparison
    xor #(50ps) xorCheck (negativeSelect, negative, overflow);
    
    // Select branch condition: zero or (negative XOR overflow)
    mux2xN_N #(1) condBranchMux (
        .i0(zero),               // Zero flag
        .i1(negativeSelect),     // Less than condition
        .sel(CheckForLTMem),     // Select less than check
        .out(temp)               // Condition result
    );

    // AND condition with branch taken control
    and #(50ps) BranchAND (condBranchResult, temp, BRTakenMem);
    
    // OR unconditional branch with conditional result
    or #(50ps) BranchOR (brSelect, UncondBranchMem, condBranchResult);

    //==============================================================================
    // PROGRAM COUNTER LOGIC
    //==============================================================================
    
    // Address calculation for branches in MEM stage
    logic [63:0] nextAddrPreShift, nextAddrPostShift;
    logic [63:0] brAddr, finalPCMuxIntermediate;
    logic [63:0] curPC, prevPC;
    
    logic [63:0] regAdderOut; // stores the output of PC + 4
    // Calculate PC+4 in MEM stage
    // MANAV HIGH THINKING: regAdder shouldn't be PCMem, it should be the current PC value
    adder_64bit regAdder (
        // was PCMem
        .A(prevPC),
        .B(64'd4),
        // shouldn't output to regAddrMem, should instead send to some intermediate to eventually get back to currPC
        .out(regAdderOut)
    );

    // Select between unconditional branch address (brAddr26) and conditional address (condAddr19)
    // with sign extension
    mux2xN_N #(64) ucondMux (
        .sel(UncondBranchMem),
        .i1({{38{brAddr26Mem[25]}}, brAddr26Mem}),     // Sign-extend 26-bit addr
        .i0({{45{condAddr19Mem[18]}}, condAddr19Mem}), // Sign-extend 19-bit addr
        .out(nextAddrPreShift)                         // Selected address
    );

    // Shift branch address left by 2 bits (multiply by 4)
    shifter brShifter (
        .value(nextAddrPreShift),  // Input address
        .direction(0),             // Left shift
        .distance(2),              // Shift by 2 bits
        .result(nextAddrPostShift) // Shifted address
    );

    // Calculate branch target address: PC + (sign-extended offset << 2)
    adder_64bit brAdder (
        .A(PCMem),
        .B(nextAddrPostShift),
        .out(brAddr)
    );

    // Select between PC+4 and branch target address
    mux2xN_N #(64) brMux (
        .sel(brSelect),        // Branch selection signal
        .i1(brAddr),           // Branch target address
        .i0(regAdderOut),       // PC+4
        .out(finalPCMuxIntermediate)  // Selected next PC
    );

    // Select between calculated branch address and register branch (BranchRegister)
    mux2xN_N #(64) FinalPCMUX (
        .i0(finalPCMuxIntermediate),  // Calculated branch address
        .i1(Rd2Mem),                  // Address from register (forwarded to MEM stage)
        .sel(BranchRegisterMem),      // Branch to register?
        .out(curPC)                   // Final PC value
    );

    // Program counter register
    PC pc (
        .clk(clk),
        .DataIn(curPC),    // New PC value
        .DataOut(prevPC),  // Current PC value
        .rst(rst)
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
    
    // Pipeline register to pass instruction and PC from IF to ID stage
    DFF_N #(32) IF_ID_instr (.q(instrID), .d(instrIF), .reset(rst), .clk(clk));
    DFF_N #(64) IF_ID_PC (.q(PCID), .d(prevPC), .reset(rst), .clk(clk));

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
        .sel(BranchLinkWB), // Branch with link?
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
        .i1(regAddrWB),    // PC+4 for return address
        .sel(BranchLinkWB), // Branch with link?
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
    
    logic [63:0] AluImmMuxOut;

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

    // Main ALU - performs arithmetic and logic operations
    alu mainAlu (
        .A(ForwardAMuxOut),              // First operand (with forwarding)
        .B(ForwardBMuxOut),              // Second operand (with forwarding)
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