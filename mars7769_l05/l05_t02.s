/*
-------------------------------------------------------
l05_t02.s
-------------------------------------------------------
Author:Michael Marsillo 
ID:169057769
Email:mars7769@mylaurier.ca
Date:    2024-02-21
-------------------------------------------------------
Calculates stats on an integer list.
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

mov    r1, #0       // Initialize counters
mov    r2, #0
mov    r3, #0
ldr    r4, =Data    // Store address of start of list
ldr    r5, =_Data   // Store address of end of list
bl     list_stats   // Call subroutine - total returned in r0

_stop:
b      _stop

//-------------------------------------------------------
list_stats:
/*
-------------------------------------------------------
Counts number of positive, negative, and 0 values in a list.
Equivalent of: void stats(*start, *end, *zero, *positive, *negatives)
-------------------------------------------------------
Parameters:
  r1 - number of zero values
  r2 - number of positive values
  r3 - number of negative values
  r4 - start address of list
  r5 - end address of list
Uses:
  r0 - temporary value
-------------------------------------------------------
*/

// your code here
list_stats:
    stmfd   sp!, {r4, r5, lr}   // Preserve registers

loop:
cmp    r4, r5         // Check if start address reached end address
beq    done           // If equal, exit loop

ldr    r0, [r4], #4   // Load value from memory and advance pointer

cmp    r0, #0         // Compare value with 0
beq    count_zero     // If 0, branch to count_zero
bmi    count_neg      // If negative, branch to count_neg

add    r2, r2, #1     // Increment positive count
b      loop           // Continue loop

count_zero:
add    r1, r1, #1     // Increment zero count
b      loop           // Continue loop

count_neg:
add    r3, r3, #1     // Increment negative count
b      loop           // Continue loop

done:
ldmfd   sp!, {r4, r5, lr}   // Restore registers
bx      lr                  // Return



.data
.align
Data:
.word   4,5,-9,0,3,0,8,-7,12    // The list of data
_Data: // End of list address

.end