    .text
    .global count
count:
    pushl %ebp # Set up stack frame
    movl %esp,%ebp # Save %esp into #ebp.
    subl $8, %esp # Set up local automatic variables

    movl 12(%ebp), %edx # Move the first character of the string into edx.
    mov (%edx), %eax #Put edx into eax.


done:
    movl %ebp,%esp # restore %esp from %ebp
    popl %ebp # restore %ebp
    ret # Return to the calling function
    .end
