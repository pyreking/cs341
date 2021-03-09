    .text
    .global count
count:
    pushl %ebp # Set up stack frame
    movl %esp,%ebp # Save %esp into #ebp.
    subl $8, %esp # Set up local automatic variables

    movl 12(%ebp), %edx # Move the first character of the string into edx.
    xorl %ecx, %ecx # Move 0 into %ecx

loop:
    movzbl (%edx), %eax
    cmpb $97, %eax
    je done
    addl $1, %ecx
    addl $1, %edx
    jmp loop

done:
    xorl %eax, %eax
    movl %ecx, %eax
    movl %ebp,%esp # restore %esp from %ebp
    popl %ebp # restore %ebp
    ret # Return to the calling function
    .end
