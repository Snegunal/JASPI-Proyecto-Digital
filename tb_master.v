`timescale 1ns/1ps //(unidad de tiempo)/(resolución)
`include "master.v"

module tb_master ();

wire scl;
wire sda;

reg clk = 0;
reg beg = 1'b0;

always #41.667 clk = ~clk; // se simula un clock de 12MHz

initial begin
    #416.67 beg = 1'b1;
end

master master(
    .clk(clk),
    .beg(beg),
    .scl(scl),
    .sda(sda)
);

initial begin
    $dumpfile("tb_master.vcd");
    $dumpvars(-1,master);
    #400000 $finish;
end

endmodule
