`timescale 1ns/1ps //(unidad de tiempo)/(resolución)
`include "master.v"
`include "top.v"
`include "beg_com.v"

module tb_top ();

wire scl;
wire sda;

reg clk = 0;

always #10 clk = ~clk; // se simula un clock de 50MHz

top top(
    .clk(clk),
    .scl(scl),
    .sda(sda)
);

initial begin
    $dumpfile("tb_top.vcd");
    $dumpvars(-1,top);
    #8000000 $finish;
end

endmodule
