// Brent-Kung based 32-bit adder
module brentkung_32bit (
    input [31:0] a, b,   // 32-bit inputs a and b
    input cin,           // Carry input
    output [31:0] sum,   // 32-bit sum output
    output cout          // Carry out
);

    wire [31:0] carry;                        // Intermediate carry signals
    wire [31:0] generate_g, propagate_p;      // Generate and propagate signals
    wire [15:0] generate_g2, propagate_p2;    // 2-bit group generate and propagate
    wire [7:0] generate_g3, propagate_p3;     // 4-bit group generate and propagate
    wire [3:0] generate_g4, propagate_p4;     // 8-bit group generate and propagate
    wire [1:0] generate_g5, propagate_p5;     // 16-bit group generate and propagate
    wire generate_g6, propagate_p6;           // Final group generate and propagate

    assign generate_g = a & b;                // Generate signal (Gi = Ai & Bi)
    assign propagate_p = a ^ b;               // Propagate signal (Pi = Ai ^ Bi)

    genvar i, j, k, l, m, n, s; 
    generate
        // First stage: 2-bit blocks
        for (j = 0; j < 16; j = j + 1) begin: stage_2bit
            g2bits gen2bit (.g2(generate_g[2*j+1:2*j]), .p2(propagate_p[2*j+1]), .g2o(generate_g2[j]));
            p2bits prop2bit (.p2(propagate_p[2*j+1:2*j]), .p2o(propagate_p2[j]));
        end

        // Second stage: 4-bit blocks
        for (k = 0; k < 8; k = k + 1) begin: stage_4bit
            g2bits gen4bit (.g2(generate_g2[2*k+1:2*k]), .p2(propagate_p2[2*k+1]), .g2o(generate_g3[k]));
            p2bits prop4bit (.p2(propagate_p2[2*k+1:2*k]), .p2o(propagate_p3[k]));
        end

        // Third stage: 8-bit blocks
        for (l = 0; l < 4; l = l + 1) begin: stage_8bit
            g2bits gen8bit (.g2(generate_g3[2*l+1:2*l]), .p2(propagate_p3[2*l+1]), .g2o(generate_g4[l]));
            p2bits prop8bit (.p2(propagate_p3[2*l+1:2*l]), .p2o(propagate_p4[l]));
        end

        // Fourth stage: 16-bit blocks
        for (m = 0; m < 2; m = m + 1) begin: stage_16bit
            g2bits gen16bit (.g2(generate_g4[2*m+1:2*m]), .p2(propagate_p4[2*m+1]), .g2o(generate_g5[m]));
            p2bits prop16bit (.p2(propagate_p4[2*m+1:2*m]), .p2o(propagate_p5[m]));
        end
    endgenerate

    // Final stage: 32-bit block
    g2bits gen32bit (.g2(generate_g5[1:0]), .p2(propagate_p5[1]), .g2o(generate_g6));
    p2bits prop32bit (.p2(propagate_p5[1:0]), .p2o(propagate_p6));

    // Carry bit computation
    assign carry[0] = cin;                                    // Initial carry is cin
    assign cout = generate_g6 | (propagate_p6 & cin);         // Final carry out

    // Compute carry bits for different stages
    assign carry[16] = generate_g5[0] | (propagate_p5[0] & cin);
    assign carry[8] = generate_g4[0] | (propagate_p4[0] & cin);
    assign carry[4] = generate_g3[0] | (propagate_p3[0] & cin);
    assign carry[2] = generate_g2[0] | (propagate_p2[0] & cin);
    assign carry[1] = generate_g[0] | (propagate_p[0] & cin);

    assign carry[12] = generate_g3[2] | (propagate_p3[2] & carry[8]);
    assign carry[20] = generate_g3[4] | (propagate_p3[4] & carry[16]);
    assign carry[3] = generate_g[2] | (propagate_p[2] & carry[2]);
    assign carry[24] = generate_g4[2] | (propagate_p4[2] & carry[16]);
    assign carry[28] = generate_g3[6] | (propagate_p3[6] & carry[24]);

    assign carry[6] = generate_g2[2] | (propagate_p2[2] & carry[4]);
    assign carry[10] = generate_g2[4] | (propagate_p2[4] & carry[8]);
    assign carry[14] = generate_g2[6] | (propagate_p2[6] & carry[12]);
    assign carry[18] = generate_g2[8] | (propagate_p2[8] & carry[16]);
    assign carry[22] = generate_g2[10] | (propagate_p2[10] & carry[20]);
    assign carry[26] = generate_g2[12] | (propagate_p2[12] & carry[24]);
    assign carry[30] = generate_g2[14] | (propagate_p2[14] & carry[28]);

    assign carry[5] = generate_g[4] | (propagate_p[4] & carry[4]);
    assign carry[7] = generate_g[6] | (propagate_p[6] & carry[6]);
    assign carry[9] = generate_g[8] | (propagate_p[8] & carry[8]);
    assign carry[11] = generate_g[10] | (propagate_p[10] & carry[10]);
    assign carry[13] = generate_g[12] | (propagate_p[12] & carry[12]);
    assign carry[15] = generate_g[14] | (propagate_p[14] & carry[14]);
    assign carry[17] = generate_g[16] | (propagate_p[16] & carry[16]);
    assign carry[19] = generate_g[18] | (propagate_p[18] & carry[18]);
    assign carry[21] = generate_g[20] | (propagate_p[20] & carry[20]);
    assign carry[23] = generate_g[22] | (propagate_p[22] & carry[22]);
    assign carry[25] = generate_g[24] | (propagate_p[24] & carry[24]);
    assign carry[27] = generate_g[26] | (propagate_p[26] & carry[26]);
    assign carry[29] = generate_g[28] | (propagate_p[28] & carry[28]);
    assign carry[31] = generate_g[30] | (propagate_p[30] & carry[30]);

    assign sum = a ^ b ^ carry;   

endmodule

// Brent-Kung based 64-bit adder
module brentkung_64bit (
    input [63:0] a, b,   // 64-bit inputs a and b
    input cin,           // Carry input
    output [63:0] sum,   // 64-bit sum output
    output cout          // Carry out
);

    wire cint;
    brentkung_32bit a1(a[31:0], b[31:0], cin, sum[31:0], cint);
    brentkung_32bit a2(a[63:32], b[63:32], cint, sum[63:32], cout);

endmodule

// Module for 2-bit group generate logic
module g2bits(
    input [1:0] g2,     // 2-bit generate signals
    input p2,           // 1-bit propagate signal
    output g2o          // Output generate signal
);
    assign g2o = g2[1] | (g2[0] & p2);
endmodule

// Module for 2-bit group propagate logic
module p2bits(
    input [1:0] p2,     // 2-bit propagate signals
    output p2o          // Output propagate signal
);
    assign p2o = p2[1] & p2[0];
endmodule
