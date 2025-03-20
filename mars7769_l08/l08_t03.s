/*
-------------------------------------------------------
l08_t03.s
-------------------------------------------------------
Author:Michael Marsillo
ID:169057769
Email:mars7769@mylaurier.ca
Date:    2024-02-21
-------------------------------------------------------
Uses a subroutine to read strings from the UART into memory.
-------------------------------------------------------
*/
.org 0x1000   // Start at memory location 1000
.text         // Code section
.global _start
_start:

bl    EchoString

_stop:
b _stop

// Subroutine constants
.equ UART_BASE, 0xff201000  // UART base address
.equ VALID, 0x8000          // Valid data in UART mask
.equ ENTER, 0x0A            // The enter key code

EchoString:
/*
-------------------------------------------------------
Echoes a string from the UART to the UART.
-------------------------------------------------------
Uses:
  r0 - holds character to print
  r1 - address of UART
-------------------------------------------------------
*/

//=======================================================

// your code here
stmfd sp!, {r0, r1}      // Preserve registers
ldr   r1, =UART_BASE     // Load UART base address

esLOOP:
ldr   r0, [r1]           // Read UART data register
tst   r0, #VALID         // Check if data is available
beq   esLOOP             // Wait for input

cmp   r0, #ENTER         // Check if ENTER key was pressed
beq   _EchoDone          // Stop if ENTER is found

str   r0, [r1]           // Echo character to UART
b     esLOOP             // Continue looping

_EchoDone:
ldmfd sp!, {r0, r1}      // Restore registers
//=======================================================


bx    lr               // return from subroutine

.end