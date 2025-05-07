module regfile (
    input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister,
    input logic [63:0] WriteData,
    input logic RegWrite, clk,
    output logic [63:0] ReadData1, ReadData2
);
    logic write_enable;
    assign write_enable = RegWrite;


    logic [31:0] demux_out;
    demux5_32 demux1 (.in(write_enable), .sel(WriteRegister), .out(demux_out));

    // Array to hold the values of all 32 registers
    logic [63:0] register_values [31:0]; 

    genvar i;
    generate
        for (i = 0; i < 31; i++) begin : genReg
            register newreg (
                .clk(clk),
                .DataIn(WriteData),
                .WriteEnable(demux_out[i]),
                .DataOut(register_values[i])
            );
        end
    endgenerate
    

    assign register_values[31] = 64'd0;

    // Multiplexers to select which register to read from
    mux64x32_1 mux1 (.in(register_values), .sel(ReadRegister1), .out(ReadData1));
    mux64x32_1 mux2 (.in(register_values), .sel(ReadRegister2), .out(ReadData2));

endmodule