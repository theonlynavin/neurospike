module partial_mod_2pi (
    input signed [31:0] theta,                  // Q8.24 angle in radians in (-2pi, 4pi)
    output reg signed [31:0] theta_clamped
);
    always @(*) 
    begin
        if (theta[31] == 1) begin
            theta_clamped = theta + 32'h06487ed5;   // Raise up by 2pi
        end 
        else if (theta > 32'h06487ed5) begin 
            theta_clamped = theta - 32'h06487ed5;   // Bring down by 2pi
        end  
        else begin
            theta_clamped = theta;
        end
    end
endmodule

module place_quadrant (
    input wire signed [31:0] theta,         // Q8.24 angle in radians between 0 and 2pi
    output reg signed [31:0] theta_clamped, // Q8.24 angle in radians between 0 and pi/2
    output reg [1:0] quadrant               // quadrant location
);

    always @(*) begin
        if (theta > 32'h01921fb5) begin         // More than pi/2
            if (theta < 32'h03243f6b) begin     // Less than pi
                theta_clamped = 32'h03243f6b - theta;
                quadrant = 2'd1;
            end 
            else if (theta < 32'h04b65f20) begin // Between pi and 3pi/2
                theta_clamped = theta - 32'h03243f6b;
                quadrant = 2'd2;
            end 
            else begin                           // Between 3pi/2 and 2pi
                theta_clamped = 32'h06487ed5 - theta;
                quadrant = 2'd3; 
            end 
        end
        else begin                               // Pretty good!
            theta_clamped = theta;
            quadrant = 2'd0;
        end 
    end

endmodule


    