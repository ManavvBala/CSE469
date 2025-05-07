module mux2xN_N #(parameter N = 64) (
input logic [N-1:0] i1,
input logic [N-1:0] i0,
input logic sel,
output logic [N-1:0] out);

  genvar i;
  generate 
    for (i = 0; i < N; i++) begin : bitMux
      mux2_1 m(.in({i1[i], i0[i]}), .sel(sel), .out(out[i]));
    end
  endgenerate 

endmodule
