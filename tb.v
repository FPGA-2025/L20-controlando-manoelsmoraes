`timescale 1ns/1ps

module tb();

    reg clk = 0;
    reg rst_n;
    wire wr_en;
    reg rd_en;
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    wire [3:0] fifo_words;

    fifo f(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .fifo_words(fifo_words)
    );

    fsm fsm(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .fifo_data(data_in),
        .fifo_words(fifo_words)
    );

    always #1 clk = ~clk;


    initial begin

        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        rst_n = 0;
        rd_en = 0;
        #2;
        rst_n = 1;

        #(10*2)

        if (fifo_words == 4'd6)
            $display("OK: Teste 1: FIFO contém 6 palavras após a escrita");
        else
            $display("ERRO: Teste 1: FIFO contém %d palavras, esperado 6", fifo_words);

        rd_en = 1;
        #(4*2)

        if (fifo_words == 4'd2)
            $display("OK: Teste 2: FIFO contém 2 palavras após a leitura");
        else
            $display("ERRO: Teste 2: FIFO contém %d palavras, esperado 2", fifo_words);

        #2;

        if (wr_en == 1)
            $display("OK: Teste 3: FIFO está em modo de escrita");
        else
            $display("ERRO: Teste 3: FIFO não está em modo de escrita um ciclo após chegar em 2 palavras");

        #(4*2);
        if (fifo_words == 4'd1)
            $display("OK: Teste 4: FIFO está mantendo 1 palavra devido a leitura e escrita ao mesmo tempo");
        else
            $display("ERRO: Teste 4: FIFO contém %d palavras, esperado 1. Deveria manter devido a leitura e escrita ao mesmo tempo", fifo_words);

        $finish;
    end
endmodule