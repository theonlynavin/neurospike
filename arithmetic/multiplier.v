module wallace_8bit (
    input [7:0] a,
    input [7:0] b,
    output [15:0] product
);
    reg[7:0] pp[7:0];   // partial product
    
    integer i, j;
    always @(a, b) begin
        for(i = 0;i < 8; i = i+1) begin
            for(j = 0;j < 8; j = j+1) begin
                pp[i][j] = a[i] & b[j];
            end            
        end
    end

    // product[0]
    assign product[0] = pp[0][0];

    // product[1]
    wire p1_c;
    half_adder p1_HA_1(pp[0][1], pp[1][0], product[1], p1_c);

    // product[2]
    wire p2_c_t_1, p2_c, p2_t_1;
    full_adder p2_FA_1(pp[0][2], pp[1][1], p1_c, p2_t_1, p2_c_t_1);
    half_adder p2_HA_1(pp[2][0], p2_t_1, product[2], p2_c);

    // product[3]
    wire p3_c_t_1, p3_c_t_2, p3_c, p3_t_1, p3_t_2;
    full_adder p3_FA_1(pp[0][3], pp[1][2], p2_c, p3_t_1, p3_c_t_1);
    full_adder p3_FA_2(pp[2][1], p3_t_1, p2_c_t_1, p3_t_2, p3_c_t_2);
    half_adder p3_HA_1(pp[3][0], p3_t_2, product[3], p3_c);

    // product[4]
    wire p4_c_t_1, p4_c_t_2, p4_c_t_3, p4_c, p4_t_1, p4_t_2, p4_t_3;
    full_adder p4_FA_1(pp[0][4], pp[1][3], p3_c, p4_t_1, p4_c_t_1);
    full_adder p4_FA_2(pp[2][2], p4_t_1, p3_c_t_1, p4_t_2, p4_c_t_2);
    full_adder p4_FA_3(pp[3][1], p4_t_2, p3_c_t_2, p4_t_3, p4_c_t_3);
    half_adder p4_HA_1(pp[4][0], p4_t_3, product[4], p4_c);

    // product[5]
    wire p5_c_t_1, p5_c_t_2, p5_c_t_3, p5_c_t_4, p5_c, p5_t_1, p5_t_2, p5_t_3, p5_t_4;
    full_adder p5_FA_1(pp[0][5], pp[1][4], p4_c, p5_t_1, p5_c_t_1);
    full_adder p5_FA_2(pp[2][3], p5_t_1, p4_c_t_1, p5_t_2, p5_c_t_2);
    full_adder p5_FA_3(pp[3][2], p5_t_2, p4_c_t_2, p5_t_3, p5_c_t_3);
    full_adder p5_FA_4(pp[4][1], p5_t_3, p4_c_t_3, p5_t_4, p5_c_t_4);
    half_adder p5_HA_1(pp[5][0], p5_t_4, product[5], p5_c);

    // product[6]
    wire p6_c_t_1, p6_c_t_2, p6_c_t_3, p6_c_t_4, p6_c_t_5, p6_c, p6_t_1, p6_t_2, p6_t_3, p6_t_4, p6_t_5;
    full_adder p6_FA_1(pp[0][6], pp[1][5], p5_c, p6_t_1, p6_c_t_1);
    full_adder p6_FA_2(pp[2][4], p6_t_1, p5_c_t_1, p6_t_2, p6_c_t_2);
    full_adder p6_FA_3(pp[3][3], p6_t_2, p5_c_t_2, p6_t_3, p6_c_t_3);
    full_adder p6_FA_4(pp[4][2], p6_t_3, p5_c_t_3, p6_t_4, p6_c_t_4);
    full_adder p6_FA_5(pp[5][1], p6_t_4, p5_c_t_4, p6_t_5, p6_c_t_5);
    half_adder p6_HA_1(pp[6][0], p6_t_5, product[6], p6_c);

    // product[7]
    wire p7_c_t_1, p7_c_t_2, p7_c_t_3, p7_c_t_4, p7_c_t_5, p7_c_t_6, p7_c, p7_t_1, p7_t_2, p7_t_3, p7_t_4, p7_t_5, p7_t_6;
    full_adder p7_FA_1(pp[0][7], pp[1][6], p6_c, p7_t_1, p7_c_t_1);
    full_adder p7_FA_2(pp[2][5], p7_t_1, p6_c_t_1, p7_t_2, p7_c_t_2);
    full_adder p7_FA_3(pp[3][4], p7_t_2, p6_c_t_2, p7_t_3, p7_c_t_3);
    full_adder p7_FA_4(pp[4][3], p7_t_3, p6_c_t_3, p7_t_4, p7_c_t_4);
    full_adder p7_FA_5(pp[5][2], p7_t_4, p6_c_t_4, p7_t_5, p7_c_t_5);
    full_adder p7_FA_6(pp[6][1], p7_t_5, p6_c_t_5, p7_t_6, p7_c_t_6);
    half_adder p7_HA_1(pp[7][0], p7_t_6, product[7], p7_c);

    // product[8]
    wire p8_c_t_1, p8_c_t_2, p8_c_t_3, p8_c_t_4, p8_c_t_5, p8_c_t_6, p8_c, p8_t_1, p8_t_2, p8_t_3, p8_t_4, p8_t_5, p8_t_6;
    full_adder p8_FA_1(pp[1][7], pp[2][6], p7_c, p8_t_1, p8_c_t_1);
    full_adder p8_FA_2(pp[3][5], p8_t_1, p7_c_t_1, p8_t_2, p8_c_t_2);
    full_adder p8_FA_3(pp[4][4], p8_t_2, p7_c_t_2, p8_t_3, p8_c_t_3);
    full_adder p8_FA_4(pp[5][3], p8_t_3, p7_c_t_3, p8_t_4, p8_c_t_4);
    full_adder p8_FA_5(pp[6][2], p8_t_4, p7_c_t_4, p8_t_5, p8_c_t_5);
    full_adder p8_FA_6(pp[7][1], p8_t_5, p7_c_t_5, p8_t_6, p8_c_t_6);
    half_adder p8_HA_1(p8_t_6, p7_c_t_6, product[8], p8_c);

    // product[9]
    wire p9_c_t_1, p9_c_t_2, p9_c_t_3, p9_c_t_4, p9_c, p9_t_1, p9_t_2, p9_t_3, p9_t_4;
    full_adder p9_FA_1(pp[2][7], pp[3][6], p8_c, p9_t_1, p9_c_t_1);
    full_adder p9_FA_2(pp[4][5], p9_t_1, p8_c_t_1, p9_t_2, p9_c_t_2);
    full_adder p9_FA_3(pp[5][4], p9_t_2, p8_c_t_2, p9_t_3, p9_c_t_3);
    full_adder p9_FA_4(pp[6][3], p9_t_3, p8_c_t_3, p9_t_4, p9_c_t_4);
    full_adder p9_FA_5(pp[7][2], p9_t_4, p8_c_t_4, p9_t_5, p9_c_t_5);
    full_adder p9_FA_6(p9_t_5, p8_c_t_5, p8_c_t_6, product[9], p9_c);

    // product[10]
    wire p10_c_t_1, p10_c_t_2, p10_c_t_3, p10_c, p10_t_1, p10_t_2, p10_t_3;
    full_adder p10_FA_1(pp[3][7], pp[4][6], p9_c, p10_t_1, p10_c_t_1);
    full_adder p10_FA_2(pp[5][5], p10_t_1, p9_c_t_1, p10_t_2, p10_c_t_2);
    full_adder p10_FA_3(pp[6][4], p10_t_2, p9_c_t_2, p10_t_3, p10_c_t_3);
    full_adder p10_FA_4(pp[7][3], p10_t_3, p9_c_t_3, p10_t_4, p10_c_t_4);
    full_adder p10_FA_5(p10_t_4, p9_c_t_4, p9_c_t_5, product[10], p10_c);

    // product[11]
    wire p11_c_t_1, p11_c_t_2, p11_c, p11_t_1, p11_t_2;
    full_adder p11_FA_1(pp[4][7], pp[5][6], p10_c, p11_t_1, p11_c_t_1);
    full_adder p11_FA_2(pp[6][5], p11_t_1, p10_c_t_1, p11_t_2, p11_c_t_2);
    full_adder p11_FA_3(pp[7][4], p11_t_2, p10_c_t_2, p11_t_3, p11_c_t_3);
    full_adder p11_FA_4(p11_t_3, p10_c_t_3, p10_c_t_4, product[11], p11_c);

    // product[12]
    wire p12_c_t_1, p12_c, p12_t_1;
    full_adder p12_FA_1(pp[5][7], pp[6][6], p11_c, p12_t_1, p12_c_t_1);
    full_adder p12_FA_2(pp[7][5], p12_t_1, p11_c_t_1, p12_t_2, p12_c_t_2);
    full_adder p12_FA_3(p12_t_2, p11_c_t_2, p11_c_t_3, product[12], p12_c);

    // product[13]
    wire p13_c;
    full_adder p13_FA_1(pp[6][7], pp[7][6], p12_c, p13_t_1, p13_c_t_1);
    full_adder p13_FA_2(p13_t_1, p12_c_t_2, p12_c_t_1, product[13], p13_c);

    // product[14]
    full_adder p14_FA_1(pp[7][7], p13_c, p13_c_t_1, product[14], p14_c);

    // product[15]
    assign product[15] = p14_c;

endmodule 

// 32-bit Wallace tree multiplier module
module wallace_32bit (
    input [31:0] a,       // 32-bit input 'a'
    input [31:0] b,       // 32-bit input 'b'
    output [63:0] product // 64-bit product output
);

    // 8-bit slices of inputs 'a' and 'b'
    wire [7:0] a_slice1, a_slice2, a_slice3, a_slice4;
    wire [7:0] b_slice1, b_slice2, b_slice3, b_slice4;

    // 16 intermediate 16-bit products from 8x8 multipliers
    wire [15:0] bpp1, bpp2, bpp3, bpp4;
    wire [15:0] bpp5, bpp6, bpp7, bpp8;
    wire [15:0] bpp9, bpp10, bpp11, bpp12;
    wire [15:0] bpp13, bpp14, bpp15, bpp16;

    // Slicing the 32-bit inputs 'a' and 'b' into 8-bit segments
    assign a_slice1 = a[7:0];
    assign a_slice2 = a[15:8];
    assign a_slice3 = a[23:16];
    assign a_slice4 = a[31:24];

    assign b_slice1 = b[7:0];
    assign b_slice2 = b[15:8];
    assign b_slice3 = b[23:16];
    assign b_slice4 = b[31:24];

    wallace_8bit mult1(a_slice1, b_slice1, bpp1);
    wallace_8bit mult2(a_slice1, b_slice2, bpp2);
    wallace_8bit mult3(a_slice1, b_slice3, bpp3);
    wallace_8bit mult4(a_slice1, b_slice4, bpp4);

    wallace_8bit mult5(a_slice2, b_slice1, bpp5);
    wallace_8bit mult6(a_slice2, b_slice2, bpp6);
    wallace_8bit mult7(a_slice2, b_slice3, bpp7);
    wallace_8bit mult8(a_slice2, b_slice4, bpp8);

    wallace_8bit mult9(a_slice3, b_slice1, bpp9);
    wallace_8bit mult10(a_slice3, b_slice2, bpp10);
    wallace_8bit mult11(a_slice3, b_slice3, bpp11);
    wallace_8bit mult12(a_slice3, b_slice4, bpp12);

    wallace_8bit mult13(a_slice4, b_slice1, bpp13);
    wallace_8bit mult14(a_slice4, b_slice2, bpp14);
    wallace_8bit mult15(a_slice4, b_slice3, bpp15);
    wallace_8bit mult16(a_slice4, b_slice4, bpp16);

    wire [63:0] shifted_pp1, shifted_pp2, shifted_pp3, shifted_pp4;
    wire [63:0] shifted_pp5, shifted_pp6, shifted_pp7, shifted_pp8;
    wire [63:0] shifted_pp9, shifted_pp10, shifted_pp11, shifted_pp12;
    wire [63:0] shifted_pp13, shifted_pp14, shifted_pp15, shifted_pp16;

    assign shifted_pp1 = {48'b0, bpp1};         // No shift for pp1
    assign shifted_pp2 = {40'b0, bpp2, 8'b0};   // Shift pp2 by 8 bits
    assign shifted_pp3 = {32'b0, bpp3, 16'b0};  // Shift pp3 by 16 bits
    assign shifted_pp4 = {24'b0, bpp4, 24'b0};  // Shift pp4 by 24 bits

    assign shifted_pp5 = {40'b0, bpp5, 8'b0};   // Shift pp5 by 8 bits
    assign shifted_pp6 = {32'b0, bpp6, 16'b0};  // Shift pp6 by 16 bits
    assign shifted_pp7 = {24'b0, bpp7, 24'b0};  // Shift pp7 by 24 bits
    assign shifted_pp8 = {16'b0, bpp8, 32'b0};  // Shift pp8 by 32 bits

    assign shifted_pp9 = {32'b0, bpp9, 16'b0};  // Shift pp9 by 16 bits
    assign shifted_pp10 = {24'b0, bpp10, 24'b0}; // Shift pp10 by 24 bits
    assign shifted_pp11 = {16'b0, bpp11, 32'b0}; // Shift pp11 by 32 bits
    assign shifted_pp12 = {8'b0, bpp12, 40'b0};  // Shift pp12 by 40 bits

    assign shifted_pp13 = {24'b0, bpp13, 24'b0}; // Shift pp13 by 24 bits
    assign shifted_pp14 = {16'b0, bpp14, 32'b0}; // Shift pp14 by 32 bits
    assign shifted_pp15 = {8'b0, bpp15, 40'b0};  // Shift pp15 by 40 bits
    assign shifted_pp16 = {48'b0, bpp16};        // Shift pp16 by 48 bits

    wire [63:0] ba1, ba2, ba3, ba4, ba5, ba6, ba7, ba8, ba9, ba10, ba11, ba12, ba13, ba14;

    brentkung_64bit add1(shifted_pp1, shifted_pp2, 1'b0, ba1, );
    brentkung_64bit add2(shifted_pp3, shifted_pp4, 1'b0, ba2, );
    brentkung_64bit add3(shifted_pp5, shifted_pp6, 1'b0, ba3, );
    brentkung_64bit add4(shifted_pp7, shifted_pp8, 1'b0, ba4, );
    brentkung_64bit add5(shifted_pp9, shifted_pp10, 1'b0, ba5, );
    brentkung_64bit add6(shifted_pp11, shifted_pp12, 1'b0, ba6, );
    brentkung_64bit add7(shifted_pp13, shifted_pp14, 1'b0, ba7, );
    brentkung_64bit add8(shifted_pp15, shifted_pp16, 1'b0, ba8, );

    brentkung_64bit add9(ba1, ba2, 1'b0, ba9, );
    brentkung_64bit add10(ba3, ba4, 1'b0, ba10, );
    brentkung_64bit add11(ba5, ba6, 1'b0, ba11, );
    brentkung_64bit add12(ba7, ba8, 1'b0, ba12, );

    brentkung_64bit add13(ba9, ba10, 1'b0, ba13, );
    brentkung_64bit add14(ba11, ba12, 1'b0, ba14, );

    brentkung_64bit final(ba13, ba14, 1'b0, product, );
endmodule

// Full adder module
module full_adder(
    input a, b, cin,
    output sum, carry
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (cin & (a ^ b));
endmodule

// Half adder module
module half_adder(
    input a, b,
    output sum, carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule
