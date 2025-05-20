`timescale 1ns/10ps
module isZero (
    input logic [63:0] in,
    output logic out
);

    logic [62:0] tmp;

    // first two elements are ored together
    or OR (tmp[0], in[0], in[1]);

    genvar i;
    generate
        // loop through remaining tmp
        for (i = 1; i < 63; i++) begin : newOr
            or newOr (tmp[i], in[i + 1], tmp[i-1]);
        end
    endgenerate

    not #(50ps) outNOT (out, tmp[62]);

endmodule