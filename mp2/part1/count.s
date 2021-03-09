    .text
    .global count
count:
    pushl %ebp # Set up stack frame
    movl %esp,%ebp # Save %esp into #ebp.
    subl $8, %esp # Set up local automatic variables

    mov 8(%ebp), %edx # Move the first character of the string into edx.
    addl $1, %edx

    movzbl (%edx), %eax

    movl %ebp,%esp # restore %esp from %ebp
    popl %ebp # restore %ebp
    ret # Return to the calling function
    .end
