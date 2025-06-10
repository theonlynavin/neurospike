`timescale 1ns / 1ps

module testbench_arithmetic;
  
  reg clk;
  reg rst;
  reg signed [31:0] a; 
  reg signed [31:0] b; 

  always #5 clk = ~clk; // 10 ns clock period (100 MHz)

  wire signed [31:0] prod;

  Q8_24_multiplier multiplier_inst(a, b, prod);

  task change_input(input signed[31:0] change);
    begin
      a=a+change;
      b=b-change;
      #20 $display("a = %f, b = %f, product = %f", $itor(a)*(2.0**-24.0), $itor(b)*(2.0**-24.0), $itor(prod)*(2.0**-24.0));
    end
  endtask

  initial
  begin

    $dumpfile("multiplier.vcd");
    $dumpvars;
    a = 32'h00001000;
    b = 32'h00300000;
    clk = 0;
    rst = 1;
    #10 $display("a = %f, b = %f, product = %f", $itor(a)*(2.0**-24.0), $itor(b)*(2.0**-24.0), $itor(prod)*(2.0**-24.0));
    #10 change_input(32'h00600000);
    #10 change_input(~32'h0800000);
    #10 change_input(32'h00000010);

    #10 $finish;

  end 

endmodule
