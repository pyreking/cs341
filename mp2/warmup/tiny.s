    .global _start
_start:
    movl $8, %eax
    addl $3, %eax
    movl %eax, 0x200
    int $3
    .end
