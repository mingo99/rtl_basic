module tb_odd_div;

reg clk, rstn;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rstn = 0;
    #11
    rstn =1;
    #2000
    $finish;
end

odd_div #(
    .N          (5)
) u_odd_div (
    .clk        (clk),
    .rstn       (rstn),
    .clk_out    (clk_out)
);

initial begin
    $fsdbDumpfile("sim_output_pluson.fsdb");
    $fsdbDumpvars(0);
end

endmodule