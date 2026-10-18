module Radix4Encoder (
    input logic [10:0] multiplicand,     // Multiplicand X
    input logic bitN,                    // Multiplier bit y(2i)
	input logic bitNminus1,              // Multiplier bit y(2i+1), MSB of the slice
	input logic bitNplus1,               // Multiplier bit y(2i-1), LSB of the slice (overlap)
    output logic [11:0] partialProduct,  // 12 bits to hold the 2X case
    output logic sign                    // 1 when the partial product is negative
);

    // 3-bit Booth slice and internal partial product
    logic [2:0] booth_code;
	logic [11:0] internalPartialProduct;
	logic internalSign;

    assign partialProduct = internalPartialProduct; 
	assign sign = internalSign;

    // Partial product selection, using only shifts and inversions
    always_comb begin

        booth_code = {bitNminus1, bitN, bitNplus1};

        case (booth_code)
            3'b000, 3'b111: begin // 0
                internalPartialProduct = 12'b0;
                internalSign = 0;
            end
            3'b001, 3'b010: begin // +X
                internalPartialProduct = multiplicand;
                internalSign = 0;
            end
            3'b011: begin // +2X
                internalPartialProduct = (multiplicand << 1);
                internalSign = 0;
            end
            3'b100: begin // -2X, the +1 is added in the Dadda tree
                internalPartialProduct = ~(multiplicand << 1);
                internalSign = 1;
            end
            3'b101, 3'b110: begin // -X, the +1 is added in the Dadda tree
                internalPartialProduct = ~multiplicand;
                internalSign = 1;
            end
        endcase            
    end

endmodule

