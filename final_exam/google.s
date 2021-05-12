#GOOG Stock price analysis assembly language program
# google.s
#
          .globl google 
          .data
price:    .long 1260    #11/1/19 price
          .long 1289    #12/1/19 price
          .long 1337    #1/1/20 price
          .long 1434    #2/1/20 price
          .long 1389    #3/1/20 price
          .long 1105    #4/1/20 price
          .long 1320    #5/1/20 price
          .long 1431    #6/1/20 price
          .long 1438    #7/1/20 price
          .long 1482    #8/1/20 price
          .long 1634    #9/1/20 price
          .long 1490    #10/1/20 price
          .long 0       #stop 
          .text
google:
    pushl %ebp # Set up stack frame.
	movl %esp, %ebp # Save %esp into %ebp.
    subl $4, %esp # Set up local automatic variables.
    lea price, %edx
    addl $4, %edx
    movl (%edx), %eax
    
done:
    movl %ebp, %esp # Restore %esp from %ebp.
	popl %ebp # Restore %ebp.
	ret # Return to the calling function.
	.end # End the program
