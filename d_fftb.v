
module d_fftb;

reg D, clk, rst;
wire Q;

// Instantiate D Flip-Flop
d_ff uut (
    .D(D),
    .clk(clk),
    .rst(rst),
    .Q(Q)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test inputs
initial begin

    $monitor("Time=%0t | D=%b clk=%b rst=%b | Q=%b",
              $time, D, clk, rst, Q);

    rst = 1; D = 0;
    #10;

    rst = 0; D = 0;
    #10;

    D = 1;
    #10;

    D = 0;
    #10;

    D = 1;
    #10;

    D = 1;
    #10;

    D = 0;
    #10;

    $finish;
end

endmodule
