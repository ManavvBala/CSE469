module demux (
    input logic in;
    input logic[4:0] sel;
    output logic[30:0] out;
);

    // cases or just assign
    always_comb
        case (sel)
            : 
            default: 
        endcase

endmodule