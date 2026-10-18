module BoothMultiplier_tb;
    logic [10:0] multiplicand;
    logic [10:0] multiplier;
    logic [21:0] product;
	logic clk;

    // Unit under test (combinational)
    BoothMultiplier uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 time unit period, used only to pace the test vectors

    initial begin
        // Initialize
        clk = 0;
        multiplicand = 0;
        multiplier = 0;

        // Test vectors: one pair per clock edge, check product in the waveform
		@(posedge clk);
		multiplicand = 896;
		multiplier = 608; // expected 544768
		
        @(posedge clk);
		multiplicand = 608;
        multiplier = 0; // expected 0
		
		@(posedge clk);
		multiplicand = 0;
        multiplier = 896; // expected 0

		@(posedge clk);
		multiplicand = 15;
        multiplier = 2; // expected 30

		@(posedge clk);
		multiplicand = 25;
        multiplier = 10; // expected 250

		@(posedge clk);
		multiplicand = 255;
        multiplier = 128; // expected 32640

		@(posedge clk);
		multiplicand = 333;
        multiplier = 926; // expected 308358

		@(posedge clk);
		multiplicand = 882;
        multiplier = 438; // expected 386316

		@(posedge clk);
		multiplicand = 348;
        multiplier = 997; // expected 346956

		@(posedge clk);
		multiplicand = 50;
        multiplier = 1; // expected 50
		
    end
endmodule

