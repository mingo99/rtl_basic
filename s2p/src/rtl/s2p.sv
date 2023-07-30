module s2p(
	input wire			clka, 
	input wire			clkb, 
	input wire			rstn, 
	input wire			wra_n, 
	input wire			da,
	output reg 			wrb,
	output reg [7:0]	db
);

reg [7:0] apdata;
always @(posedge clka or negedge rstn) begin
	if(~rstn) begin
		apdata <= 'bx;
	end else if(~wra_n) begin
		apdata <= {apdata[6:0], da};
	end
end

reg [2:0] bq_wra_n;
always @(posedge clkb or negedge rstn) begin
	if(~rstn) begin
		bq_wra_n <= 'b0;
	end else begin
		bq_wra_n <= {bq_wra_n[1:0], wra_n};
	end
end

wire rising_bq_wra_n = bq_wra_n[1] & ~bq_wra_n[2];

always @(posedge clkb or negedge rstn) begin
	if(~rstn) begin
		wrb <= 'b0;
	end else if(rising_bq_wra_n) begin
		wrb <= 1'b1;
	end else begin
		wrb <= 1'b0;
	end
end

always @(posedge clkb or negedge rstn) begin
	if(~rstn) begin
		db <= 'b0;
	end else if(rising_bq_wra_n) begin
		db <= apdata;
	end
end

endmodule