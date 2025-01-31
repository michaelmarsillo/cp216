/*
-------------------------------------------------------
errors3.s
-------------------------------------------------------
Author:Michael Marsillo
ID:169057769
Email:mars7769@mylaurier.ca
Date:2025/01/31
-------------------------------------------------------
Copies contents of one vector to another.
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

.text // code section
// Copy contents of first element of Vec1 to Vec2
ldr r0, =Vec1
ldr r1, =Vec2
ldr r2, [r0]
str r2, [r1]
// Copy contents of second element of Vec1 to Vec2
add r0, r0, #4 // Error: Change increment to 4 instead of 2
add r1, r1, #4 // Error: Change increment to 4 instead of 2
ldr r2, [r0]
str r2, [r1]
// Copy contents of second element of Vec1 to Vec2
add r0, r0, #4 // Error: changed to r0 to not skip the third element
add r1, r1, #4
ldr r2, [r0]
str r2, [r1] // Error: Changed to r1 instead of r2
// End program
_stop:
b _stop

.data // Initialized data section
Vec1:
.word 1, 2, 3
.bss // Uninitialized data section
Vec2:
.space 12 // Error: Reserve 12 bytes (3x4 words) for Vec2

.end