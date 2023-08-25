module mtx_arb #(
    parameter int N = 3
) (
    input wire clk,
    input wire rstn,

    input wire upd,

    input  wire [N-1:0] req,
    output wire [N-1:0] gnt
);

    reg  [N-1:0] w    [N];
    wire [N-1:0] w_nxt[N];

    integer i, j;

    wire [N-1:0] dsbl;
    genvar col;

    generate
        for (col = 0; col < N; ++col) begin : gen_disable
            assign dsbl[col] = |(~w[col] & req);
        end
    endgenerate

    assign gnt = req & (~dsbl);


    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (int i = 0; i < N; ++i) begin
                for (int j = 0; j < N; ++j) begin
                    if (i > j) w[i][j] <= 0;
                    else w[i][j] <= 1;
                    //after reset,REQ0 has the highest priority
                end
            end
        end else begin
            if (upd) begin
                for (int i = 0; i < N; ++i) begin
                    if (gnt[i]) begin
                        for (int j = 0; j < N; ++j) begin
                            if (i != j) begin
                                w[i][j] <= 1'b0;
                                w[j][i] <= 1'b1;
                            end
                        end
                    end
                end
            end
        end
    end

endmodule

