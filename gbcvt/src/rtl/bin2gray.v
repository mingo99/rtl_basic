module bin2gray #( 
    parameter SIZE = 4
)(
    input  wire [SIZE-1:0] bin,
    output wire [SIZE-1:0] gray
);

assign gary = (bin>>1) ^ bin

endmodule