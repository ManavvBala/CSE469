module mux4xN_N #(parameter N = 64) (
input logic [N-1:0] i00, i01, i10, i11,
input logic [1:0] sel,
output logic [N-1:0] out
);

  genvar i;
  generate 
    for (i = 0; i < N; i++) begin : bitMux
      mux4_1 m(.d({i11[i], i10[i], i01[i], i00[i]}), .sel(sel), .q(out[i]));
    end
  endgenerate 

endmodule
