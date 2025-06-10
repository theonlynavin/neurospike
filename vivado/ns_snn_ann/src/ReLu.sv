`timescale 1ns / 1ps

module ReLu #(parameter BITS, COUNTER_END, B_BITS)
(
  input clk,
  input activation_function, //1 for ReLu, 0 for none
  input reg [31:0] counter,
  input reg signed [BITS+24:0] mult_sum_in,
  input reg signed [B_BITS:0] b,
  output reg signed [BITS+24:0] neuron_out
);   
  integer i, f;
  integer j;
  
  
  initial begin
  
    i = 0;
    j = 0;
  end
  
  always @ (posedge clk) begin
  if (counter >= COUNTER_END) begin
    neuron_out = mult_sum_in + b;
    $display("counter:%d neuron_out:%d activation function:%d",counter, neuron_out,activation_function);    

    /*if (counter == 40)
    begin
        if (j == 0)
            begin    f = $fopen("neural_out.txt", "w");
end
        if (j < 10) begin
        j = j +1;
            $fwrite(f, "%d \n", neuron_out);
            end 
        if (j == 10)
            begin
            $fclose(f);  
        end
        
    end*/

    if (neuron_out > 0)
       ;
    else
      if (activation_function) begin
        neuron_out = 0;
      end
  end
  else begin
    neuron_out = 0;
  end
  end
  
  
  always @ (posedge clk) begin
    //$display("neuron_out:%h",neuron_out);
  end
  
  
endmodule
