///==------------------------------------------------------------------==///
/// testbench of synchronous fifo
///==------------------------------------------------------------------==///

`define ADDR_WIDTH 3
`define DATA_WIDTH 32

module tb_async_fifo ();
    reg  wclk,rclk;
    reg  wrstn,rrstn;
    reg  [`DATA_WIDTH-1:0] data_in;
    reg  [`DATA_WIDTH-1:0] data;
    wire [`DATA_WIDTH-1:0] data_out;
    wire empty;
    wire full;
    reg wr_en, rd_en;
    reg wr_factor,rd_factor;

    initial begin
        wclk = 0;
        rclk = 0;
        fork 
            forever #5 wclk = ~wclk;
            forever #7 rclk = ~rclk;
        join
    end


    /// Run simulation
    initial begin
        wrstn     = 1;
        rrstn     = 1;
        rd_en     = 0;
        wr_en     = 0;
        data_in   = 0;
        #5 
        wrstn  = 0;
        rrstn  = 0;
        #10 
        wrstn = 1;
        rrstn = 1;

        #600 $finish;
    end

    initial begin
        wr_factor = 0;
        @(posedge wrstn);
        wr_factor = 1;
        #310
        wr_factor = 0;
        #305
        wr_factor = 1;
        #910
        wr_factor = 0;
    end

    initial begin
        rd_factor = 0;
        @(posedge rrstn);
        rd_factor = 0;
        #105
        rd_factor = 1;
        #915
        rd_factor = 1;
    end

    always @(*) begin
        wr_en = ~full&wr_factor;
        rd_en = ~empty&rd_factor;
    end

    initial begin
        @(posedge rrstn);
        forever begin
            @(posedge rclk iff rd_en);
            $display("Pop data: %d", data_out);
        end
    end

    initial begin
        @(posedge wrstn);
        forever begin
            data_in <= data_in + 1;
            @(posedge wclk iff wr_en);
            $display("Push data: %d", data_in);
        end
    end


async_fifo #(
    .DWIDTH    (`DATA_WIDTH),
    .AWIDTH    (`ADDR_WIDTH)
) u_async_fifo (
    .wclk      (wclk),
    .rclk      (rclk),
    .wrstn     (wrstn),
    .rrstn     (rrstn),
    .wren      (wr_en),
    .rden      (rd_en),
    .wdata     (data_in),
    .rdata     (data_out),
    .wfull     (full),
    .rempty    (empty)
);

initial begin
    $fsdbDumpfile("sim_output_pluson.fsdb");
    $fsdbDumpvars();
    $fsdbDumpMDA();
end

endmodule