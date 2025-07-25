module alarm_led (
    input clk,
    input [7:0] Minutes,   
    input [7:0] Seconds,  
    //input [5:0] intervalo,       // Cada determinados minutos hasta la hora  (Multiplos)
    output reg buzzer,
    output reg [6:0] leds        
);

    reg [5:0] intervalo; 
    reg [2:0] led_index;
  

    initial begin
        intervalo <= 6'b000010;
        led_index <= 0;
    end

    wire [7:0] Minutes_C = (Minutes[7:4] * 8'd10) + Minutes[3:0]; 
    wire [7:0] Seconds_C = (Seconds[7:4] * 8'd10) + Seconds[3:0]; 

    always @(posedge clk) begin 

        if (Minutes_C % intervalo == 0) begin
            buzzer <= 0;

            case (led_index)
                3'd0: leds <= 7'b0000001;
                3'd1: leds <= 7'b0000010;
                3'd2: leds <= 7'b0000100;
                3'd3: leds <= 7'b0001000;
                3'd4: leds <= 7'b0010000;
                3'd5: leds <= 7'b0100000;
                3'd6: leds <= 7'b1000000;
            endcase

            if (Seconds_C < 6) begin
                if (
                    (Seconds_C >= 0  && Seconds_C < 1) || 
                    (Seconds_C >= 2  && Seconds_C < 3) || 
                    (Seconds_C >= 4  && Seconds_C < 5)
                ) begin
                    buzzer <= 0; 
                end else begin
                    buzzer <= 1; 
                end
            end else begin
                buzzer <= 1; 
            end

            led_index <= (led_index == 3'd6) ? 3'd0 : led_index + 1; // Cambiar los leds en cada coincidencia

        end else begin
            buzzer <= 1;
            leds <= 7'b0000000;
        end
    end

endmodule
