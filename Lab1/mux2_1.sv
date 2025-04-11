module mux2_1 (
    input logic sel,
    input logic [1:0] d,
    output logic q
);

    // q = (sel & d[1]) + (~sel & d[0])
    // need to hold both outputs of the ands
    logic [1:0] and_results;

    and (#50ps) AND_1 (and_results[1], sel, d[1]);
    
    // need to hold ~sel
    logic not_sel
    not (#50ps) NOT1 (not_sel, sel)
    and (#50ps) AND_0 (and_results[0], not_sel, d[0]);

    // out
    or (#50ps) OR (q, and_results[0], and_results[1]);

endmodule