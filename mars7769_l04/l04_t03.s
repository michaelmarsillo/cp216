/*
-------------------------------------------------------
l04_t03.s
-------------------------------------------------------
Author:  David Brown
ID:      123456789
Email:   dbrown@wlu.ca
Date:    2023-07-31
-------------------------------------------------------
A simple list demo program. Traverses all elements of an integer list.
r0: temp storage of value in list
r2: address of start of list
r3: address of end of list
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

ldr    r2, =Data    // Store address of start of list
ldr    r3, =_Data   // Store address of end of list
mov    r4, #0       // Initialize sum to 0
sub    r5, r3, r2   // Adds total bytes in list 
mov    r4, #1       // Initialize count to count 1

ldr    r6, [r2], #4 // Load first value as initial min
mov    r7, r6       // Copy first value as initial max

Loop:
cmp    r2, r3       // Check if we have reached the end
bge    _stop        // If r2 >= r3, exit loop

ldr    r0, [r2], #4 // Load next value and increment address
add    r4, r4, #1   // Increment count

cmp    r0, r6       // Compare current value with min
movlt  r6, r0       // If r0 < r6, update min

cmp    r0, r7       // Compare current value with max
movgt  r7, r0       // If r0 > r7, update max

b      Loop         // Repeat loop

_stop:
b _stop

.data
.align
Data:
.word   4,5,-9,0,3,0,8,-7,12    // The list of data
_Data: // End of list address

.end