
module trigonometry (
    input wire signed [31:0] theta,     // Q8.24 angle between 0 and pi/2
    output reg signed [31:0] cos_out,   // cosine output
    output reg signed [31:0] sin_out    // sine output  
);

    wire signed [31:0] theta_int, angle;
    wire signed [31:0] cos_m, sin_m;
    wire [1:0] quadrant;

    partial_mod_2pi m2pi(theta, theta_int);
    place_quadrant pq(theta_int, angle, quadrant);

    cordic c(angle, cos_m, sin_m);

    always @(*) begin
        case (quadrant)
            2'd0: 
            begin
                cos_out = cos_m;  
                sin_out = sin_m;  
            end
            2'd1: 
            begin
                cos_out = -cos_m;  
                sin_out = sin_m;  
            end
            2'd2:
            begin
                cos_out = -cos_m;  
                sin_out = -sin_m;  
            end
            2'd3: 
            begin
                cos_out = cos_m;  
                sin_out = -sin_m;  
            end
        endcase
    end


endmodule
