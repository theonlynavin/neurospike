
module Q8_24_adder (
	input signed [31:0] a,
	input signed [31:0] b,
	output signed [31:0] sum
);

	brentkung_32bit bk(a, b, 1'b0, sum, );

endmodule

module Q8_24_multiplier (
	input signed [31:0] a,
	input signed [31:0] b,
	output reg signed [31:0] product
);

	reg [31:0] am, bm;
	wire [63:0] productm;
	wallace_32bit w(am, bm, productm);

	always @(*) begin 

		if (a[31] == 0 && b[31] == 0) begin
			am = a; bm = b;
			product = productm[55:24];
		end
		else if (a[31] == 0 && b[31] == 1) begin
			am = a; bm = ~b;
			product = ~productm[55:24];
		end
		else if (a[31] == 1 && b[31] == 0) begin
			am = ~a; bm = b;
			product = ~productm[55:24];
		end
		else if (a[31] == 1 && b[31] == 1) begin
			am = ~a; bm = ~b;
			product = productm[55:24];
		end

	end


endmodule

module Q8_24_negate(
	input signed [31:0] num, 
	output signed [31:0] negnum
);

	brentkung_32bit twos_complement(~num, 32'h00000001, 1'b0, negnum, );

endmodule