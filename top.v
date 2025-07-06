
module top(
    input beg,
    input clk,
    output sda,
    output scl
);

wire sda_out, sda_en;

assign sda = (sda_en) ? sda_out: 1'bz;

master master(
    .scl(scl),
    .sda_out(sda_out),
    .sda_en(sda_en),
    .sda_in(sda),
    .clk(clk),
    .beg(beg)
);
endmodule