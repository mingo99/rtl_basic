module cvt9to16 (
    input             clk,
    rstn,
    input      [ 8:0] data_in,
    input             data_in_valid,
    input             data_in_sop,
    input             data_in_eop,
    input      [ 3:0] data_in_valid_bits,
    output reg [15:0] data_out,
    output reg        data_out_valid,
    output reg [ 4:0] data_out_valid_bits
);

    reg [4:0] bit_cnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            bit_cnt <= 'b0;
        end else begin
            casex ({
                data_in_eop, data_in_valid, data_out_valid
            })
                3'b110:  bit_cnt <= 'b0;
                3'b010:  bit_cnt <= bit_cnt + data_in_valid_bits;
                3'bx01:  bit_cnt <= bit_cnt - data_out_valid_bits;
                3'b011:  bit_cnt <= bit_cnt - (data_out_valid_bits - data_in_valid_bits);
                default: bit_cnt <= bit_cnt;
            endcase
        end
    end

    reg [31:0] valid_data;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            valid_data <= 'b0;
        end else if (data_in_valid) begin
            valid_data <= |data_in_valid_bits ? {data_in[8 : (9-data_in_valid_bits)], valid_data[31:data_in_valid_bits]} : valid_data;
        end
    end

    reg data_in_eop_reg;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            data_in_eop_reg <= 1'b0;
        end else begin
            data_in_eop_reg <= data_in_eop_reg;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            data_out_valid      <= 'b0;
            data_out_valid_bits <= 'b0;
        end else begin
            data_out_valid      <= bit_cnt[4] | (data_in_eop_reg & (|bit_cnt));
            data_out_valid_bits <= bit_cnt[4] ? 16 : bit_cnt;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            data_out <= 'b0;
        end else if (bit_cnt[4]) begin
            data_out <= valid_data[(32-bit_cnt)+:16];
        end else begin
            data_out <= |bit_cnt ? valid_data[32 : (33-bit_cnt)] : 'b0;
        end
    end

endmodule

