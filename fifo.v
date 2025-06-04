module fifo(
    input clk,
    input rst_n,

    // Write interface
    input wr_en,
    input [7:0] data_in,
    output full,

    // Read interface
    input rd_en,
    output reg [7:0] data_out,
    output empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);

    reg [7:0] mem[7:0];
    reg [2:0] rd_ptr, wr_ptr;

    assign full = (fifo_words == 8);
    assign empty = (fifo_words == 0);

    always @(posedge clk) begin
        if (!rst_n) begin
            fifo_words <= 0;
            rd_ptr <= 0;
            wr_ptr <= 0;
            data_out <= 8'b0;
        end else begin
            // Write
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end

            // Read
            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end

            // Count logic
            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_words <= fifo_words + 1; // Write only
                2'b01: fifo_words <= fifo_words - 1; // Read only
                2'b11: fifo_words <= fifo_words;     // Both (no change)
                default: fifo_words <= fifo_words;   // Neither
            endcase
        end
    end

endmodule
