
module top(
    input clk,
    inout sda,
    output scl,
    //output [0:6] SSeg,
    //output [7:0] an
    output [6:0] leds_out
    output [7:0] data,
    output rs,
    output rw,
    output enable;
    output [6:0] leds,
    output buzzer
);

wire sda_out, sda_en, beg;
wire [7:0] Seconds;
wire [3:0] bcd;
wire [7:0] c;
wire [7:0] Minutes;
wire [7:0] Hours;
wire [2:0] Acknowledge;

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

listen listen(
    .scl(scl),
    .sda(sda),
    .sda_en(sda_en),
    .beg(beg),
    .Seconds(Seconds),
    .Minutes(Minutes),
    .Hours(Hours),
    .Acknowledge(Acknowledge)
);

lcddin_mod lcd_display (
    .clk(clk),
    .Hours(Hours),
    .Minutes(Minutes),
    .rs(rs),
    .rw(rw),
    .data(data),
    .enable(enable)
);

alarm_led alarm_led (
    .clk(clk),
    .Minutes(Minutes),
    .buzzer(buzzer),
    .leds(leds)
);

/* BCD BCD(
    .Seconds(Seconds),  
    .Minutes(Minutes),
    .Hours(Hours),
    .clk(clk),
    .bcd(bcd),
    .c(c),
    .Acknowledge(Acknowledge)
);

BCDtoSSeg BCDtoSSeg(
    .bcd(bcd), 
    .c(c),
    .SSeg(SSeg), 
    .an(an)
); */
endmodule