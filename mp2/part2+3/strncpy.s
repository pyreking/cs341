    .text
    .globl mystrncpy

mystrncpy:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $12, %esp

	movl 8(%ebp), %ecx # Copy the destination string into %eax.
	movl 12(%ebp), %eax # Copy the source string into %edx.

    xor %edx, %edx

loop1:
    cmpb %dh, 16(%ebp) # Compare %dh with the number of characters to copy.
    je done # Jump to done if the numbers are the same.

    movb (%eax), %dl # Move the current character in %eax to %dl.
    movb %dl, (%ecx) # Move the current character into the current address of %ecx.

    add $1, %dh # Use %dh as a character counter.

    cmpb $0, %dl # Look for a null terminator in %dl.
    jz done # Jump to done if a null terminator is found.
    
    jmp increment # Jump to increment otherwise.

increment:
    addl $1, %eax # Move the destination string forward by one character.
    addl $1, %ecx # Move the source string forward by one character.
    jmp loop1 # Jump back to the main loop.

done:
    movb $0, (%ecx)
    movl 8(%ebp), %eax # Move the copied string into eax.
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
