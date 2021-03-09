    .text
    .global count
count:
    pushl %ebp # Set up stack frame
    movl %esp,%ebp # Save %esp into #ebp.
    subl $8, %esp # Set up local automatic variables

    movl 8(%ebp), %edx # Move the first character of the string into edx.
    xorl %ecx, %ecx # Clear out %ecx for counting.

loop:
    movzbl (%edx), %eax # Move the value of the current char into eax
    cmpb $0, %al # Search for a null terminator
    je done # Jump to done if a null terminator is found
    addl $1, %edx # Move the char pointer forward by 1
    jmp compare # Compare with the target value

compare:
    cmpb 12(%ebp), %al
    je increment
    jmp loop

increment:
    addl $1, %ecx
    jmp loop

done:
    movl %ecx, %eax # Move the counter into eax
    movl %ebp,%esp # restore %esp from %ebp
    popl %ebp # restore %ebp
    ret # Return to the calling function
    .end
