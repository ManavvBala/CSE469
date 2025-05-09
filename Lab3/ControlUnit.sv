module ControlUnit (
    input logic [10:0] opcode,
    input logic negative, zero, overflow, carry_out,
    output logic Reg2Loc, 
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
    CheckForLT,
	 SetFlag
);

    // actual logic for instruction bits to cntrl bits
    always_comb begin
        casex (opcode)
            // ADDI
            11'b1001000100X: begin
                Reg2Loc = 1'b1;
                UncondBranch = 1'b0;
                BRTaken = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'b0;
                ALUOp1 = 1'b1;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                ZExt = 1'b1;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b1;
            end
            // ADDS
            11'b10101011000: begin
                Reg2Loc = 1'b1;
                UncondBranch = 1'b0;
                BRTaken = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'b0;
                ALUOp1 = 1'b1;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b1;
            end
            // SUBS
            11'b11101011000: begin
                Reg2Loc = 1'b1;
                UncondBranch = 1'b0;
                BRTaken = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'b1;
                ALUOp1 = 1'b1;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b1;
            end
            // B
            11'b000101XXXXX: begin
                Reg2Loc = 1'bX;
                UncondBranch = 1'b1;
                BRTaken = 1'b1;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'bX;
                ALUOp1 = 1'bX;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b0;
            end
            // B.LT
            11'b01010100XXX: begin
                Reg2Loc = 1'bX;
                UncondBranch = 1'b0;
                BRTaken = 1'b1; // change this based on flags
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'bX;
                ALUOp1 = 1'bX;
                MemWrite = 1'b0;
                ALUSrc = 1'bX;
                RegWrite = 1'b0;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'b1;
					 SetFlag = 1'b0;
            end
            // BL
            11'b100101XXXXX: begin
                Reg2Loc = 1'bX;
                UncondBranch = 1'b1;
                BRTaken = 1'b1;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'bX;
                ALUOp1 = 1'bX;
                MemWrite = 1'b0;
                ALUSrc = 1'bX;
                RegWrite = 1'b1;
                ZExt = 1'b0;
                BranchLink = 1'b1;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b0;
            end
            // BR
            11'b11010110000: begin
                Reg2Loc = 1'b0;
                UncondBranch = 1'b1;
                BRTaken = 1'b1;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'bX;
                ALUOp1 = 1'bX;
                MemWrite = 1'b0;
                ALUSrc = 1'bX;
                RegWrite = 1'b0;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b1;
                CheckForLT = 1'bX;
					 SetFlag = 1'b0;
            end
            // CBZ
            11'b10110100XXX: begin
                Reg2Loc = 1'b0;
                UncondBranch = 1'b0;
                BRTaken = 1'b1; // based on zero flag
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'b0;
                ALUOp1 = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'b0;
					 SetFlag = 1'b0;
            end
            // LDUR
            11'b11111000010: begin
                Reg2Loc = 1'bX;
                UncondBranch = 1'b0;
                BRTaken = 1'b0;
                MemRead = 1'b1;
                MemToReg = 1'b1;
                ALUOp0 = 1'b0;
                ALUOp1 = 1'b1;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b0;
            end
            // STUR
            11'b11111000000: begin
                Reg2Loc = 1'b0;
                UncondBranch = 1'b0;
                BRTaken = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp0 = 1'b0;
                ALUOp1 = 1'b1;
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                RegWrite = 1'b0;
                ZExt = 1'b0;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b0;
            end
            default: begin
                Reg2Loc = 1'bX;
                UncondBranch = 1'b0;
                BRTaken = 1'bX;
                MemRead = 1'b0;
                MemToReg = 1'bX;
                ALUOp0 = 1'bX;
                ALUOp1 = 1'bX;
                MemWrite = 1'b0;
                ALUSrc = 1'bX;
                RegWrite = 1'b1;
                ZExt = 1'bX;
                BranchLink = 1'b0;
                BranchRegister = 1'b0;
                CheckForLT = 1'bX;
					 SetFlag = 1'b0;
            end
        endcase
    end

endmodule