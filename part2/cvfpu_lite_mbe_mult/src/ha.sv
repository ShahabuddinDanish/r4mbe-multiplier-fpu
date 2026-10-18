// 1-bit half adder (2:2 compressor)
module HalfAdder(
    input logic a,
    input logic b,
    output logic sum,    // Same column
    output logic carry   // Next column
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

