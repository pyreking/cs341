    .text
    .global count
count:
    pushl %ebp # Set up stack frame
    movl %esp,%ebp # Save %esp into #ebp.
    subl $8, %esp # Set up local automatic variables

    movl 8(%ebp), %edx # Move the first character of the string into edx.

    xorl %ecx, %ecx # Move 0 into %ecx

loop:
    movzbl (%edx), %eax
    cmpb $97, %al
    je increment
    jmp done

increment:
    addl $1, %ecx
    addl $1, %edx
    jmp loop

done:
    movl %ecx, %eax # Move the counter into eax
    movl %ebp,%esp # restore %esp from %ebp
    popl %ebp # restore %ebp
    ret # Return to the calling function
    .end
