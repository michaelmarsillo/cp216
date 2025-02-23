.global _start
_start:
	
/*
-------------------------------------------------------
l05_t01.s
-------------------------------------------------------
Author:Michael Marsillo 
ID:169057769
Email:mars7769@mylaurier.ca
Date:    2024-02-21
-------------------------------------------------------
Does a running total of an integer list.
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

ldr    r1, =Data    // Store address of start of list
ldr    r2, =_Data   // Store address of end of list
bl     list_total   // Call subroutine - total returned in r0

_stop:
b      _stop

//-------------------------------------------------------
list_total:
/*
-------------------------------------------------------
Totals values in a list.
Equivalent of: int total(*start, *end)
-------------------------------------------------------
Parameters:
  r1 - start address of list
  r2 - end address of list
Uses:
  r3 - temporary value
Returns:
  r0 - total of values in list
-------------------------------------------------------
*/

// your code here
mov r0, #0 // Initialize sum to 0

loop:
cmp r1, r2 // Check if we have reached the end
beq done // if yes, ext

ldr r3, [r1], #4 // Load current element into r3 and move to the next
add r0, r0, r3 // Add r3 to running sum

b loop // Keep looping

done:
mov pc, lr // return statement


.data
.align
Data:
.word   4,5,-9,0,3,0,8,-7,12    // The list of data
_Data: // End of list address

.end