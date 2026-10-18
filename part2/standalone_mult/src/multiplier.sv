module BoothMultiplier (
    input logic [10:0] multiplicand,  // Operand X (FP16 mantissa with hidden bit)
    input logic [10:0] multiplier,    // Operand Y, split into radix-4 Booth slices
    output logic [21:0] product       // X * Y
);

	// Encoder outputs: 12-bit partial products and their sign bits
	logic [11:0] partialProduct1;
	logic [11:0] partialProduct2;
	logic [11:0] partialProduct3;
	logic [11:0] partialProduct4;
	logic [11:0] partialProduct5;
    logic [11:0] partialProduct6;

    logic sign1;
	logic sign2;
    logic sign3;
    logic sign4;
    logic sign5;
    logic sign6;

	// Dadda tree outputs and final sum
	logic [21:0] daddaSum;
	logic [21:0] daddaCarry;
	logic [21:0] daddaProduct;

	assign product = daddaProduct;

    // Radix-4 encoders: slice i = {y(2i+1), y(2i), y(2i-1)}, y(-1) = 0 for e1 and y(11) = 0 for e6
    Radix4Encoder e1(.multiplicand(multiplicand), .bitNminus1(multiplier[1]), .bitN(multiplier[0]), .bitNplus1(1'b0), .partialProduct(partialProduct1), .sign(sign1));
    Radix4Encoder e2(.multiplicand(multiplicand), .bitNminus1(multiplier[3]), .bitN(multiplier[2]), .bitNplus1(multiplier[1]), .partialProduct(partialProduct2), .sign(sign2));
    Radix4Encoder e3(.multiplicand(multiplicand), .bitNminus1(multiplier[5]), .bitN(multiplier[4]), .bitNplus1(multiplier[3]), .partialProduct(partialProduct3), .sign(sign3));
    Radix4Encoder e4(.multiplicand(multiplicand), .bitNminus1(multiplier[7]), .bitN(multiplier[6]), .bitNplus1(multiplier[5]), .partialProduct(partialProduct4), .sign(sign4));
    Radix4Encoder e5(.multiplicand(multiplicand), .bitNminus1(multiplier[9]), .bitN(multiplier[8]), .bitNplus1(multiplier[7]), .partialProduct(partialProduct5), .sign(sign5));
    Radix4Encoder e6(.multiplicand(multiplicand), .bitNminus1(1'b0), .bitN(multiplier[10]), .bitNplus1(multiplier[9]), .partialProduct(partialProduct6), .sign(sign6));

    // Dadda tree: reduces the 6 partial products and sign bits to sum and carry rows
    DaddaTree dadda (
        .pp1(partialProduct1),
        .pp2(partialProduct2),
        .pp3(partialProduct3),
        .pp4(partialProduct4),
        .pp5(partialProduct5),
        .pp6(partialProduct6),
        .s1(sign1),
        .s2(sign2),
        .s3(sign3),
        .s4(sign4),
        .s5(sign5),
        .s6(sign6),
		.sum(daddaSum),
		.carry(daddaCarry)
    );

    // Final addition of the two rows (carry out of bit 21 is discarded)
    always_comb begin
		daddaProduct = daddaSum + daddaCarry;
	end
endmodule

