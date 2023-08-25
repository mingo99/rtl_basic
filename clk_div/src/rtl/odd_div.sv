module odd_div #(
    parameter int N = 2
) (
    input  clk,
    input  rstn,
    output clk_out
);

    localparam int CNTMAX = N - 1;

    reg  [2:0] cnt;
    wire [2:0] cnt_nxt = cnt == CNTMAX ? 'b0 : cnt + 1'b1;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            cnt <= 'b0;
        end else begin
            cnt <= cnt_nxt;
        end
    end

    reg clkp;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            clkp <= 1'b0;
        end else if (cnt == CNTMAX || cnt == CNTMAX >> 1) begin
            clkp <= ~clkp;
        end
    end

    reg clkn;
    always @(negedge clk or negedge rstn) begin
        if (~rstn) begin
            clkn <= 1'b0;
        end else if (cnt == CNTMAX || cnt == CNTMAX >> 1) begin
            clkn <= ~clkn;
        end
    end

    assign clk_out = clkp | clkn;

endmodule

