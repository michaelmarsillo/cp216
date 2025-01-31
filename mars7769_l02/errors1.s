/*
-------------------------------------------------------
errors1.s
-------------------------------------------------------
Author:Michael Marsillo
ID:169057769
Email:mars7769@mylaurier.ca
Date:2025/01/31
-------------------------------------------------------
Assign to and add contents of registers.
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

// Copy data from memory to registers
ldr r3, =A // Syntax Error: Removed semi-colon to load the address of A into r3
ldr r0, [r3]
ldr r3, =B // Syntax Error: Removed colon to load address of B into r3
ldr r1, [r3]
add r2, r1, r0 // Syntax Error: memory does not allow [r0] as a second source operand
// Copy data to memory
ldr r3, =Result // Assign address of Result to r3
str r2, [r3] // Store contents of r2 to address in r3
// End program
_stop:
b _stop

.data      // Initialized data section
A:
.word 4
B:
.word 8
.bss     // Uninitialized data section
Result:
.space 4 // Set aside 4 bytes for result

.end