module fsm(
    input clk,
    input rst_n,

    output reg wr_en,
    output [7:0] fifo_data,

    input [3:0] fifo_words
);

    assign fifo_data = 8'hAA;

    reg [1:0] state, next_state;

    localparam WRITING        = 2'd0;
    localparam WAIT_TO_STOP   = 2'd1;
    localparam STOPPED        = 2'd2;
    localparam WAIT_TO_START  = 2'd3;

    // Estado
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= WRITING;
        else
            state <= next_state;
    end

    // Transição de estados
    always @(*) begin
        case (state)
            WRITING:
                next_state = (fifo_words == 5) ? WAIT_TO_STOP : WRITING;

            WAIT_TO_STOP:
                next_state = STOPPED;

            STOPPED:
                next_state = (fifo_words <= 2) ? WAIT_TO_START : STOPPED;

            WAIT_TO_START:
                next_state = WRITING;

            default:
                next_state = WRITING;
        endcase
    end

    // wr_en só habilita em estado WRITING
    always @(*) begin
        wr_en = (state == WRITING);
    end

endmodule
