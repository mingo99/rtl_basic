module tb_mtx_arb;

    localparam logic [3:0] N = 3;

    reg clk, rstn, upd;
    reg  [N-1:0] req;
    wire [N-1:0] gnt;

    initial begin
        rstn = 0;
        #11 rstn = 1;
    end

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        #4 upd = 1'b1;
        req = 3'b000;
        #7 req = 3'b111;
        #10 req = 3'b111;
        #10 req = 3'b101;
        #10 req = 3'b101;
        #10 req = 3'b100;
        #10 req = 3'b000;
        #10 req = 3'b010;
        #10 upd = 1'b0;
        #50 $finish;
    end

    initial begin
        $fsdbDumpfile("sim_output_pluson.fsdb");
        $fsdbDumpvars();
        $fsdbDumpMDA();
    end

    mtx_arb #(
        .N(3)
    ) u_mtx_arb (
        .clk (clk),
        .rstn(rstn),
        .upd (upd),
        .req (req),
        .gnt (gnt)
    );

endmodule

