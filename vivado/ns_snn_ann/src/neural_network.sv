`timescale 1ns / 1ps


module neural_network #(parameter LAYER1_NEURON_WIDTH = 32'd823,
                                  LAYER1_COUNTER_END = 32'h00000334,
                                  LAYER1_BITS = 31,
                                  LAYER2_NEURON_WIDTH = 32'd49,
                                  LAYER2_COUNTER_END = 32'h00000028,
                                  LAYER2_BITS = LAYER1_BITS + 8
                                  )
(
    //clock and reset for counter
    input clk,
    input rstn,
    
    //b-values
    input reg signed [31:0] b1 [0:9],
     input reg signed [63:0] b2 [0:9],
    
    //784 pixel input bitmap
    input reg signed [31:0] data_in [0:LAYER1_NEURON_WIDTH],
    
    //weight values for lines connecting to first layer of neurons
    input reg signed [31:0] w1_1 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_2 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_3 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_4 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_5 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_6 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_7 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_8 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_9 [0:LAYER1_NEURON_WIDTH],
    input reg signed [31:0] w1_10 [0:LAYER1_NEURON_WIDTH],
    
    //weight values for lines connecting to second layer of neurons
    input reg signed [31:0] w2_1 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_2 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_3 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_4 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_5 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_6 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_7 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_8 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_9 [0:LAYER2_NEURON_WIDTH],
    input reg signed [31:0] w2_10 [0:LAYER2_NEURON_WIDTH],
    
    //neural network output
    output signed [LAYER2_BITS + 24:0] neuralnet_out [0:9]

    );
    
    wire signed [LAYER1_BITS + 24:0] bus_layer1_out [0:LAYER2_NEURON_WIDTH];
    wire signed [LAYER1_BITS + 8:0] bus_layer1_out_2 [0:LAYER2_NEURON_WIDTH];

    wire bus_counter_layer1_donestatus;
    
    assign bus_layer1_out[0] = 40'h00000000;
    assign bus_layer1_out[1] = 40'h00000000;
    assign bus_layer1_out[2] = 40'h00000000;
    assign bus_layer1_out[3] = 40'h00000000;
    assign bus_layer1_out[4] = 40'h00000000;
    assign bus_layer1_out[5] = 40'h00000000;
    assign bus_layer1_out[6] = 40'h00000000;
    assign bus_layer1_out[7] = 40'h00000000;
    assign bus_layer1_out[8] = 40'h00000000;
    assign bus_layer1_out[9] = 40'h00000000;
    assign bus_layer1_out[10] = 40'h00000000;
    assign bus_layer1_out[11] = 40'h00000000;
    assign bus_layer1_out[12] = 40'h00000000;
    assign bus_layer1_out[13] = 40'h00000000;
    assign bus_layer1_out[14] = 40'h00000000;
    assign bus_layer1_out[15] = 40'h00000000;
    assign bus_layer1_out[16] = 40'h00000000;
    assign bus_layer1_out[17] = 40'h00000000;
    assign bus_layer1_out[18]= 40'h00000000;
    assign bus_layer1_out[19] = 40'h00000000;
    assign bus_layer1_out[30] = 40'h00000000;
    assign bus_layer1_out[31] = 40'h00000000;
    assign bus_layer1_out[32] = 40'h00000000;
    assign bus_layer1_out[33] = 40'h00000000;
    assign bus_layer1_out[34] = 40'h00000000;
    assign bus_layer1_out[35] = 40'h00000000;
    assign bus_layer1_out[36] = 40'h00000000;
    assign bus_layer1_out[37] = 40'h00000000;
    assign bus_layer1_out[38] = 40'h00000000;
    assign bus_layer1_out[39] = 40'h00000000;
    assign bus_layer1_out[40] = 40'h00000000;
    assign bus_layer1_out[41] = 40'h00000000;
    assign bus_layer1_out[42] = 40'h00000000;
    assign bus_layer1_out[43] = 40'h00000000;
    assign bus_layer1_out[44] = 40'h00000000;
    assign bus_layer1_out[45] = 40'h00000000;
    assign bus_layer1_out[46] = 40'h00000000;
    assign bus_layer1_out[47] = 40'h00000000;
    assign bus_layer1_out[48] = 40'h00000000;
    assign bus_layer1_out[49] = 40'h00000000;
    
    assign bus_layer1_out_2[0] = bus_layer1_out[0];
    assign bus_layer1_out_2[1] = bus_layer1_out[1];
    assign bus_layer1_out_2[2] = bus_layer1_out[2];
    assign bus_layer1_out_2[3] = bus_layer1_out[3];
    assign bus_layer1_out_2[4] = bus_layer1_out[4];
    assign bus_layer1_out_2[5] = bus_layer1_out[5];
    assign bus_layer1_out_2[6] = bus_layer1_out[6];
    assign bus_layer1_out_2[7] = bus_layer1_out[7];
    assign bus_layer1_out_2[8] = bus_layer1_out[8];
    assign bus_layer1_out_2[9] = bus_layer1_out[9];
    
    assign bus_layer1_out_2[10] = bus_layer1_out[10];
    assign bus_layer1_out_2[11] = bus_layer1_out[11];
    assign bus_layer1_out_2[12] = bus_layer1_out[12];
    assign bus_layer1_out_2[13] = bus_layer1_out[13];
    assign bus_layer1_out_2[14] = bus_layer1_out[14];
    assign bus_layer1_out_2[15] = bus_layer1_out[15];
    assign bus_layer1_out_2[16] = bus_layer1_out[16];
    assign bus_layer1_out_2[17] = bus_layer1_out[17];
    assign bus_layer1_out_2[18] = bus_layer1_out[18];
    assign bus_layer1_out_2[19] = bus_layer1_out[19];
    
    assign bus_layer1_out_2[20] = bus_layer1_out[20];
    assign bus_layer1_out_2[21] = bus_layer1_out[21];
    assign bus_layer1_out_2[22] = bus_layer1_out[22];
    assign bus_layer1_out_2[23] = bus_layer1_out[23];
    assign bus_layer1_out_2[24] = bus_layer1_out[24];
    assign bus_layer1_out_2[25] = bus_layer1_out[25];
    assign bus_layer1_out_2[26] = bus_layer1_out[26];
    assign bus_layer1_out_2[27] = bus_layer1_out[27];
    assign bus_layer1_out_2[28] = bus_layer1_out[28];
    assign bus_layer1_out_2[29] = bus_layer1_out[29];
    
    assign bus_layer1_out_2[30] = bus_layer1_out[30];
    assign bus_layer1_out_2[31] = bus_layer1_out[31];
    assign bus_layer1_out_2[32] = bus_layer1_out[32];
    assign bus_layer1_out_2[33] = bus_layer1_out[33];
    assign bus_layer1_out_2[34] = bus_layer1_out[34];
    assign bus_layer1_out_2[35] = bus_layer1_out[35];
    assign bus_layer1_out_2[36] = bus_layer1_out[36];
    assign bus_layer1_out_2[37] = bus_layer1_out[37];
    assign bus_layer1_out_2[38] = bus_layer1_out[38];
    assign bus_layer1_out_2[39] = bus_layer1_out[39];
    
    assign bus_layer1_out_2[40] = bus_layer1_out[40];
    assign bus_layer1_out_2[41] = bus_layer1_out[41];
    assign bus_layer1_out_2[42] = bus_layer1_out[42];
    assign bus_layer1_out_2[43] = bus_layer1_out[43];
    assign bus_layer1_out_2[44] = bus_layer1_out[44];
    assign bus_layer1_out_2[45] = bus_layer1_out[45];
    assign bus_layer1_out_2[46] = bus_layer1_out[46];
    assign bus_layer1_out_2[47] = bus_layer1_out[47];
    assign bus_layer1_out_2[48] = bus_layer1_out[48];
    assign bus_layer1_out_2[49] = bus_layer1_out[49];
    
    /*
    always @(clk) begin
        $display("%h", bus_layer1_out[29]);
        end
    */
    
    layer #( .LAYER_NEURON_WIDTH(LAYER1_NEURON_WIDTH), 
             .LAYER_COUNTER_END(LAYER1_COUNTER_END),
             .LAYER_BITS(LAYER1_BITS),
             .B_BITS(31)) layer1(
        .b (b1),
        .w1 (w1_1),
        .w2 (w1_2),
        .w3 (w1_3),
        .w4 (w1_4),
        .w5 (w1_5),
        .w6 (w1_6),
        .w7 (w1_7),
        .w8 (w1_8),
        .w9 (w1_9),
        .w10 (w1_10),
        .data_in (data_in),
        .data_out (bus_layer1_out[20:29]), //bus_layer1_out[20:29]
        .clk (clk),
        .rstn (rstn),
        .counter_donestatus (bus_counter_layer1_donestatus),
        .activation_function(1'b1)
    );
    
    layer #( .LAYER_NEURON_WIDTH(LAYER2_NEURON_WIDTH), 
             .LAYER_COUNTER_END(LAYER2_COUNTER_END),
             .LAYER_BITS(LAYER2_BITS),
             .B_BITS(63)
             )//change counter width
        layer2(
        .b (b2),
        .w1 (w2_1),
        .w2 (w2_2),
        .w3 (w2_3),
        .w4 (w2_4),
        .w5 (w2_5),
        .w6 (w2_6),
        .w7 (w2_7),
        .w8 (w2_8),
        .w9 (w2_9),
        .w10 (w2_10),
        .data_in (bus_layer1_out_2),
        .data_out (neuralnet_out),
        .clk (clk),
        .rstn (bus_counter_layer1_donestatus), //done status of counter 1 triggers counter 2 to start
        .counter_donestatus (),
        .activation_function(1'b0)
    );
    
    
     
endmodule
