/*
-------------------------------------------------------
l06_t01.s
-------------------------------------------------------
Author:Michael Marsillo
ID:169057769
Email:mars7769@mylaurier.ca
Date:    2025-03-07
-------------------------------------------------------
Working with stack frames.
Compare two strings up to length of n characters.
-------------------------------------------------------
*/
// Constants
.equ SIZE, 80

.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

mov    r3, #SIZE     // Set the maximum comparison length
stmfd  sp!, {r3}     // Push the maximum length
ldr    r3, =Second
stmfd  sp!, {r3}     // Push the second string address
ldr    r3, =First
stmfd  sp!, {r3}     // Push the first string address
bl     strncmp
add    sp, sp, #12   // Release the parameter memory from stack

// Result in r0
_stop:
b    _stop

//-------------------------------------------------------
strncmp:
/*
-------------------------------------------------------
Determines if two strings are equal up to a max length (iterative)
Equivalent of: strncmp(*str1, *str2, max_buffer_size)
-------------------------------------------------------
Parameters:
  str1 - address of first string
  str2 - address of second buffer
  max_buffer_size - maximum size of str1 and str2
Returns:
  r0 - less than 0 if first string comes first,
       greater than 0 if first string comes second,
       0 if two strings are equal up to maximum length
Uses:
  r1 - address of first string
  r2 - address of second string
  r3 - current maximum length
  r4 - character from first string
  r5 - character from second string
-------------------------------------------------------
*/
//=======================================================

// prologue: save registers and get parameters from stack

//=======================================================
stmfd   sp!, {r1-r5, lr}  // Save registers r1 to r5 and link register
ldr     r1, [sp, #12]     // Load address of first string (was third pushed)
ldr     r2, [sp, #8]     // Load address of second string (was second pushed)
ldr     r3, [sp, #4]     // Load max buffer size (was first pushed)

mov     r0, #0          // Initialize result to strings equal

strncmpLoop:
cmp     r3, #0
beq     _strncmp        // Max length met - finish comparison
ldrb    r4, [r1], #1    // Get character from first string
ldrb    r5, [r2], #1    // Get character from second string
cmp     r4, r5
subne   r0, r4, r5      // Calculate difference between two characters if not the same
bne     _strncmp        // Return difference if not the same
cmp     r4, #0          // look for end of first string
beq     _strncmp        // return if at end of string
cmp     r5, #0          // look for end of second string
beq     _strncmp        // return if at end of string
sub     r3, r3, #1      // decrement max length count
b       strncmpLoop

_strncmp:

//=======================================================

// epilogue: clean up stack

//=======================================================
ldmfd   sp!, {r1-r5, lr}  // Restore registers properly
bx      lr                // Return to caller


//-------------------------------------------------------
.data
First:
.asciz "aaaa"
Second:
.asciz "aaab"

.end