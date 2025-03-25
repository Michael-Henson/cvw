.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
    li a0, 0x42
    li a1, 0xED
    add a0, a0, a1