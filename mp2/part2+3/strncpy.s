    .text
    .globl mystrncpy

mystrncpy:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
	movl 8(%ebp), %eax # Copy the destination string into %eax.
	movl 12(%ebp), %edx # Copy the source string into %edx.
    xorl %ecx, %ecx # Clear out %ecx for counting.

loop1:
    movb (%edx), %dl # Move the current character in %edx to %dl.
    movb (%edx), %eax # Move the current character into the current address of %eax.
    addl $1, %ecx # Increment the character counter by 1.

    # cmpb $0, %dl # Check for the null terminator in the source string.
    # jz done # Jump to done if there are no more characters to copy.

    # cmpb $0, %al # Check for the null terminator in the destination string.
    # jz done # Jump to done if there are no more characters to copy.

    cmpl %ecx, 16(%ebp) # Compare the character counter to the number of characters to copy.
    je done # Jump to done if all of the characters have been copied.
    
    jmp increment # Jump to increment otherwise.

# loop2:
    # cmpl %ecx, 16(%ebp) # Compare the character counter to the number of characters to copy.
    # je done # Jump to done if all of the characters have been copied.

    # cmpb $0, %al # Check for a null terminator in the destination string.
    # jz done  # Jump to done if the current character in the destination string is a null character.

    # movb $0, %al # Fill the current character in the destination string with a null character.
    # incl %eax # Move the destination string forward by 1.
    # jmp loop2 # Jump to loop2.

increment:
    incl %edx # Move the source string forward by one character.
    incl %eax # Move the destination string forward by one character.
    jmp loop1 # Jump back to the main loop.

done:
    movl 8(%ebp), %eax # Move the copied string into eax.
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
