module tb_clocking;

bit vld, grt, clk;

clocking ck @(posedge clk);
	default input #3ns output #3ns;
	input vld;
	output grt;
endclocking

initial begin
	clk = 0;
	forever #5 clk <= ~clk;
end

initial begin: drv_vld
	$display("$%0t vld intial value is %d", $time, vld);
	#3ns  vld = 1; $display("$%0t vld is assigned %d", $time, vld);
	#10ns vld = 0; $display("$%0t vld is assigned %d", $time, vld);
	#8ns  vld = 1; $display("$%0t vld is assigned %d", $time, vld);
	#100ns $finish();
end

initial begin: drv_grt
	$display("$%0t grt intial value is %d", $time, grt);
	@ck ck.grt <= 1; $display("$%0t grt is assigned 1", $time);
	@ck ck.grt <= 0; $display("$%0t grt is assigned 0", $time);
	@ck ck.grt <= 1; $display("$%0t grt is assigned 1", $time);
end

initial begin
	fork
		forever @ck $display("$%0t ck.vld is sampledas %d at sampling time $%0t", $time, ck.vld, $time-3);
		forever @ck $display("$%0t vld is sampled as %d at sampling time $%0t", $time, vld, $time);
		forever @grt $display("$%0t grt is driven as %d", $time, grt);
	join
end

initial begin
	$fsdbDumpfile("sim_output_pluson.fsdb");
	$fsdbDumpvars();
end

endmodule