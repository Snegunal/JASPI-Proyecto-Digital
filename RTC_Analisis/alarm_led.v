
module alarm_led (
    input clk,
    input [7:0] Minutes,     
    //input [5:0] intervalo,       // Cada determinados minutos hasta la hora  (Multiplos)
    output reg buzzer,
    output reg [6:0] leds        
);

    reg [5:0] intervalo = 6'b000101;
    reg [7:0] last_min_bin = 0;
    reg [2:0] led_index = 0;

    wire [7:0] Minutes_C = (Minutes[7:4] * 8'd10) + Minutes[3:0]; 

    always @(posedge clk) begin
        buzzer <= 0; 

        if (Minutes_C ! = last_min_bin && (Minutes_C % intervalo == 0)) begin
            buzzer <= 1;
            last_min_bin <= Minutes_C; // Ultimo dato del minuto

            case (led_index)
                3'd0: leds <= 7'b0000001;
                3'd1: leds <= 7'b0000010;
                3'd2: leds <= 7'b0000100;
                3'd3: leds <= 7'b0001000;
                3'd4: leds <= 7'b0010000;
                3'd5: leds <= 7'b0100000;
                3'd6: leds <= 7'b1000000;
            endcase

            led_index <= (led_index == 3'd6) ? 3'd0 : led_index + 1; // Cambiar los leds en cada coincidencia
        end else if (Minutes_C != last_min_bin) begin
            last_min_bin <= Minutes_C;
        end
    end

endmodule
