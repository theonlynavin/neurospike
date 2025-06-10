module softmax #(
    parameter LAYER2_BITS = 61,
    parameter FIXED_POINT_SHIFT = 61
)(
    input wire signed [LAYER2_BITS+24:0] neuralnet_out [0:9],
    output wire signed [LAYER2_BITS+24:0] softmax_out [0:9] 
);

    integer i;
    reg signed [LAYER2_BITS+24:0] max_val;
    reg signed [LAYER2_BITS+24:0] exp_values [0:9];
    reg signed [LAYER2_BITS+24:0] sum_exp;
    reg signed [LAYER2_BITS+24:0] diff [0:9];
    reg signed [LAYER2_BITS+24:0] softmax_values [0:9];
    
    always @(*) begin
        max_val = neuralnet_out[0];
        for (i = 1; i < 10; i = i + 1) begin
            if (neuralnet_out[i] > max_val)
                max_val = neuralnet_out[i];
        end
        
        sum_exp = 0;
        for (i = 0; i < 10; i = i + 1) begin
            diff[i] = neuralnet_out[i] - max_val;
            exp_values[i] = (1 << FIXED_POINT_SHIFT) + diff[i]; // Approximation e^x ≈ 1 + x
            sum_exp = sum_exp + exp_values[i];
        end
        
        for (i = 0; i < 10; i = i + 1) begin
            softmax_values[i] = (exp_values[i] * (1 << FIXED_POINT_SHIFT)) / sum_exp;
        end
    end
    
    assign softmax_out = softmax_values;

endmodule

module argmax #(
    parameter LAYER2_BITS = 8
) (
    input wire signed [LAYER2_BITS+24:0] softmax_out [0:9],
    output reg [3:0] max_index
);
    integer i;
    reg signed [LAYER2_BITS+24:0] max_value;
    
    always @(*) begin
        max_value = softmax_out[0];
        max_index = 0;
        for (i = 1; i < 10; i = i + 1) begin
            if (softmax_out[i] > max_value) begin
                max_value = softmax_out[i];
                max_index = i;
            end
        end
    end

endmodule