/******************************************************************
*
*   file:     cmds.c
*   author:   betty o'neil
*   date:     ?
*
*   semantic actions for commands called by tutor (cs341, mp1)
*
*   revisions:
*      9/90  eb   cleanup, convert function declarations to ansi
*      9/91  eb   changes so that this can be used for hw1
*      9/02  re   minor changes to quit command
*/
/* the Makefile arranges that #include <..> searches in the right
   places for these headers-- 200920*/

#include <stdio.h>
#include "slex.h"

/*===================================================================*
*
*   Command table for tutor program -- an array of structures of type
*   cmd -- for each command provide the token, the function to call when
*   that token is found, and the help message.
*
*   slex.h contains the typdef for struct cmd, and declares the
*   cmds array as extern to all the other parts of the program.
*   Code in slex.c parses user input command line and calls the
*   requested semantic action, passing a pointer to the cmd struct
*   and any arguments the user may have entered.
*
*===================================================================*/

PROTOTYPE int stop(Cmd *cp, char *arguments);
PROTOTYPE int mem_display(Cmd *cp, char *arguments);
PROTOTYPE int mem_set(Cmd *cp, char *arguments);
PROTOTYPE int help(Cmd *cp, char *arguments);

/* command table */

/* 
 * mem_display: Display the hexadecimal value of a memory address and
 *              the 15 other values immediately after it.

 * mem_set: Set a memory address to a specific hexadecimal value.
 * 
 * help: Print the help message for a specified function.
 *       If there is no valid argument, print the help
 *       message for every function.
 * 
 * stop: Stop the program.
 * 
*/
Cmd cmds[] = {{"md",  mem_display, "Memory display: MD <addr>"},
              {"ms", mem_set, "Memory set: MS <addr> <value>"},
              {"h", help, "Help: H <command>"},
              {"s",   stop,        "Stop" },
              {NULL,  NULL,        NULL}};  /* null cmd to flag end of table */

char xyz = 6;  /* test global variable  */
char *pxyz = &xyz;  /* test pointer to xyz */
/*===================================================================*
*		command			routines
*
*   Each command routine is called with 2 args, the remaining
*   part of the line to parse and a pointer to the struct cmd for this
*   command. Each returns 0 for continue or 1 for all-done.
*
*===================================================================*/

int stop(Cmd *cp, char *arguments)
{
  return 1;			/* all done flag */
}

/*===================================================================*
*
*   mem_display: display contents of 16 bytes in hex
*
*/

// Display the hexadecimal value of a memory address and
// the 15 other values immediately after it.
int mem_display(Cmd *cp, char *arguments)
{
  // An unsigned integer for storing the hexadecimal value of 
  // the memory address.
  unsigned int address;
  // An index counter for printing out the hexadecimal
  // value of the memory address and the 15 other values
  // immediately after it.
  int i;

  // Convert the argument into an unsigned hexadecimal integer.
  // If the user does not provide enough arguments for this
  // function, print out the help message for mem_display.
  if (sscanf(arguments, "%x", &address) == 1) {
    // Create a new char pointer that points to the
    // unsigned integer in memory.
    unsigned char *ptr;
    // Cast the memory address to an unsigned char pointer and
    // assign it to the ptr pointer.
    ptr = (unsigned char *) address;

    // Print the hexadecimal value of the memory address.
    printf("%08x    ", address);

    // Print out the hexadecimal value for the memory address
    // and the 15 other values immediately next to it.
    for (i = 0; i < 16; i++) {
      // Dereference the ptr point at the specified index and
      // print it as a hexadecimal integer.
      printf("%02x ", *(ptr + i));
    }

    // Print out the ASCII character that corresponds with each
    // hexadecimal value of the memory address and the 15 other
    // values immediately next to it.
    for (i = 0; i < 16; i++) {
      // Only print out ASCII characters that can printed
      // on a terminal.
      if (ptr[i] >= 0x20 && ptr[i] <= 0x7E) {
        printf("%c", *(ptr + i));
      } else {
        // If the ASCII character is not printable, print a period
        // instead.
        printf(".");
      }
    }
    // Print a new line after display the hexadecimal value of the
    // memory address and the 15 other values immediately after it.
    printf("\n");
  } else{
  // Print out the help message for mem_display if the user does not
  // use the right number of arguments.
  printf("%8s    %s\n", cp->cmdtoken, cp->help);
  }
  // Return 0 to continue the program.
  return 0;
}

// Set a memory address to a specific hexadecimal value.
int mem_set(Cmd *cp, char *arguments)
{
  // An unsigned integer for storing the hexadecimal value of 
  // the memory address.
  unsigned int address;
  // An unsigned integer for storing the new hexadecimal value
  // for the memory address.
  unsigned int new_value;
  // Convert the argument into an unsigned hexadecimal integer.
  // If the user does not provide enough arguments for this function,
  // print out the help message for mem_display.
  if (sscanf(arguments, "%x %x", &address, &new_value) == 2) {
    // Create a new char pointer that points to the
    // unsigned integer in memory.
    unsigned char *ptr;
    // Cast the memory address to an unsigned char pointer and
    // assign it to the ptr pointer.
    ptr = (unsigned char *) address;
    // Assign a new hexadecimal value to the memory address.
    *ptr = new_value;
  } else {
  // Print out the help message for mem_set if the user does not
  // use the right number of arguments.
    printf("%8s    %s\n", cp->cmdtoken, cp->help);
  }
  // Return 0 to continue the program.
  return 0;
}

// Print the help message for a specified function.
// If there is no valid argument, print the help
// message for every function.
int help(Cmd *cp, char *arguments)
{

  // The current index of the cmds array.
  int cnum;
  // The current position in the line buffer
  // used by the slex function.
  int pos;
  // Parse the arguments with the slex function
  // and store the success or failure of the function
  // in an integer.
  int success = slex(arguments, cmds, &cnum, &pos);

  // If the user does not give an argument or gives
  // an invalid argument with the help function,
  // print out the help message for every function.
  if (arguments[0] == '\0' || success < 0) {
    // Iterate over all of the cmd tokens in cmds.
    for (cp = cmds; cp->cmdtoken; cp++) {
        // Print the help message associated with the
        // current command.
        printf("%8s    %s\n", cp->cmdtoken, cp->help);
    }
    // If the user gives a valid function as an argument,
    // only print out the help message associated with
    // that function.
  } else {
      printf("%8s    %s\n", cmds[cnum].cmdtoken, cmds[cnum].help);
  }

  // Return 0 to continue the program.
  return 0;
}