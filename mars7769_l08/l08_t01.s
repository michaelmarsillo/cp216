/*
-------------------------------------------------------
l08_t01.s
-------------------------------------------------------
Author:Michael Marsillo
ID:169057769
Email:mars7769@mylaurier.ca
Date:    2024-02-21
-------------------------------------------------------
Uses a subroutine to write strings to the UART.
-------------------------------------------------------
*/
.org 0x1000  // Start at memory location 1000
.text        // Code section
.global _start
_start:

ldr r4, =First
bl  WriteString
ldr r4, =Second
bl  WriteString
ldr r4, =Third
bl  WriteString
ldr r4, =Last
bl  WriteString

_stop:
b    _stop

// Subroutine constants
.equ UART_BASE, 0xff201000  // UART base address

//=======================================================

// your code here
.equ ENTER, 0x0A	// Define ENTER character

//=======================================================

WriteString:
/*
-------------------------------------------------------
Writes a null-terminated string to the UART, adds ENTER.
-------------------------------------------------------
Parameters:
  r4 - address of string to print
Uses:
  r0 - holds character to print
  r1 - address of UART
-------------------------------------------------------
*/

//=======================================================

// your code here
stmfd sp!, {r0, r1, r4}  // Preserve registers
ldr   r1, =UART_BASE     // Load UART base address

wsLOOP:
ldrb  r0, [r4], #1       // Load a byte from the string
cmp   r0, #0
beq   _WriteString       // Stop when NULL character is found
str   r0, [r1]           // Write character to UART
b     wsLOOP

_WriteString:
ldr   r0, =ENTER         // Load ENTER character
str   r0, [r1]           // Send ENTER to UART
ldmfd sp!, {r0, r1, r4}  // Restore registers
//=======================================================

bx    lr                 // return from subroutine

.data
.align
// The list of strings
First:
.asciz  "First string"
Second:
.asciz  "Second string"
Third:
.asciz  "Third string"
Last:
.asciz  "Last string"
_Last:    // End of list address

.end