module DFF_N #(parameter WIDTH = 32) (q, d, reset, clk);
    input logic [WIDTH-1:0] d;
    input logic clk, reset;
    output logic [WIDTH-1:0] q;
    
    genvar a;
    
    generate 
        for (a = 0; a < WIDTH; a++) begin : eachFlop
            D_FF oneFlop (.q(q[a]), .d(d[a]), .reset, .clk);
        end
    endgenerate
    
endmodule