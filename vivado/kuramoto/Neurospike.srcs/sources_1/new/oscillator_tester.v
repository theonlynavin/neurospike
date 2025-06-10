`timescale 1ns / 1ps

module oscillator_tester(
    input in_clk,
    input rst,
    output[5:0] y_osc,
    output[5:0] z_osc
    );
    
    reg slow_clk;
    reg[23:0] counter=24'd0;
    always @(posedge in_clk)
    begin
        counter <= counter + 24'd1;
        if(counter>=({24{1'b1}}))
        begin
            slow_clk <= ~slow_clk;
            counter <= 24'd0;
        end
    end
    
    wire[31:0] theta, y, z;
    
    oscillator_solver solver(32'h00028f5c, 32'h00028f5c, 32'h00028f5c, slow_clk, rst, theta, y, z);
    
    assign y_osc = y[5:0];
    assign z_osc = z[5:0];
    
endmodule
