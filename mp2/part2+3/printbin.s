   .text
    .globl mystrncpy

printbin:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $4, %esp # Set up local automatic variable

	movl 8(%ebp), %edx # Copy the destination string into %eax.

    