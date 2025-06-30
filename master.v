module master(
    output reg scl,
    output reg sda,
    input clk,
    input beg
);

parameter Default = 3'b000, Start = 3'b001, Send_Add = 3'b010;
parameter Stretch = 3'b011, Send_Reg = 3'b100, Restart = 3'b101, Listen = 3'b110;

// Restart no es realmente un estado sino una flag para reutilizar los demás estados


// Si el clock es de 12MHz: 1 periodo es de 8.33e-8 y se necesitan
// 120 ciclos completos para hacer un periodo de una señal de 100 kHz

parameter Ns = 60; // N de ciclos de reloj equivalenes a 1 semiciclo
parameter Delay = 5; // Delay para evitar stop o start cuando no es
reg [2:0] state;
reg [$clog2(20*Ns):0] counter;
reg [2:0] st_prev; // NO es el estado previo sino una flag para poder reutilizar estados

initial begin
  state <= Default;
  st_prev <= Default;
  counter <= 0;
end

always @(posedge clk) begin
  case (state)
    Default: if (beg) state <= Start;
             else begin 
                state <= Default;
                scl <= 1;
                sda <= 1;
                counter <= 0;
             end
    Start : 
            if (st_prev == Default) begin
              if (counter == Ns) begin
                sda <= 0;
                scl <= 1;
                counter <= counter + 1;
              end else if (counter == 2*Ns)begin
                sda <= 0;
                scl <= 0;
                counter <= counter + 1;
              end else if (counter == 3*Ns)begin
                sda <= 1;
                scl <= 0;
                counter = 0;
                state <= Send_Add;
                st_prev <= Default;
              end else counter <= counter +1;
            end
            // Restart
            else if (st_prev == Send_Reg) begin
              if (counter == Ns) begin
                sda <= 1;
                scl <= 1;
                counter <= counter + 1;
              end else if (counter == 2*Ns)begin
                sda <= 0;
                scl <= 1;
                counter <= counter + 1;
              end else if (counter == 3*Ns)begin
                sda <= 0;
                scl <= 0;
                counter <= counter +1;
              end else if (counter == 3*Ns +Delay)begin
                sda <= 1;
                scl <= 0;
                counter = 0;
                state <= Send_Add;
                st_prev <= Restart;
              end else counter <= counter +1;
            end 
    Send_Add:
            if (st_prev == Default) begin
              // Impares
              if (counter%(Ns)==0 && counter%(2*Ns)!= 0)begin
                scl <= ~scl;
                counter <= counter + 1;
              end
              // Pares
              else if (counter%(2*Ns)== 0)begin
                scl <= 0;
                counter <= counter + 1;
              
              end else if (counter == 2*Ns +Delay)begin
                sda <= 1;
                counter <= counter + 1;
              end else if (counter == 4*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
              end else if (counter == 6*Ns +Delay)begin
                sda <= 1;
                counter <= counter + 1;
              end else if (counter == 8*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
              end else if (counter == 10*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
              end else if (counter == 12*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
                // Write
              end else if (counter == 14*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
                // Ack
              end else if (counter == 16*Ns +Delay)begin
                sda <= 1'bz;
                counter <= counter +1;
              end else if (counter == 18*Ns +Delay)begin
                sda <= 1'b1;
                counter <= 0;
                state <= Stretch;
                st_prev <= Send_Add;
              end else counter <= counter +1; 
            end else if (st_prev == Restart) begin
              // Impares
              if (counter%(Ns)==0 && counter%(2*Ns)!= 0)begin
                scl <= ~scl;
                counter <= counter + 1;
              end
              // Pares
              else if (counter%(2*Ns)== 0)begin
                scl <= 0;
                counter <= counter + 1;
              
              end else if (counter == 2*Ns +Delay)begin
                sda <= 1;
                counter <= counter + 1;
              end else if (counter == 4*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
              end else if (counter == 6*Ns +Delay)begin
                sda <= 1;
                counter <= counter + 1;
              end else if (counter == 8*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
              end else if (counter == 10*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
              end else if (counter == 12*Ns +Delay)begin
                sda <= 0;
                counter <= counter + 1;
                // Read
              end else if (counter == 14*Ns +Delay)begin              
                sda <= 1;
                counter <= counter + 1;
                // Ack
              end else if (counter == 16*Ns +Delay)begin
                sda <= 1'bz;
                counter <= counter +1;
              end else if (counter == 18*Ns +Delay)begin
                sda <= 1'b0;
                counter <= 0;
                state <= Stretch;
                st_prev <= Restart;
              end else counter <= counter +1; 
            end
    Stretch:
            if (st_prev == Send_Add)begin
              if (counter == Ns)begin
                sda <= 1'b0;
                scl <= 0;
                counter <= 0;
                state <= Send_Reg;
              end else counter <= counter +1;
            end else if (st_prev == Send_Reg)begin
              if (counter == Ns)begin
                sda <= 1'b1;
                scl <= 0;
                counter <= 0;
                state <= Start;
                st_prev <= Send_Reg;
              end else counter <= counter +1;  
            end else if (st_prev == Restart)begin
              if (counter == Ns)begin
                sda <= 1'b0;
                scl <= 0;
                counter <= 0;
                state <= Listen;
              end else counter <= counter +1;
            end
    Send_Reg:
            // Impares
             if (counter%(Ns)==0 && counter%(2*Ns)!= 0)begin
              scl <= ~scl;
              counter <= counter + 1;
             end
            // Pares
             else if (counter%(2*Ns)== 0)begin
              scl <= 0;
              counter <= counter + 1;
           // Ack
             end else if (counter == 16*Ns +Delay)begin
              sda <= 1'bz;
              counter <= counter +1;
             end else if (counter == 18*Ns +Delay)begin
              sda <= 1'b0;
              counter <= 0;
              state <= Stretch;
              st_prev <= Send_Reg;
            end else counter <= counter +1; 
          
  endcase
end

endmodule