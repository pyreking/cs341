   .data

bin:
    .asciz "0000 0000"
    .text
    .globl printbin

printbin:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $4, %esp # Set up local automatic variable

	movb 8(%ebp), %dl # Copy the hex value to %dl
    shrb $4, %dl # Get the first nibble
    movb %dl, %dh # Copy the first nibble to %dh
    # and $0x0F, %dh # Get the second nibble

    movl $bin, %eax # Move the default string to %eax

    xorl %ecx, %ecx
    movb $0x09, %cl

    call donibble # Process the first dibble
    jmp done # Jump to done

donibble:
    sarb $1, %cl
    and %cl, %dh

    addb $0x30, %dh
    movb %dh, (%eax)

    addl $1, %eax
    addb $1, %ch

    movb %dl, %dh

    ret

done:
    subl $1, %eax
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
