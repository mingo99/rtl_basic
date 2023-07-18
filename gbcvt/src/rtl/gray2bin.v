module gray2bin #( 
    parameter SIZE = 4
)(
    input  wire [SIZE-1:0] gray,
    output reg  [SIZE-1:0] bin
);

integer i; 

always @(gray) begin
    for (i=0; i<SIZE; i=i+1) begin
        bin[i] = ^(gray>>i); 
    end
end

endmodule