module intervalo_receiver (
    input clk,
    input [7:0] rx_data, // Recibe el dato
    input rx_done,
    output reg [7:0] intervalo
);
    always @(posedge clk) begin
        if (rx_done) begin
                intervalo <= rx_data - 8'd48;  // Pasa a ASCII
        end
    end
endmodule