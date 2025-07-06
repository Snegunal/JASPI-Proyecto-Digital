`timescale 1ns/1ps //(unidad de tiempo)/(resolución)
`include "master.v"
`include "top.v"

module tb_top ();

wire scl;
wire sda;

reg clk = 0;
reg beg = 1'b0;

always #41.667 clk = ~clk; // se simula un clock de 12MHz

initial begin
    #416000.67 beg = 1'b1;
end

top top(
    .clk(clk),
    .beg(beg),
    .scl(scl),
    .sda(sda)
);

initial begin
    $dumpfile("tb_top.vcd");
    $dumpvars(-1,top);
    #4000000 $finish;
end

endmodule
