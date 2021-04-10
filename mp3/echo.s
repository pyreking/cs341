    .text
    .globl echo
    
echo:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $8, %esp # Set up local automatic variables.

    movb 8(%ebp), %dl # Put the serial port into %dl.
    movb 12(%ebp), %bl # Put the escape character into %al.

    xorl %ecx, %ecx # Clear out the %ecx register.
    movw $0x2fc, %dx # Modem control.
    inb (%dx), %al	# Get current.
    orb $0x03, %al	# Or on 2 lsbs.
    outb %al, (%dx)	# Set control.
    movw $0x2fe, %dx # Modem status.

loop1:
    inb (%dx), %al # Get current.
    andb $0xb0, %al # Get 3 signals.
    xorb $0xb0, %al # Check all 3.
    jnz loop1 # Go back to the beginning if some missing.

loop2:
    movw $0x2fd, %dx # Line status.
    inb (%dx), %al # Get data ready.
    andb $0x01, %al # Look at data read.
    jz loop2 # Go back to the beginning if recv data.
    movw $0x2f8, %dx # I/O data address.
    inb (%dx), %al # Move RX to %al.
    movb %al, %cl # Save RX to %cl.
    cmpb %cl, %bl # Check for escape character.
    je done # Jump to done if escape character has been found.
    movw $0x2fd, %dx # Line status.

xmit:
    inb (%dx), %al # Get THRE.
    andb $0x20, %al	# Look at THRE.
    jz loop2 # Go back to loop2 if TX HR empty.
    movb %cl, %al # Get data to send.
    movw $0x2f8, %dx # I/O data address.
    outb %al, (%dx) # Send it.
    jmp loop2 # Go back to loop2 after transmitting the data.

done:
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
