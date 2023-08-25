module tb_clk_div ();
    reg clk;
    reg rst_n;
    reg [7:0] div_num;
    wire clk_out;
    reg [11:0] rl = 10;

    initial begin
        clk = 0;
        rst_n = 1;
        div_num = 0;
        #200 rst_n = 0;
        #100 rst_n = 1;
        #20 div_num = 1;
        #200 div_num = 2;
        #200 div_num = 3;
        #200 div_num = 4;
        #200 div_num = 5;
        #200 $display("%h", 14'bx0_1010);
        $display("rl=%0d=%0h", rl, rl);
        $finish(2);
    end

    always #5 clk = ~clk;


`ifdef DUMP_VPD
    initial begin
        $vcdpluson;
    end
`endif

`ifdef DUMP_VCD
    initial begin
        $vcdplusfile("sim_output_pluson.vpd");
        $vcdpluson(0, clk_div_inst);
    end
`endif

`ifdef DUMP_FSDB
    initial begin
        $fsdbDumpfile("sim_output_pluson.fsdb");
        $fsdbDumpvars(0, clk_div_inst);
    end
`endif

    clk_div clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .div_num(div_num),
        .clk_out(clk_out)
    );

endmodule
