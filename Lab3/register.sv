module register #(parameter WIDTH = 64)(
    input logic clk,
    input logic[WIDTH-1:0] DataIn,
    input logic WriteEnable,
    output logic[WIDTH-1:0] DataOut
);

    // Generate multiple DFFs - one for each bit of the register
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : genDFF
            DFF_enable newDFF (
                .d(DataIn[i]),           
                .q(DataOut[i]),          
                .reset(1'b0),            
                .clk(clk),               
                .enable(WriteEnable)   
            );
        end
    endgenerate

endmodule