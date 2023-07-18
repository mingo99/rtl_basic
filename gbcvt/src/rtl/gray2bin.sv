module gray2bin #( 
    parameter DW = 4
)(
    input  wire [DW-1:0] gray,
    output reg  [DW-1:0] bin
);

integer i; 

always @(gray) begin
    for (i=0; i<DW; i=i+1) begin
        bin[i] = ^(gray>>i); 
    end
end

endmodule