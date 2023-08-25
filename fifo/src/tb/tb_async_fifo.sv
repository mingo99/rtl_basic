///==------------------------------------------------------------------==///
/// testbench of synchronous fifo
///==------------------------------------------------------------------==///

`define ADDR_WIDTH 3
`define DATA_WIDTH 32

module tb_async_fifo ();
    reg wclk, rclk;
    reg wrstn, rrstn;
    reg [`DATA_WIDTH-1:0] data_in;
    wire [`DATA_WIDTH-1:0] data_out;
    wire empty;
    wire full;
    reg wr_en, rd_en;

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
        $display("\nstatus: %t Testbench started\n\n", $time);
        wrstn   = 1;
        rrstn   = 1;
        data_in = 0;
        #5 wrstn = 0;
        rrstn = 0;
        #10 wrstn = 1;
        rrstn = 1;
        $display("status: %t done reset", $time);
        repeat (5) @(posedge wclk);
        read_after_write(50);
        repeat (5) @(posedge wclk);
        read_all_after_write_all();
        repeat (5) @(posedge wclk);
        $finish;
    end

    //--------------------------------------------------------------------------
    // read after write task
    //--------------------------------------------------------------------------
    task static read_after_write(input logic [31:0] num_write);
        reg     [           31:0] idx;
        reg     [`DATA_WIDTH-1:0] valW;
        integer                   error;

        $display("status: %t Total number of write data : %d", $time, num_write);
        error = 0;
        for (idx = 0; idx < num_write; idx = idx + 1) begin
            valW = $urandom;
            write_fifo(full, valW);
            if (empty) @(posedge rclk);  // for empty response
            read_fifo(empty);
            if (data_out != valW) begin
                error = error + 1;
                $display("status: %t ERROR at idx:0x%08x D:0x%02x, but D:0x%02x expected", $time,
                         idx, data_out, valW);
            end
        end
        if (error == 0) $display("status: %t RAW Test Pass", $time);
    endtask

    //--------------------------------------------------------------------------
    // read all after write all task, write to fifo until it is full
    //--------------------------------------------------------------------------
    task static read_all_after_write_all();
        reg     [           31:0] index;
        reg     [`DATA_WIDTH-1:0] valW;
        reg     [`DATA_WIDTH-1:0] valC;
        integer                   error;

        error = 0;
        for (index = 0; index < 2 ** `ADDR_WIDTH; index = index + 1) begin
            valW = ~(index + 1);
            write_fifo(full, valW);
        end

        for (index = 0; index < 2 ** `ADDR_WIDTH; index = index + 1) begin
            valC = ~(index + 1);
            read_fifo(empty);
            if (data_out != valC) begin
                error = error + 1;
                $display("status: %t ERROR at Index:0x%08x D:0x%02x, but D:0x%02x expected", $time,
                         index, data_out, valC);
            end
        end

        if (error == 0) $display("status: %t RAAWA Test Pass", $time);
    endtask

    //--------------------------------------------------------------------------
    // write fifo task
    //--------------------------------------------------------------------------
    task static write_fifo(input logic fifo_full, input logic [`DATA_WIDTH-1:0] value);
        wr_en   <= ~fifo_full;
        data_in <= value;
        @(posedge wclk);
        wr_en <= 1'b0;
    endtask

    //--------------------------------------------------------------------------
    // read fifo task
    //--------------------------------------------------------------------------
    task static read_fifo(input logic fifo_empty);
        rd_en <= ~fifo_empty;
        @(posedge rclk);
        rd_en <= 1'b0;
    endtask

    async_fifo #(
        .DWIDTH(`DATA_WIDTH),
        .AWIDTH(`ADDR_WIDTH)
    ) u_async_fifo (
        .wclk (wclk),
        .rclk (rclk),
        .wrstn(wrstn),
        .rrstn(rrstn),
        .wren (wr_en),
        .rden (rd_en),
        .din  (data_in),
        .dout (data_out),
        .full (full),
        .empty(empty)
    );

    initial begin
        $fsdbDumpfile("sim_output_pluson.fsdb");
        $fsdbDumpvars();
        $fsdbDumpMDA();
    end

endmodule

