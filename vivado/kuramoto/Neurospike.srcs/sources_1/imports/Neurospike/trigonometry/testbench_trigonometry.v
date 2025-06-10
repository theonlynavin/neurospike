`timescale 1ns / 1ps

module testbench_trigonometry;
  
  reg clk;
  reg rst;
  reg signed [31:0] angle; 

  wire signed [31:0] sine;  
  wire signed [31:0] cosine; 

  trigonometry trig (
    angle,
    cosine,
    sine
  );

  always #5 clk = ~clk; // 10 ns clock period (100 MHz)

  task apply_input(input signed[31:0] test_angle);
    begin
      angle = test_angle;
      #1 $display("angle = %f, sine = %f, cosine = %f", $itor(angle)*(2.0**-24.0), $itor(sine)*(2.0**-24.0), $itor(cosine)*(2.0**-24.0));
    end
  endtask

  initial
  begin

    $dumpfile("cordic.vcd");
    $dumpvars;
    clk = 0;
    rst = 1;
    angle = 32'hf9b7812b;

  end

  always @(posedge clk) begin
    apply_input(angle + 32'h00010000);
    if (angle > $signed(32'h0a487ed5)) $finish;
  end 

endmodule
