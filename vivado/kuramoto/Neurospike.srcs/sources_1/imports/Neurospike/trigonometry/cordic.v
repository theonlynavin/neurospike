
module cordic (
    input wire signed [31:0] theta,     // Q8.24 angle between 0 and pi/2
    output wire signed [31:0] cos_out, 	// cosine output
    output wire signed [31:0] sin_out  	// sine output
);
    // Constants
    localparam iter = 24;
    localparam signed [31:0] K = 32'h009b74ee; 	// Scaling factor K = 0.6072529350088812561694
    
    // arctan lookup table
    reg signed [31:0] atan_table [0:iter-1];

    // Registers for x, y, z during iterations
    reg signed [31:0] x [0:iter-1], y [0:iter-1], z [0:iter-1];

    initial begin
        atan_table[0] =     32'h00c90fdb    ;
        atan_table[1] =     32'h0076b19c    ;
        atan_table[2] =     32'h003eb6ec    ;
        atan_table[3] =     32'h001fd5bb    ;
        atan_table[4] =     32'h000ffaae    ;
        atan_table[5] =     32'h0007ff55    ;
        atan_table[6] =     32'h0003ffeb    ;
        atan_table[7] =     32'h0001fffd    ;
        atan_table[8] =     32'h00010000    ;
        atan_table[9] =     32'h00008000    ;
        atan_table[10] =    32'h00004000    ;
        atan_table[11] =    32'h00002000    ;
        atan_table[12] =    32'h00001000    ;
        atan_table[13] =    32'h00000800    ;
        atan_table[14] =    32'h00000400    ;
        atan_table[15] =    32'h00000200    ;
        atan_table[16] =    32'h00000100    ;
        atan_table[17] =    32'h00000080    ;
        atan_table[18] =    32'h00000040    ;
        atan_table[19] =    32'h00000020    ;
        atan_table[20] =    32'h00000010    ;
        atan_table[21] =    32'h00000008    ;
        atan_table[22] =    32'h00000004    ;
        atan_table[23] =    32'h00000002    ;

        x[0] = K;         // Initialize x with scaling factor
        y[0] = 32'h0;     // Initialize y to 0

    end

    assign cos_out = x[iter-1];
    assign sin_out = y[iter-1];

    always @(*) begin
        z[0] = theta;
    end

    genvar i;

    generate            
        for (i = 0; i < iter-1; i = i + 1) begin
            always @(*) begin
                if (z[i] >= 0) begin
                    x[i+1] <= x[i] - (y[i] >>> i);
                    y[i+1] <= y[i] + (x[i] >>> i);
                    z[i+1] <= z[i] - atan_table[i];
                end else begin
                    x[i+1] <= x[i] + (y[i] >>> i);
                    y[i+1] <= y[i] - (x[i] >>> i);
                    z[i+1] <= z[i] + atan_table[i];
                end
            end

        end
    endgenerate

endmodule
