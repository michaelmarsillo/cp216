/*
-------------------------------------------------------
l01.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Michael Marsillo
ID:      169057769
Email:   mars7769@mylaurier.ca
Date:    2025-01-15
-------------------------------------------------------
*/
.org    0x1000  // Start at memory location 1000
.text           // Code section
.global _start
_start:

mov r0, #9       // Store decimal 9 in register r0

// Task 1
mov r1, #14     // Store hex E (decimal 14) in register r1 (Changing to decimal 14 does not change anything)
add r2, r1, r0  // Add the contents of r0 and r1 and put result in r2

// Task 2
mov r3, #8      // Put the decimal value 8 into r3
add r3, r3, r3 // Add r3 to r3 and then put the result into r3

// Task 3
// add r4, #4, #5 (Does not compile)
add r4, r5, #5  // Replacing the middle operand with a register allows it to function


// End program
_stop:
b   _stop

.end