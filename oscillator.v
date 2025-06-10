module oscillator_step(
	input wire signed[31:0] theta_n, y_n, z_n,
	output wire signed[31:0] theta_n1, y_n1, z_n1,
	input wire signed[31:0] n
);
	
	localparam[31:0] A = 32'h00000000;	// amplitude of external force
	localparam[31:0] w = 32'h00000000;	// frequency of external force

	// these are parameters defining the system
	// alpha: coupling phase lag
	// beta: adaptation characteristic
	// epsilon: adaptation rate
	// gamma: detuning parameter
	localparam[31:0] sin_alpha = 32'h003cda14;		// alpha = 0.24
	localparam[31:0] cos_alpha = 32'h00f8a99b;
	localparam[31:0] two_sin_beta = 32'h01ffc81c;	// beta = 1.6
	localparam[31:0] two_cos_beta = 32'hfff10cc3;	
	localparam[31:0] epsilon = 32'h00028f5c;		// 0.01
	localparam[31:0] gamma = 32'h00051eb8;			// 0.02 

	localparam[31:0] dh = 32'h00a3d710; 			// timestep 0.04
	
	// Computing some constants
	wire signed[31:0] wh;
	wire signed[31:0] he;
	wire signed[31:0] neg_he;
	Q8_24_multiplier mult_wh(dh, w, wh);
	Q8_24_multiplier mult_he(dh, epsilon, he);
	Q8_24_negate negate_he(he, neg_he);

	// Compute trig stuff	
	wire signed[31:0] sin_theta_n;
	wire signed[31:0] cos_theta_n;
	trigonometry trig_theta(theta_n, cos_theta_n, sin_theta_n);
	wire signed[31:0] two_sin_beta_cos_theta;
	Q8_24_multiplier mult_trig1(two_sin_beta, cos_theta_n, two_sin_beta_cos_theta);
	wire signed[31:0] two_cos_beta_sin_theta;
	Q8_24_multiplier mult_trig2(two_cos_beta, sin_theta_n, two_cos_beta_sin_theta);
	wire signed[31:0] neg_two_cos_beta_sin_theta;
	Q8_24_negate negate_trig(two_cos_beta_sin_theta, neg_two_cos_beta_sin_theta);

	// Computing y_n1 from y_n
	wire signed[31:0] y_int;
	wire signed[31:0] y_add;
	Q8_24_multiplier mult_he_y_int(y_int, neg_he, y_add);
	Q8_24_adder int_add_y(y_n, two_sin_beta_cos_theta, y_int);
	Q8_24_adder final_add_y(y_n, y_add, y_n1);

	// Computing z_n1 from z_n
	wire[31:0] z_int;
	wire[31:0] z_add;
	Q8_24_multiplier mult_he_z_int(z_int, neg_he, z_add);
	Q8_24_adder int_add_z(z_n, neg_two_cos_beta_sin_theta, z_int);
	Q8_24_adder final_add_z(z_n, z_add, z_n1);

	// Computing intermediates for theta
	wire[31:0] cos_alpha_sin_theta_n;
	Q8_24_multiplier mult_theta_int1(cos_alpha, sin_theta_n, cos_alpha_sin_theta_n);
	wire[31:0] sin_alpha_cos_theta_n;
	Q8_24_multiplier mult_theta_int2(sin_alpha, cos_theta_n, sin_alpha_cos_theta_n);

	wire[31:0] y_cos_alpha_sin_theta_n;
	Q8_24_multiplier mult_theta_int3(y_n, cos_alpha_sin_theta_n, y_cos_alpha_sin_theta_n);
	wire[31:0] neg_y_cos_alpha_sin_theta_n;
	Q8_24_negate negate_theta_int(y_cos_alpha_sin_theta_n, neg_y_cos_alpha_sin_theta_n);

	wire[31:0] z_sin_alpha_cos_theta_n;
	Q8_24_multiplier mult_theta_int4(z_n, sin_alpha_cos_theta_n, z_sin_alpha_cos_theta_n);

	wire[31:0] whn;
	wire[31:0] sin_whn;
	wire[31:0] A_sin_whn;
	Q8_24_multiplier mult_whn(wh, n, whn);
	trigonometry trig_whn(whn, , sin_whn);
	Q8_24_multiplier mult_sin_whn(sin_whn, A, A_sin_whn);
	
	wire[31:0] theta_int_1;
	Q8_24_adder add_theta_int1(A_sin_whn, gamma, theta_int_1);
	wire[31:0] theta_int_2;
	Q8_24_adder add_theta_int2(neg_y_cos_alpha_sin_theta_n, z_sin_alpha_cos_theta_n, theta_int_2);

	// Computing theta_n1 from theta_n
	wire[31:0] theta_int;
	wire[31:0] theta_add;
	Q8_24_multiplier mult_theta_dh(dh, theta_int, theta_add);
	Q8_24_adder int_add_theta(theta_int_1, theta_int_2, theta_int);
	Q8_24_adder final_add_theta(theta_n, theta_add, theta_n1);
endmodule


module oscillator_solver(
	input wire signed[31:0] theta0, y0, z0,
	input wire slow_clk,	// clock that waits for trigonometric operations to finish, ideally N/24 divider
	input wire rst,
	output reg signed[31:0] theta, y, z
);

reg[31:0] n;
reg signed[31:0] y_n, z_n, theta_n;
wire signed[31:0] y_n1, z_n1, theta_n1, theta_n_clamped;
partial_mod_2pi m2pi(theta_n, theta_n_clamped);

oscillator_step next_state(theta_n_clamped, y_n, z_n, theta_n1, y_n1, z_n1, n << 24);

always @(posedge rst)
begin
end

always @(posedge slow_clk, posedge rst)
begin
    if (rst)
    begin
        y_n <= y0;
        z_n <= z0;
        theta_n <= theta0;
        y <= y0;
        z <= z0;
        theta <= theta0;
        n = 32'b0;
    end
    else
    begin
        theta <= theta_n1;
        y <= y_n1;
        z <= z_n1;
        y_n <= y_n1;
        z_n <= z_n1;
        theta_n <= theta_n1;
        n = n + 1;
	end
    
end

endmodule

