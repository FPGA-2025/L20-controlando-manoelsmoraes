module fsm(
    input clk,
    input rst_n,

    output reg wr_en,
    output [7:0] fifo_data,

    input [3:0] fifo_words
);

    // Dados constantes
    assign fifo_data = 8'hAA;

    // Estados codificados manualmente
    localparam WRITING        = 2'd0;
    localparam WAIT_TO_STOP   = 2'd1;
    localparam STOPPED        = 2'd2;
    localparam WAIT_TO_START  = 2'd3;

    reg [1:0] state, next_state;

    // Transição de estado (reset síncrono)
    always @(posedge clk) begin
        if (!rst_n)
            state <= WRITING;
        else
            state <= next_state;
    end

    // Lógica de transição
    always @(*) begin
        case (state)
            WRITING: begin
                if (fifo_words == 5)
                    next_state = WAIT_TO_STOP;
                else
                    next_state = WRITING;
            end

            WAIT_TO_STOP: begin
                next_state = STOPPED;
            end

            STOPPED: begin
                if (fifo_words <= 2)
                    next_state = WAIT_TO_START;
                else
                    next_state = STOPPED;
            end

            WAIT_TO_START: begin
                next_state = WRITING;
            end

            default: next_state = WRITING;
        endcase
    end

    // Sinal de controle wr_en
    always @(*) begin
        case (state)
            WRITING:        wr_en = 1;
            default:        wr_en = 0;
        endcase
    end

endmodule
