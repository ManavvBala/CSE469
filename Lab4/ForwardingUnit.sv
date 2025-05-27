module ForwardingUnit (
    input logic [4:0] IDEX_Rn, IDEX_Rm,
    input logic [4:0] EXMEM_Rd,
    input logic EXMEM_RegWrite,
    input logic [4:0] MEMWB_Rd,
    input logic MEMWB_RegWrite,
    output logic [1:0] ForwardA, ForwardB
);
    always_comb begin
        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ForwardA Hazards (for IDEX_Rn - first source register)
        // EX Hazard: Forward from EX/MEM stage
        if ((EXMEM_RegWrite) && (EXMEM_Rd != 5'd31) && (EXMEM_Rd == IDEX_Rn)) begin
            ForwardA = 2'b10;  // Forward from EX/MEM stage
        end
        // MEM Hazard: Forward from MEM/WB stage (only if no EX hazard)
        else if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (MEMWB_Rd == IDEX_Rn)) begin
            ForwardA = 2'b01;  // Forward from MEM/WB stage
        end

        // ForwardB Hazards (for IDEX_Rm - second source register)
        // EX Hazard: Forward from EX/MEM stage
        if ((EXMEM_RegWrite) && (EXMEM_Rd != 5'd31) && (EXMEM_Rd == IDEX_Rm)) begin
            ForwardB = 2'b10;  // Forward from EX/MEM stage
        end
        // MEM Hazard: Forward from MEM/WB stage (only if no EX hazard)
        else if ((MEMWB_RegWrite) && (MEMWB_Rd != 5'd31) && (MEMWB_Rd == IDEX_Rm)) begin
            ForwardB = 2'b01;  // Forward from MEM/WB stage
        end
    end
endmodule