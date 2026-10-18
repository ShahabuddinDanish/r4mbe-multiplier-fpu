// 1-bit full adder (3:2 compressor)
module FullAdder(
    input logic a,
    input logic b,
    input logic cin,
    output logic sum,    // Same column
    output logic carry   // Next column
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);
endmodule

