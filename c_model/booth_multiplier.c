#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Radix-4 shift-and-add multiplier: the multiplier is scanned 2 bits at a time
// and each 2-bit digit (0-3) adds 0, 1, 2 or 3 times the shifted multiplicand.
// There is no Booth recoding here, see modified_booth_multiplier.c for that.

int binaryToDecimal(long long n);
long long decimalToBinary(int n);
int addBinary(int a, int b);

int main() {
    int multiplicand = 255;
    int multiplier = 255; 

    // Convert decimal numbers to binary
    int binaryMultiplicand = decimalToBinary(multiplicand);
    int binaryMultiplier = decimalToBinary(multiplier);

    printf("Multiplicand (Binary): %lld\n", binaryMultiplicand);
    printf("Multiplier (Binary): %lld\n", binaryMultiplier);

    // Radix-4 multiplication over n = 16 multiplier bits

    int product = 0;
    int n = 16;

    for (int i = 0; i < n; i += 2) {
        int bit1 = (multiplier >> i) & 1;           // Extracting the LSB of the Group
        int bit2 = (multiplier >> (i + 1)) & 1;     // Extracting the Second Bit of the Group
        int group = (bit2 * 2) | bit1;              // 2-bit digit, 0 to 3

        /*
        Digit --> partial product
        00 --> 0
        01 --> multiplicand << i
        10 --> multiplicand << (i + 1)
        11 --> (multiplicand << i) + (multiplicand << (i + 1))
        */

        if (group == 1) {
            product = addBinary(product, multiplicand << i);
        } else if (group == 2) {
            product = addBinary(product, multiplicand << (i + 1));
        } else if (group == 3) {
            product = addBinary(product, (multiplicand << i) + (multiplicand << (i + 1)));
        }
    }

    printf("Product (Decimal): %d\n", product);
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
