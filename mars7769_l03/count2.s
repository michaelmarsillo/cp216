/*
-------------------------------------------------------
count2.s
-------------------------------------------------------
Author:Michael Marsillo
ID:169057769
Email:mars7769@mylaurier.ca
Date:2025/02/06
-------------------------------------------------------
A simple count down program (bge)
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

// Store data in registers
ldr r3, =COUNTER // Load address
ldr r3, [r3]    // Load value stored at COUNTER into r3

TOP:
sub r3, r3, #1 // Decrement the countdown value
cmp r3, #0  // Compare the countdown value to 0
bge TOP   // Branch to top under certain conditions

// The address of COUNTER in hex is 00001020 or 0x1020

_stop:
b _stop

.data            // Define memory locations
COUNTER:
.word 5

.end