module DaddaTree(
    input logic [11:0] pp1,  // Partial Product 1
    input logic [11:0] pp2,  // Partial Product 2
    input logic [11:0] pp3,  // Partial Product 3
    input logic [11:0] pp4,  // Partial Product 4
    input logic [11:0] pp5,  // Partial Product 5
    input logic [11:0] pp6,  // Partial Product 6

    input logic s1,			 // Partial Product 1 sign
    input logic s2,			 // Partial Product 2 sign
    input logic s3,			 // Partial Product 3 sign
    input logic s4,			 // Partial Product 4 sign
    input logic s5,			 // Partial Product 5 sign
    input logic s6,			 // Partial Product 6 sign (always 0 for unsigned operands, unused)

    output logic [21:0] sum,	// Dadda sum row
    output logic [21:0] carry	// Dadda carry row
);

    // Half Adder Signals
    
    // Layer 1
    logic ha1s, ha1c;
    logic ha2s, ha2c;
    logic ha3s, ha3c;
    logic ha4s, ha4c;
    logic ha5s, ha5c;  // used in layer 2
    logic ha6s, ha6c;  // used in layer 3
    logic ha7s, ha7c;
    logic ha8s, ha8c;
    logic ha9s, ha9c;

    // Layer 2
    logic ha11s, ha11c;
    logic ha12s, ha12c;

    // Layer 3
    logic ha13s, ha13c;
    logic ha14s, ha14c;

    // Full Adder Signals
    
    // Layer 1    
    logic fa1s, fa1c;
    logic fa2s, fa2c;
    logic fa3s, fa3c;
    logic fa4s, fa4c;
    logic fa5s, fa5c;
    logic fa6s, fa6c;
    logic fa7s, fa7c;
    logic fa8s, fa8c;
    logic fa9s, fa9c;
    logic fa10s, fa10c;
    logic fa11s, fa11c;
    
    // Layer 2
    logic fa12s, fa12c;
    logic fa13s, fa13c;
    logic fa14s, fa14c;
    logic fa15s, fa15c;
    logic fa16s, fa16c;
    logic fa17s, fa17c;
    logic fa18s, fa18c;
    logic fa19s, fa19c;
    logic fa20s, fa20c;
    logic fa21s, fa21c;
    logic fa22s, fa22c;
    logic fa23s, fa23c;
    logic fa24s, fa24c;

    // Layer 3
    logic fa25s, fa25c;
    logic fa26s, fa26c;
    logic fa27s, fa27c;
    logic fa28s, fa28c;
    logic fa29s, fa29c;
    logic fa30s, fa30c;
    logic fa31s, fa31c;
    logic fa32s, fa32c;
    logic fa33s, fa33c;
    logic fa34s, fa34c;
    logic fa35s, fa35c;
    logic fa36s, fa36c;
    logic fa37s, fa37c;
    logic fa38s, fa38c;
    logic fa39s, fa39c;
    logic fa40s, fa40c;
    logic fa41s, fa41c;  // fa41 to fa43 are used in layer 1
    logic fa42s, fa42c;
    logic fa43s, fa43c;
    logic fa44s, fa44c;

    // Dadda tree reduction (ALAP)
    // Column numbers are bit positions 0-21 of the product. ppN starts at column 2*(N-1).
    // Sign handling (Bewick): sN at the LSB column of ppN is the +1 of the two's complement,
    // ~sN one column above the MSB of ppN and 1'b1 one column above that replace the sign extension.
    // pp1 is the exception: s1 is placed in columns 12 and 13 and ~s1 in column 14.

    // Layer 1: 6 -> 4 rows
    HalfAdder ha1(pp1[6], pp2[4], ha1s, ha1c);                  // column 6
    HalfAdder ha2(pp1[7], pp2[5], ha2s, ha2c);                  // column 7
    FullAdder fa1(pp1[8], pp2[6], pp3[4], fa1s, fa1c);          // column 8 
    HalfAdder ha3(pp4[2], pp5[0], ha3s, ha3c);                  // column 8
    FullAdder fa2(pp1[9], pp2[7], pp3[5], fa2s, fa2c);          // column 9
    HalfAdder ha4(pp4[3], pp5[1], ha4s, ha4c);                  // column 9
    FullAdder fa3(pp1[10], pp2[8], pp3[6], fa3s, fa3c);         // column 10 
    FullAdder fa4(pp4[4], pp5[2], pp6[0], fa4s, fa4c);          // column 10
    FullAdder fa5(pp1[11], pp2[9], pp3[7], fa5s, fa5c);         // column 11
    FullAdder fa6(pp4[5], pp5[3], pp6[1], fa6s, fa6c);          // column 11 
    FullAdder fa7(s1, pp2[10], pp3[8], fa7s, fa7c);             // column 12, s1 sign extension
    FullAdder fa8(pp4[6], pp5[4], pp6[2], fa8s, fa8c);          // column 12
    FullAdder fa9(s1, pp2[11], pp3[9], fa9s, fa9c);             // column 13, s1 sign extension
    FullAdder fa10(pp4[7], pp5[5], pp6[3], fa10s, fa10c);       // column 13
    FullAdder fa11(~s1, ~s2, pp3[10], fa11s, fa11c);            // column 14, ~s1 and ~s2
    FullAdder fa41(pp4[8], pp5[6], pp6[4], fa41s, fa41c);       // column 14
    FullAdder fa42(1'b1, pp3[11], pp4[9], fa42s, fa42c);        // column 15, constant 1 for pp2
    HalfAdder ha7(pp5[7], pp6[5], ha7s, ha7c);                  // column 15
    HalfAdder ha8(~s3, pp4[10], ha8s, ha8c);                    // column 16, ~s3
    HalfAdder ha9(pp5[8], pp6[6], ha9s, ha9c);                  // column 16
    FullAdder fa43(1'b1, pp4[11], pp5[9], fa43s, fa43c);        // column 17, constant 1 for pp3

    // Layer 2: 4 -> 3 rows
    HalfAdder ha11(pp1[4], pp2[2], ha11s, ha11c);               // column 4
    HalfAdder ha12(pp1[5], pp2[3], ha12s, ha12c);               // column 5
    FullAdder fa12(ha1s, pp3[2], pp4[0], fa12s, fa12c);         // column 6 
    FullAdder fa13(ha2s, ha1c, pp3[3], fa13s, fa13c);           // column 7
    FullAdder fa14(fa1s, ha2c, ha3s, fa14s, fa14c);             // column 8 
    FullAdder fa15(fa2s, fa1c, ha4s, fa15s, fa15c);             // column 9 
    FullAdder fa16(fa3s, fa2c, fa4s, fa16s, fa16c);             // column 10
    FullAdder fa17(fa5s, fa3c, fa6s, fa17s, fa17c);             // column 11
    FullAdder fa18(fa7s, fa5c, fa8s, fa18s, fa18c);             // column 12
    FullAdder fa19(fa9s, fa7c, fa10s, fa19s, fa19c);            // column 13
    FullAdder fa20(fa11s, fa9c, fa41s, fa20s, fa20c);           // column 14
    FullAdder fa21(fa42s, fa11c, ha7s, fa21s, fa21c);           // column 15
    FullAdder fa22(ha8s, fa42c, ha9s, fa22s, fa22c);            // column 16
    FullAdder fa23(fa43s, ha8c, pp6[7], fa23s, fa23c);          // column 17
    FullAdder fa24(~s4, fa43c, pp5[10], fa24s, fa24c);          // column 18, ~s4
    HalfAdder ha5(1'b1, pp5[11], ha5s, ha5c);                   // column 19, constant 1 for pp4

    // Layer 3: 3 -> 2 rows
    HalfAdder ha13(pp1[2], pp2[0], ha13s, ha13c);               // column 2
    HalfAdder ha14(pp1[3], pp2[1], ha14s, ha14c);               // column 3
    FullAdder fa25(ha11s, pp3[0], s3, fa25s, fa25c);            // column 4, s3
    FullAdder fa26(ha12s, ha11c, pp3[1], fa26s, fa26c);         // column 5
    FullAdder fa27(fa12s, ha12c, s4, fa27s, fa27c);             // column 6, s4
    FullAdder fa28(fa13s, fa12c, pp4[1], fa28s, fa28c);         // column 7
    FullAdder fa29(fa14s, fa13c, s5, fa29s, fa29c);             // column 8, s5
    FullAdder fa30(fa15s, fa14c, ha3c, fa30s, fa30c);           // column 9
    FullAdder fa31(fa16s, fa15c, ha4c, fa31s, fa31c);           // column 10
    FullAdder fa32(fa17s, fa16c, fa4c, fa32s, fa32c);           // column 11
    FullAdder fa33(fa18s, fa17c, fa6c, fa33s, fa33c);           // column 12
    FullAdder fa34(fa19s, fa18c, fa8c, fa34s, fa34c);           // column 13
    FullAdder fa35(fa20s, fa19c, fa10c, fa35s, fa35c);          // column 14
    FullAdder fa36(fa21s, fa20c, fa41c, fa36s, fa36c);          // column 15
    FullAdder fa37(fa22s, fa21c, ha7c, fa37s, fa37c);           // column 16
    FullAdder fa38(fa23s, fa22c, ha9c, fa38s, fa38c);           // column 17
    FullAdder fa39(fa24s, fa23c, pp6[8], fa39s, fa39c);         // column 18
    FullAdder fa40(ha5s, fa24c, pp6[9], fa40s, fa40c);          // column 19
    FullAdder fa44(~s5, ha5c, pp6[10], fa44s, fa44c);           // column 20, ~s5
    HalfAdder ha6(1'b1, pp6[11], ha6s, ha6c);                   // column 21, constant 1 for pp5
     

    // Final rows: columns 0-1 hold only pp1[1:0]; s1 and s2 enter the carry row at columns 0 and 2
    assign sum = {ha6s,fa44s,fa40s,fa39s,fa38s,fa37s,fa36s,fa35s,fa34s,fa33s,fa32s,fa31s,fa30s,fa29s,fa28s,fa27s,fa26s,fa25s,ha14s,ha13s,pp1[1],pp1[0]};
    assign carry = {fa44c,fa40c,fa39c,fa38c,fa37c,fa36c,fa35c,fa34c,fa33c,fa32c,fa31c,fa30c,fa29c,fa28c,fa27c,fa26c,fa25c,ha14c,ha13c,s2,1'b0,s1};


endmodule
