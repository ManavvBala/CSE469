module ForwardingUnit (
    input logic [4:0] IDEX_Rn, IDEX_Rm,
    input logic [4:0] EXMEM_Rd,
    input logic EXMEM_RegWrite,
    input logic [4:0] MEMWB_Rd,
    input logic MEMWB_RegWrite,
    output logic [1:0] ForwardA, ForwardB, ForwardStore
);
    always_comb begin
        // default
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        ForwardStore = 2'b00;

        // A Hazard
        // EX Hazard
        if ((EXMEM_RegWrite) & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rn)) begin
            ForwardA = 2'b10;
        end
        // MEM Haza
        else if ((MEMWB_RegWrite) & (MEMWB_Rd != 5'd31) & !(EXMEM_RegWrite & (EXMEM_Rd != 5'd31)) & (EXMEM_Rd != IDEX_Rn) & (MEMWB_Rd == IDEX_Rn)) begin
            ForwardA = 2'b01;
        end

        // B Hazards
        // EX Hazard
        if ((EXMEM_RegWrite) & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rm)) begin
            ForwardB = 2'b10;
        end
        // MEM Hazard
        else if ((MEMWB_RegWrite) & (MEMWB_Rd != 5'd31) & !(EXMEM_RegWrite & (EXMEM_Rd != 5'd31)) & (EXMEM_Rd != IDEX_Rm) & (MEMWB_Rd == IDEX_Rm)) begin
            ForwardB = 2'b01;
        end
		
			// store forwarding
        if ((EXMEM_RegWrite) & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rm)) begin
            ForwardStore = 2'b10;  // Forward from EX/MEM stage
        end
        else if ((MEMWB_RegWrite) & (MEMWB_Rd != 5'd31) & (MEMWB_Rd == IDEX_Rm)) begin
            ForwardStore = 2'b01;  // Forward from MEM/WB stage
        end

    end
endmodule