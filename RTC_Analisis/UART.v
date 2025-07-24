module UART (
    input clk,
    input rx, //uart recibe el menos significativo
    output reg [7:0] rx_data,
    output reg rx_done
);
    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 9600; // bits por segundo que se transmiten por un canal en serie
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;

    reg [15:0] baud_cnt = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg = 10'b1111111111;
    reg receiving = 0;

    always @(posedge clk) begin
        if (!receiving && !rx) begin // detecta el bit 0, se supone que una linea en UART es similar a (0) (numero 8 bits) (stop = 1) // Secuencia de 10 bits
            receiving <= 1; //estado para saber si puedo recibir datos
            baud_cnt <= BAUD_TICK / 2;
            bit_index <= 0;
        end else if (receiving) begin
            if (baud_cnt == BAUD_TICK - 1) begin
                baud_cnt <= 0;
                shift_reg <= {rx, shift_reg[9:1]};
                bit_index <= bit_index + 1;

                if (bit_index == 9) begin
                    rx_done <= 1;
                    rx_data <= shift_reg[8:1]; 
                    receiving <= 0;
                end else begin
                    rx_done <= 0;
                end
            end else begin
                baud_cnt <= baud_cnt + 1;
            end
        end else begin
            rx_done <= 0;
        end
    end
endmodule