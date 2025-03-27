/*
-------------------------------------------------------
l09.s
-------------------------------------------------------
Author: Michael Marsillo
ID: 169057769
Email: mars7769@mylaurier.ca
Date:    2024-03-30
-------------------------------------------------------
Uses a subroutine to read strings from the UART into memory.
-------------------------------------------------------
*/
.section .vectors, "ax"
B _start            // reset vector
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0             // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector

.equ  UART_ADDR,  0xff201000
.equ  TIMER_BASE, 0xff202000
.equ  ENTER, 0xA

.org 0x1000   // Start at memory location 1000
.text
.global _start
_start:
/* Set up stack pointers for IRQ and SVC processor modes */
MOV R1, #0b11010010 // interrupts masked, MODE = IRQ
MSR CPSR_c, R1 // change to IRQ mode
LDR SP, =0xFFFFFFFF - 3 // set IRQ stack to A9 onchip memory
/* Change to SVC (supervisor) mode with interrupts disabled */
MOV R1, #0b11010011 // interrupts masked, MODE = SVC
MSR CPSR, R1 // change to supervisor mode
LDR SP, =0x3FFFFFFF - 3 // set SVC stack to top of DDR3 memory
BL CONFIG_GIC // configure the ARM GIC
// set timer
BL TIMER_SETTING
// enable IRQ interrupts in the processor
MOV R0, #0b01010011 // IRQ unmasked, MODE = SVC
MSR CPSR_c, R0
IDLE:
B IDLE // main program simply idles

/* Define the exception service routines */
/*--- Undefined instructions --------------------------------------------------*/
SERVICE_UND:
B SERVICE_UND
/*--- Software interrupts -----------------------------------------------------*/
SERVICE_SVC:
B SERVICE_SVC
/*--- Aborted data reads ------------------------------------------------------*/
SERVICE_ABT_DATA:
B SERVICE_ABT_DATA
/*--- Aborted instruction fetch -----------------------------------------------*/
SERVICE_ABT_INST:
B SERVICE_ABT_INST
/*--- IRQ ---------------------------------------------------------------------*/
SERVICE_IRQ:
stmfd sp!,{R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
LDR R4, =0xFFFEC100
LDR R5, [R4, #0x0C] // read from ICCIAR

CMP R5, #72
BLEQ INTER_TIMER_ISR

EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
STR R5, [R4, #0x10] // write to ICCEOIR
//BL STOP_TIMER

ldmfd sp!, {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ---------------------------------------------------------------------*/
SERVICE_FIQ:
B SERVICE_FIQ
//.end

/*
* Configure the Generic Interrupt Controller (GIC)
*/
.global CONFIG_GIC
CONFIG_GIC:
stmfd sp!, {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
MOV R0, #72 // Interval timer (Interrupt ID = 72)
MOV R1, #1 // this field is a bit-mask; bit 0 targets cpu0
BL CONFIG_INTERRUPT
/* configure the GIC CPU Interface */
LDR R0, =0xFFFEC100 // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
LDR R1, =0xFFFF // enable interrupts of all priorities levels
STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
MOV R1, #1
STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
LDR R0, =0xFFFED000
STR R1, [R0]
ldmfd sp!, {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
stmfd sp!, {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
LSR R4, R0, #3 // calculate reg_offset
BIC R4, R4, #3 // R4 = reg_offset
LDR R2, =0xFFFED100
ADD R4, R2, R4 // R4 = address of ICDISER
AND R2, R0, #0x1F // N mod 32
MOV R5, #1 // enable
LSL R2, R5, R2 // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
LDR R3, [R4] // read current register value
ORR R3, R3, R2 // set the enable bit
STR R3, [R4] // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
BIC R4, R0, #3 // R4 = reg_offset
LDR R2, =0xFFFED800
ADD R4, R2, R4 // R4 = word address of ICDIPTR
AND R2, R0, #0x3 // N mod 4
ADD R4, R2, R4 // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
STRB R1, [R4]
ldmfd sp!, {R4-R5, PC}

/*************************************************************************
* Timer setting
*
************************************************************************/
.global TIMER_SETTING
TIMER_SETTING:

// Write your subroutine here.
// Load the period low (lower 16 bits)
LDR R0, =TIMER_BASE
LDR R1, =0xE100      // low 16 bits
STR R1, [R0, #8]     // write to PeriodL (TIMER_BASE + 0x8)

// Load the period high (upper 16 bits)
LDR R1, =0x05F5      // high 16 bits
STR R1, [R0, #12]    // write to PeriodH (TIMER_BASE + 0xC)

// Enable the timer: bits [3:0] = 0b1111
// bit 3 = stop (0), bit 2 = start (1), bit 1 = continue (1), bit 0 = interrupt enable (1)
// -> Control = 0b111 = 0x7
LDR R1, =0x7
STR R1, [R0, #4]     // write to Control register (TIMER_BASE + 0x4)

BX LR

/*************************************************************************
* Interrupt service routine
*
************************************************************************/
.global INTER_TIMER_ISR
INTER_TIMER_ISR:

// Write your subroutine here.
PUSH {R0-R2, LR}            // Save registers R0-R2 and Link Register to the stack
LDR R0, =UART_ADDR          // Load UART base address into R0

LDR R1, =0x54               // Load ASCII 'T'
STR R1, [R0]                // Write 'T' to UART

LDR R1, =0x69               // Load ASCII 'i'
STR R1, [R0]                // Write 'i' to UART

LDR R1, =0x6D               // Load ASCII 'm'
STR R1, [R0]                // Write 'm' to UART

LDR R1, =0x65               // Load ASCII 'e'
STR R1, [R0]                // Write 'e' to UART

LDR R1, =0x6F               // Load ASCII 'o'
STR R1, [R0]                // Write 'o' to UART

LDR R1, =0x75               // Load ASCII 'u'
STR R1, [R0]                // Write 'u' to UART

LDR R1, =0x74               // Load ASCII 't'
STR R1, [R0]                // Write 't' to UART

LDR R1, =ENTER              // Load newline character (0x0A)
STR R1, [R0]                // Write newline to UART

LDR R0, =TIMER_BASE         // Load Timer base address into R0
MOV R1, #0                  // Clear value (used to reset timeout flag)
STR R1, [R0]                // Write to Status Register to clear the timeout bit

POP {R0-R2, LR}             // Restore R0-R2 and LR from the stack
SUBS PC, LR, #4             // Return from IRQ (adjusted to properly restore CPSR)


/*****************************************
* data section
*
******************************************/
.data
.align
ARR1:
.asciz "Timeout"

.end



