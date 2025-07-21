module alarm_led (
    input clk,
    input [7:0] Minutes,   
    input [7:0] Seconds,  
    //input [5:0] intervalo,       // Cada determinados minutos hasta la hora  (Multiplos)
    output reg buzzer,
    output reg [6:0] leds        
);

    reg [5:0] intervalo; 
    reg [7:0] last_min_bin;
    reg [2:0] led_index;

    initial begin
        intervalo <= 6'b000010;
        last_min_bin <= 0;
        led_index <= 0;
        buzzer <= 1;
    end

    wire [7:0] Minutes_C = (Minutes[7:4] * 8'd10) + Minutes[3:0]; 
    wire [7:0] Seconds_C = (Seconds[7:4] * 8'd10) + Seconds[3:0]; 

    always @(posedge clk) begin 

        if ((Minutes_C != last_min_bin) & (Minutes_C % intervalo == 0)) begin
            last_min_bin <= Minutes_C; // Ultimo dato del minuto

            case (led_index)
                3'd0: leds <= 7'b1111110;
                3'd1: leds <= 7'b1111101;
                3'd2: leds <= 7'b1111011;
                3'd3: leds <= 7'b1110111;
                3'd4: leds <= 7'b1101111;
                3'd5: leds <= 7'b1011111;
                3'd6: leds <= 7'b0111111;
            endcase

            led_index <= (led_index == 3'd6) ? 3'd0 : led_index + 1; // Cambiar los leds en cada coincidencia

            if (Seconds_C < 8) begin
                if (
                    (Seconds_C >= 0  && Seconds_C <= 1) || 
                    (Seconds_C >= 3  && Seconds_C <= 4) || 
                    (Seconds_C >= 6  && Seconds_C <= 7)
                ) begin
                    buzzer <= 0; 
                end else begin
                    buzzer <= 1; 
                end
            end else begin
                buzzer <= 1; 
            end

        end else if (Minutes_C != last_min_bin) begin
            last_min_bin <= Minutes_C;
            buzzer <= 1;
            leds <= 7'b1111111;
        end
    end

endmodule
