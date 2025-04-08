module register #(parameter WIDTH = 64)(
    input logic clk, reset,
    input logic[WIDTH-1:0] DataIn,
    input logic WriteEnable,
    output logic[WIDTH-1:0] DataOut,
);

// generate multiple DFFs and chain together
genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin : genDFF
        DFF newDFF (.q(DataIn[i]), .d(DataOut[i]), .clk(clock), .*)
    end
endgenerate

endmodule