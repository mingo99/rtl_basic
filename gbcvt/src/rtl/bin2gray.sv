module bin2gray #(
    parameter int DW = 4
) (
    input  wire [DW-1:0] bin,
    output wire [DW-1:0] gray
);

    assign gray = (bin >> 1) ^ bin;

endmodule

