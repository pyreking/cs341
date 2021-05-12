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
    pushl %ebp          # Set up stack frame.
    movl %esp, %ebp     # Save %esp into %ebp.
    subl $4, %esp       # Set up local automatic variables.
    movl 8(%ebp), %edx  # Put the stock price to look for into %edx.
    lea price, %edi     # Load the memory address for price into %edi.
    addl $8, %edi       # Skip the last two months of 2019.

    xorl %ecx, %ecx     # Clear out %ecx to use for counting.

    movl (%edi), %eax   # Move the value stored at the current pointer into %eax.

    cmpl %edx, %eax
    jae increment       # Increment if the current price is equal or above the target price.

check_for_price:
    addl $4, %edi       # Increment the price pointer by 4.
    movl (%edi), %eax   # Move the value stored at the current pointer into %eax.

    cmpl $0, %eax       # Check for the stop code.
    jz done             # Jump to done if the stop code has been reached.
    
    cmpl %edx, %eax     # Compare the target price with the current price.
    jae increment       # Increment if the current price is equal or above the target price.

    jmp check_for_price # Go back to the main loop.

increment:
    addl $1, %ecx       # Increment the price counter.
    jmp check_for_price # Go back to the main loop.

done:
    movl %ebp, %esp     # Restore %esp from %ebp.
    popl %ebp           # Restore %ebp.
    movl %ecx, %eax     # Move the price counter into %eax.
	ret                 # Return to the calling function.
	.end                # End the program.
