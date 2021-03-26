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
    
    sarb $4, %dl # Get the first nibble
    movb %dl, %dh # Copy the hex value to $dh

    movl $bin, %eax # Move the default string to %eax

    xorl %ecx, %ecx
    movb $3, %cl
    movb $0x8, %ch

    call donibble

    addl $1, %eax

    xorl %ecx, %ecx
    movb $3, %cl
    movb $0x8, %ch

    xorl %edx, %edx

    movb 8(%ebp), %dl
    andb $0xF, %dl

    movb %dl, %dh
    
    call donibble

    jmp done # Jump to done

donibble:
    andb %ch, %dl
    sarb %cl, %dl
    addb $0x30, %dl
    movb %dl, (%eax)
    movb %dh, %dl
    addl $1, %eax
    subb $1, %cl
    sarb $1, %ch

    andb %ch, %dl
    sarb %cl, %dl
    addb $0x30, %dl
    movb %dl, (%eax)
    movb %dh, %dl
    addl $1, %eax
    subb $1, %cl
    sarb $1, %ch

    andb %ch, %dl
    sarb %cl, %dl
    addb $0x30, %dl
    movb %dl, (%eax)
    movb %dh, %dl
    addl $1, %eax
    subb $1, %cl
    sarb $1, %ch

    andb %ch, %dl
    sarb %cl, %dl
    addb $0x30, %dl
    movb %dl, (%eax)
    movb %dh, %dl
    addl $1, %eax
    subb $1, %cl
    sarb $1, %ch

    ret

done:
    subl $9, %eax
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
