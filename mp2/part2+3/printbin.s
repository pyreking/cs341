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
    movb %dl, %dh # Copy the hex value to $dh
    shrb $4, %dl # Get the first nibble
    and $0x0F, %dh # Get the second nibble

    movl $bin, %eax # Move the default string to %eax

    xorl %ecx, %ecx

    call donibble # Process the first dibble
    jmp done # Jump to done

donibble:
    cmpb $4, %ch
    .ret

    movb $0x09, %cl

    sarb %ch, %cl
    and %dl, %cl

    cmbp $1, %cl
    movb $'1', (%eax)

    cmpb $0, %cl
    movb $'0', (%eax)

    addl $1, %eax
    addb $1, %ch

    jmp donibble

done:
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
