module tb_cvt9to16;

reg clk, rstn;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rstn = 1;
    #6
    rstn = 0;
    #10
    rstn =1;
end

initial begin
    reset();
    send_pack(2);
    #100
    $finish;
end

reg [8:0] data_in;
reg [3:0] data_in_valid_bits;
reg data_in_valid;
reg data_in_sop;
reg data_in_eop;

task reset();
    @(negedge rstn);
    data_in <= 'b0;
    data_in_valid_bits <= 'b0;
    data_in_valid <= 'b0;
    data_in_sop <= 'b0;
    data_in_eop <= 'b0;
endtask

task send_data(input data, input valid_bits);
    @(posedge rstn);
    data_in <= data;
    data_in_valid <= 1'b1;
    data_in_valid_bits <= valid_bits;
    @(posedge clk);
    data_in <= 'b0;
    data_in_valid <= 'b0;
    data_in_valid_bits <= 'b0;
endtask

task send_pack(input length);
    reg [8:0] data;
    for (int i=0; i<length; ++i) begin
        data = $random;
        if(i==length-1) send_data(data, 8);
        send_data(data, 9);
    end
endtask

wire [15:0] data_out;
wire data_out_valid;
wire [4:0] data_out_valid_bits;

cvt9to16 u_cvt9to16 (
    .clk                    (clk),
    .rstn                   (rstn),
    .data_in                (data_in),
    .data_in_valid          (data_in_valid),
    .data_in_sop            (data_in_sop),
    .data_in_eop            (data_in_eop),
    .data_in_valid_bits     (data_in_valid_bits),
    .data_out               (data_out),
    .data_out_valid         (data_out_valid),
    .data_out_valid_bits    (data_out_valid_bits)
);

endmodule