module clk_div(

input clk,
input rst_n,
input [7:0] div_num,

output reg clk_out
);
reg [7:0] cnt;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt<=0;
	else if(cnt<div_num)
		cnt<=cnt+1'b1;
	else if(cnt==div_num)
		cnt<=0;
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		clk_out<=0;
	else if (cnt==div_num-1)
		clk_out<=clk_out;
	else
		clk_out<=~clk_out;
endmodule
