module tb_top();

int a,b;
reg [2:0] c;

initial begin
    c = $random;
    $display(c);
    a = 11 % -3;
    b = -10 % 3;
    $display(a,b);
    $display("Or:%b",c|6'b0);
    $finish(1);
end

endmodule