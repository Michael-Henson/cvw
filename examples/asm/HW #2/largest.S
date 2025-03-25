    .section .data
numbers:
    .byte 0x42, 0x37, 0xFD, 0x83, 0x11  # Array of 5 numbers

    .section .text
    .globl _start

_start:
    la a0, numbers      # Load address of numbers array
    lbu t0, 0(a0)       # Load first number into t0 (max value)
    li t1, 4            # Loop counter
    li t2, 1            # Offset for next number

loop:
    add t3, a0, t2     # Load next number
    blt t3, t0, skip    # If t3 < max, skip update
    mv t0, t3           # Update max value

skip:
    addi t2, t2, 1      # Move to next byte in array
    addi t1, t1, -1     # Decrement loop counter
    bne  t1, x0, loop       # Repeat if not zero