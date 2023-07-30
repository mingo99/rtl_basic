module tb_s2p;

reg clka,clkb,rstn,wra_n,da;
wire wrb;
wire [7:0] db;

initial begin
	clka = 0;
	clkb = 0;
	fork
		forever #5 clka = ~clka;
		forever #7 clkb = ~clkb;
	join_none
end

initial begin
	rstn = 1;
	#10
	rstn = 0;
	#30
	rstn = 1;
	wra_n <= 0;
	repeat(8) begin
		@(posedge clka);
		da <= $random;
	end
	wra <= 1;
	#50 $finish();
end

s2p u_s2p (
    .clka     (clka),
    .clkb     (clkb),
    .rstn     (rstn),
    .wra_n    (wra_n),
    .da       (da),
    .wrb      (wrb),
    .db       (db)
);

initial begin
	fsdbDumpfile("sim_output_pluson.fsdb");
	fsdbDumpvars();
end

endmodule