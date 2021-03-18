    .text
    .global count
count:
    pushl %ebp # Set up stack frame.
    movl %esp,%ebp # Save %esp into #ebp.
    subl $8, %esp # Set up local automatic variables.

    movl 8(%ebp), %edx # Move the first character of the string into edx.
    xorl %ecx, %ecx # Clear out %ecx for counting.

loop:
    movzbl (%edx), %eax # Move the value of the current character into eax
    cmpb $0, %al # Search for a null terminator.
    je done # Jump to done if a null terminator has been found.
    addl $1, %edx # Move the string forward by 1.
    jmp compare # Compare the value of %al with the target value.

compare:
    cmpb 12(%ebp), %al # Compare the value of %al with the target value.
    je increment # Increment %ecx if the values are the same.
    jmp loop # Go back to the main loop otherwise.

increment:
    addl $1, %ecx # Increment %ecx by 1 if the target character
		  # has been found in %al.
    jmp loop # Go back to the main loop.

done:
    movl %ecx, %eax # Move the letter counter into eax.
    movl %ebp,%esp # Restore %esp from %ebp.
    popl %ebp # Restore %ebp
    ret # Return to the calling function
    .end
