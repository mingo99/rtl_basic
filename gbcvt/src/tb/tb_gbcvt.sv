module tb_gbcvt;

    localparam int DW = 4;

    reg [DW-1:0] bin_in;
    wire [DW-1:0] gray, bin_out;

    initial begin
        #10
        for (int i = 0; i < (1 << DW); ++i) begin
            bin_in = i;
            #10;
        end
        #20 $finish;
    end

    bin2gray #(
        .DW(DW)
    ) u_bin2gray (
        .bin (bin_in),
        .gray(gray)
    );

    gray2bin #(
        .DW(4)
    ) u_gray2bin (
        .gray(gray),
        .bin (bin_out)
    );

    initial begin
        $fsdbDumpfile("sim_output_pluson.fsdb");
        $fsdbDumpvars(0);
    end

endmodule

