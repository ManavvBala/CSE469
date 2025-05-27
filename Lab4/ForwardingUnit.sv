

module ForwardingUnit (
    input logic [4:0] IDEX_Rn, IDEX_Rm, IDEX_Rd,  // Added IDEX_Rd
    input logic [4:0] EXMEM_Rd,
    input logic EXMEM_RegWrite,
    input logic [4:0] MEMWB_Rd,
    input logic MEMWB_RegWrite,
    output logic [1:0] ForwardA, ForwardB
);
    always_comb begin
        // default
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // A Hazard (for Rn - first source register)
        // EX Hazard
        if ((EXMEM_RegWrite) & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rn)) begin
            ForwardA = 2'b10;
        end
        // MEM Hazard
        else if ((MEMWB_RegWrite) & (MEMWB_Rd != 5'd31) & !(EXMEM_RegWrite & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rn)) & (MEMWB_Rd == IDEX_Rn)) begin
            ForwardA = 2'b01;
        end

        // B Hazards (for both Rm and Rd - second source register and store data)
        // Check both Rm (for ALU operations) and Rd (for store operations)
        logic rm_hazard_ex, rm_hazard_mem, rd_hazard_ex, rd_hazard_mem;
        
        // Rm hazards
        rm_hazard_ex = (EXMEM_RegWrite) & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rm);
        rm_hazard_mem = (MEMWB_RegWrite) & (MEMWB_Rd != 5'd31) & !(EXMEM_RegWrite & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rm)) & (MEMWB_Rd == IDEX_Rm);
        
        // Rd hazards (for store instructions)
        rd_hazard_ex = (EXMEM_RegWrite) & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rd);
        rd_hazard_mem = (MEMWB_RegWrite) & (MEMWB_Rd != 5'd31) & !(EXMEM_RegWrite & (EXMEM_Rd != 5'd31) & (EXMEM_Rd == IDEX_Rd)) & (MEMWB_Rd == IDEX_Rd);
        
        // Forward B if either Rm or Rd has a hazard
        if (rm_hazard_ex || rd_hazard_ex) begin
            ForwardB = 2'b10;
        end
        else if (rm_hazard_mem || rd_hazard_mem) begin
            ForwardB = 2'b01;
        end
    end
endmodule