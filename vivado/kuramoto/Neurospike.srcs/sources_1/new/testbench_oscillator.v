module testbench_oscillator;
    
    reg clk;
    reg slow_clk;
    reg rst;
    reg[31:0] theta0, y0, z0;
    
    always #1 clk = ~clk; // 2 ns clock perio
    always #24 slow_clk = ~slow_clk; // 48 ns clock period
    
    wire[31:0] theta, y, z;
    oscillator_solver solver(theta0, y0, z0, slow_clk, rst, theta, y, z);
    
    initial 
    begin
    
    rst = 0;
    theta0 = 32'hfff10cc3;
    y0 = 32'hfff10cc3;
    z0 = 32'hfff10cc3;
    clk = 0;
    slow_clk = 0;
    #5 rst = 1;
    #5 rst = 0;
    #500000 $finish;
    
    end
    
endmodule
