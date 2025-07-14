
module top(
    input clk,
    output sda,
    output scl
);

wire sda_out, sda_en, beg;

assign sda = (sda_en) ? sda_out: 1'bz;

beg_com beg_com(
    .clk(clk),
    .beg(beg)
);
master master(
    .scl(scl),
    .sda_out(sda_out),
    .sda_en(sda_en),
    .sda_in(sda),
    .clk(clk),
    .beg(beg)
);
endmodule