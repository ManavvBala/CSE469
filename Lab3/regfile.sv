module regfile (
    input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister,
    input logic [63:0] WriteData,
    input logic RegWrite, clk,
    output logic [63:0] ReadData1, ReadData2
);

    // demux level
    logic [31:0] demux_out;
    demux5_32 demux1 (.in(RegWrite), .sel(WriteRegister), .out(demux_out));

    // unpacked array holding each bit for each register
    logic [63:0] register_values [31:0]; 
    genvar i;

    // registers created
    generate
        for (i = 0; i < 31; i ++) begin : genReg
            register newreg (.clk, .DataIn(WriteData), .WriteEnable(demux_out[i]), .DataOut(register_values[i]));
        end
    endgenerate
    register zero_reg (.clk, .DataIn(64'd0), .WriteEnable(64'd0), .DataOut(register_values[31]));

    // muxes
    mux64x32_1 mux1 (.in(register_values), .sel(ReadRegister1), .out(ReadData1));
    
    mux64x32_1 mux2 (.in(register_values), .sel(ReadRegister2), .out(ReadData2));
endmodule 