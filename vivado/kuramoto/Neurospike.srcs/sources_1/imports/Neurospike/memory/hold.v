module controlled_hold (
    input clk,
    input reset,
    input load,
    input [31:0] d,
    output reg [31:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 32'b0;
        else if (load)
            q <= d;
    end
endmodule
