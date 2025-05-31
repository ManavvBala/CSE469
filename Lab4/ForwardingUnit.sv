module ForwardingUnit (
    input logic [4:0] IDEX_Rn, IDEX_Rm, IDEX_Rd,
    input logic [4:0] IFID_Rn, IFID_Rm, IFID_Rd,
    input logic [4:0] EXMEM_Rd,
    input logic EXMEM_RegWrite,
	 input logic IDEX_RegWrite,
    input logic [4:0] MEMWB_Rd,
    input logic MEMWB_RegWrite,
    output logic [1:0] ForwardA, ForwardB, ForwardRd,
    output logic ForwardTryA, ForwardTryB,
	 output logic CBZForward
);

    always_comb begin
        // Default values
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        ForwardTryA = 1'b0;
        ForwardTryB = 1'b0;
		  ForwardRd = 2'b00;  // New forwarding path for Rd
		  CBZForward = 1'b0;
        
        // ForwardA Logic (for IDEX_Rn - first source register)
        // EX Hazard has priority over MEM Hazard
        if ((EXMEM_RegWrite) && (EXMEM_Rd != 5'd31) && (EXMEM_Rd == IDEX_Rn)) begin
            ForwardA = 2'b10;  // Forward from EX/MEM
        end
        else if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (MEMWB_Rd == IDEX_Rn)) begin
            ForwardA = 2'b01;  // Forward from MEM/WB
        end

		  if ((EXMEM_RegWrite) && (EXMEM_Rd != 5'd31) && (EXMEM_Rd == IDEX_Rm)) begin
            ForwardB = 2'b10;  // Forward from EX/MEM
        end
        else if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (MEMWB_Rd == IDEX_Rm)) begin
            ForwardB = 2'b01;  // Forward from MEM/WB
        end
		  
		  // ForwardRd Logic (for IDEX_Rd when used as source in stores)
        if ((EXMEM_RegWrite) && (EXMEM_Rd != 5'd31) && (EXMEM_Rd == IDEX_Rd)) begin
            ForwardRd = 2'b10;
        end
        else if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (MEMWB_Rd == IDEX_Rd)) begin
            ForwardRd = 2'b01;
        end
        
		  // Branch forwarding for CBZ
		  if ((IDEX_RegWrite) && (IDEX_Rd != 5'd31) && (IFID_Rd == IDEX_Rd)) begin
				CBZForward = 1'b1;
		  end
		  
        // for ID stage register reads when modified in writeback
        if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (IFID_Rn == MEMWB_Rd)) begin
            ForwardTryA = 1'b1;
        end
        if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (IFID_Rm == MEMWB_Rd)) begin
            ForwardTryB = 1'b1;
        end
    end
endmodule