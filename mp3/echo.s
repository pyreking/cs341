    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $8, %esp # Set up local automatic variables.

    movb 8(%ebp), %edx # Put the comport into %edx.
    movb 12(%ebp), %bl # Put the escape character into %al.

    xorl %ecx, %ecx # Clear out the %ecx register.

    movw $0x2fc, %dx # modem control
    inb (%dx), %al	# get current
    orb $0x03, %al	# or on 2 lsbs
    outb %al, (%dx)	# set control
    movw $0x2fe, %dx # modem status

loop1:
    inb (%dx), %al # get current
    andb $0xb0, %al # get 3 signals
    xorb $0xb0, %al # check all 3
    jnz loop1 # some missing

loop2:
    movw $0x2fd, %dx # line status
    inb (%dx), %al # get data ready
    andb $0x01, %al # look at dr
    jz xmit # if recv data
    movw $0x2f8, %dx # i/o data addr
    inb (%dx), %al # move rx to %al
    movb %al, %cl # save it somewhere
    cmpb %cl, %bl # Check for escape character.
    je done # Jump to done if escape character has been found.
    movw $0x2fd, %dx # line status

xmit:
    inb (%dx), %al # get thre
    andb $0x20, %al	# look at thre
    jz loop2 # if tx hr empty
    movb %cl, %al	# get data to send
    movw $0x2f8, %dx # i/o data addr
    outb %al, (%dx) # send it
    jmp loop2 # and loop

done:
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
