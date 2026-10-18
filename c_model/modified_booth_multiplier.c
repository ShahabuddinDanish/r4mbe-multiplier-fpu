#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Radix-4 Modified Booth multiplier: overlapping 3-bit groups of the multiplier
// are recoded into {0, +X, +2X, -2X, -X} and the signed partial products are summed.

int binaryToDecimal(long long n);
long long decimalToBinary(int n);
int addBinary(int a, int b);

int main() {
    int multiplicand = 896;
    int multiplier = 608; 

    // Convert decimal numbers to binary
    int binaryMultiplicand = decimalToBinary(multiplicand);
    int binaryMultiplier = decimalToBinary(multiplier);

    printf("Multiplicand (Binary): %lld\n", binaryMultiplicand);
    printf("Multiplier (Binary): %lld\n", binaryMultiplier);

    // Modified Booth Algorithm with 3-bit grouping

    int n = 16;
    int partialProducts[6] = {0};  // Array to store partial products (at most 6)
    int ppIndex = 0;        // Index for partial products array
    int product = 0;
    int previousBit = 0; // y(-1) = 0 for the first group

    // 6 groups {y(i+1), y(i), y(i-1)}, i = 0, 2, ..., 10
    for (int i = 0; i < 12; i += 2) {
        int bit1 = (multiplier >> i) & 1;          // y(i)
        int bit2 = (multiplier >> (i + 1)) & 1;    // y(i+1)
        int group = (bit2 << 2) | (bit1 << 1) | previousBit;

        printf("For i %d: ", i);
        printf("bit1 is %d, ", bit2);
        printf("bit2 is %d, ", bit1);
        printf("bit3 is %d, ", previousBit);
        printf("group is %d. \n", group);

        previousBit = bit2; // y(i+1) is the overlap bit of the next group

        switch (group) {
            case 0: // 000
            case 7: // 111
                // No operation
                break;
            case 1: // 001
            case 2: // 010
                // +X, shifted to the group position
                partialProducts[ppIndex++] = multiplicand << i;
                break;
            case 3: // 011
                // +2X
                partialProducts[ppIndex++] = (multiplicand << 1) << i;
                break;
            case 4: // 100
                // -2X
                partialProducts[ppIndex++] = -(multiplicand << 1) << i;
                break;
            case 5: // 101
            case 6: // 110
                // -X
                partialProducts[ppIndex++] = -multiplicand << i;
                break;
        }
    }

    // Summing the Partial Products
    for (int i = 0; i < ppIndex; ++i) {
        printf("Partial Product %d is: %d\n", i, partialProducts[i]);
        product = addBinary(product, partialProducts[i]);
    }

    printf("Product (Decimal): %d\n", product);

    int binaryProduct = decimalToBinary(product);

    printf("Product (Binary): %d\n", binaryProduct);
    return 0;
}

// Function to convert decimal to binary
long long decimalToBinary(int n) {
    long long binaryNumber = 0;
    int remainder, i = 1;

    while (n != 0) {
        remainder = n % 2;
        n /= 2;
        binaryNumber += remainder * i;
        i *= 10;
    }
    return binaryNumber;
}

// Function to convert a binary-digit number back to decimal
int binaryToDecimal(long long n) {
    int decimalNumber = 0, i = 0, remainder;
    while (n != 0) {
        remainder = n % 10;
        n /= 10;
        decimalNumber += remainder * (1 << i);
        ++i;
    }
    return decimalNumber;
}

// Function to add two binary numbers
int addBinary(int a, int b) {
    int carry;
    while (b != 0) {
        // Carry now contains common set bits of a and b
        carry = a & b;

        // Sum of bits of a and b where at least one of the bits is not set
        a = a ^ b;

        // Carry is shifted by one so that adding it to a gives the required sum
        b = carry << 1;
    }
    return a;
}
