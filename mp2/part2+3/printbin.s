   .data

bin:
    .asciz "0000 0000" # The ASCII string to return
    .text
    .globl printbin

printbin:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $4, %esp # Set up local automatic variable.

	movb 8(%ebp), %dl # Copy the hex value to %dl.
    
    sarb $4, %dl # Get the first nibble.
    movb %dl, %dh # Copy the first nibble to $dh.

    movl $bin, %eax # Move the default string to %eax.

    xorl %ecx, %ecx # Clear out the %ecx register.
    movb $3, %cl # Move $3 to the %cl register.
    movb $0x8, %ch # Move $0x8 to the %ch register.

    call donibble # Put the first nibble into the string.

    addl $1, %eax # Skip over the space character.

    xorl %ecx, %ecx # Clear out the %ecx register.
    movb $3, %cl # Move $3 to the %cl register.
    movb $0x8, %ch # Move $0x8 to the %ch register.

    xorl %edx, %edx # Clear out the %edx register.

    movb 8(%ebp), %dl # Copy the hex value to the %dl register.
    andb $0xF, %dl # Get the second nibble.

    movb %dl, %dh # Copy the second nibble to %dh.
    
    call donibble # Put the second nibble into the string.

    jmp done # Jump to done

donibble:
    andb %ch, %dl # Get the four binary digits for the nibble.
    sarb %cl, %dl # Apply a mask to the nibble to get the first binary digit.
    addb $0x30, %dl # Add $0x30 to the binary digit to get the correct ASCII value.
    movb %dl, (%eax) # Move the first binary digit into the string.
    movb %dh, %dl # Copy the current nibble back into %dl.
    addl $1, %eax # Move the char pointer forward by 1.
    subb $1, %cl # Decrease the number of bits to shift.
    sarb $1, %ch # Shift the bit mask for the next binary digit.

    andb %ch, %dl # Get the the lower three binary digits for the nibble.
    sarb %cl, %dl # Apply a mask to the nibble to get the second binary digit.
    addb $0x30, %dl # Add $0x30 to the binary digit to get the correct ASCII value.
    movb %dl, (%eax) # Move the second binary digit into the string.
    movb %dh, %dl # Copy the current nibble back into %dl.
    addl $1, %eax # Move the char pointer forward by 1.
    subb $1, %cl # Decrease the number of bits to shift.
    sarb $1, %ch # Shift the bit mask for the next binary digit.

    andb %ch, %dl # Get the the lower two binary digits for the nibble.
    sarb %cl, %dl # Apply a mask to the nibble to get the third binary digit.
    addb $0x30, %dl # Add $0x30 to the binary digit to get the correct ASCII value.
    movb %dl, (%eax) # Move the third binary digit into the string.
    movb %dh, %dl # Copy the current nibble back into %dl.
    addl $1, %eax # Move the char pointer forward by 1.
    subb $1, %cl # Decrease the number of bits to shift.
    sarb $1, %ch # Shift the bit mask for the next binary digit.

    andb %ch, %dl # Get the the last binary for the nibble.
    sarb %cl, %dl # Apply a mask to the nibble to get the fourth binary digit.
    addb $0x30, %dl # Add $0x30 to the binary digit to get the correct ASCII value.
    movb %dl, (%eax) # Move the fourth binary digit into the string.
    movb %dh, %dl # Copy the current nibble back into %dl.
    addl $1, %eax # Move the char pointer forward by 1.
    subb $1, %cl # Decrease the number of bits to shift.
    sarb $1, %ch # Shift the bit mask for the next binary digit.

    ret # Return to caller

done:
    subl $9, %eax # Move the char pointer to the first character.
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
