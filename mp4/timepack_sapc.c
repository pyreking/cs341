
/******************************************************************
*
*   file:      timepack_sapc.c
*   author:    Betty O'Neil
*   date:      '88 (MECB)
*
*   revisions: Ethan Bolker, October 1990 to #include header file timepack.h
*              Betty O'Neil, March 1992 to add inittimer
*              Betty O'Neil, S96 to SAPC
*              Bob Wilson, spring 2014
*
*   SAPC timing package.
*   Link with code containing calls to stoptimer, starttimer
*
*   To do:
*      Implement static flag set when timer is running
*        (for now everything returns T_OK)
*/

/* constants and prototypes for timing package primitives */
#include <stdio.h>
#include "timepack.h"
#include <timer.h>
#include <pic.h>
#include <cpu.h>

typedef enum { FALSE, TRUE } Boolean;

/* PC's 8254 timer: one tick consists of 64K counts at 1193182 counts/sec */
#define COUNTS_PER_SEC 1193182 
#define COUNTS_PER_TICK (64*1024)
/* This is a double constant--see K&R, p. 37.  Doubles are great for
 conversion constants.  Just convert back to int at end if apprpriate */
#define USECS_PER_TICK (1000000.0*COUNTS_PER_TICK/COUNTS_PER_SEC)
/* precision = time between possible values, in us */
#define TIMER_PRECISION 1

extern const IntHandler irq0inthand;

// The current number of ticks.
static int tickcount;
// The current number of downcounts.
static int downcount;

// The starting number of downcounts before an event.
static int startcount;
// The ending number of downcounts after an event.
static int endcount;

// Is the timer running or not?
static int timer_running;

// How long it took for an event to occur in microseconds.
static double microseconds;

void set_timer_count(int count);
void irq0inthandc(void);
void smalldelay(void);

/* set timer ticking.  This is called only once at start of program */
void inittimer()
{
  tickcount = 0;
#ifdef DEBUG
  printf("Disabling interrupts in CPU while setting them up\n");
#endif
  cli();
#ifdef DEBUG  
  printf("Setting interrupt gate for timer, irq 0\n");
#endif
  /* irq 0 maps to slot n = 0x20 in IDT for linux setup */
  set_intr_gate(TIMER0_IRQ+IRQ_TO_INT_N_SHIFT, &irq0inthand);
#ifdef DEBUG
  printf("Commanding PIC to interrupt CPU for irq 0\n");
#endif
  pic_enable_irq(TIMER0_IRQ);
  timer_running = 0;		/* starts running at call to starttimer */
#ifdef DEBUG
  printf("Commanding timer to generate a pulse train using max count\n");
#endif
  set_timer_count(0);	
#ifdef DEBUG
  printf("Enabling interrupts in CPU\n");
#endif
  sti();
}

/* This is NEEDED: future ints could find bogus int handler after this
 * code is overwritten by next download or whatever, requiring reboot.
 * This is called once at end of program.
 */
void shutdowntimer()
{
  cli();
#ifdef DEBUG
  printf("Commanding PIC to shut off irq 0 to CPU\n");
#endif
  pic_disable_irq(TIMER0_IRQ);	/* disallow irq 0 ints to get to CPU */
  sti();
}

/*  for the SAPC case:  microsecond precision (though not microsecond
 *  *accuracy* because of various overhead times involved)
*/
void querytimer(int *precision, int *running)
{
   *precision = TIMER_PRECISION;
   *running = timer_running;
   return;
}

/* start a timed experiment: improve this along with stoptimer */
int starttimer()
{
  // Record the starting downcount.
  outpt(TIMER_CNTRL_PORT, TIMER0 |TIMER_LATCH);
  downcount = inpt(TIMER0_COUNT_PORT);
  downcount |= (inpt(TIMER0_COUNT_PORT) << 8);
  smalldelay();

  // Calculate the starting count in terms of downcounts.
  startcount = (tickcount * COUNTS_PER_TICK) + (COUNTS_PER_TICK - downcount);

  // Turn on the timer.
  timer_running = TRUE;

  return T_OK;
}

/* temporary crude way: better to read the counter and add in the downcounts
 * (converted to us) since the last tick, and similarly change starttime 
 * to record the starting downcount, and adjust for another partial tick.
 * Remember that printf takes a *lot* of time!!  Don't do it during experiments.
 */
int stoptimer( int *interval )
{
  // Record the ending downcount.
  outpt(TIMER_CNTRL_PORT, TIMER0 |TIMER_LATCH);
  downcount = inpt(TIMER0_COUNT_PORT);
  downcount |= (inpt(TIMER0_COUNT_PORT) << 8);
  smalldelay();

  // Calculate the ending count in terms of downcounts.
  endcount = (tickcount * COUNTS_PER_TICK) + (COUNTS_PER_TICK - downcount);

  // Calculate the total number of downcounts that occurred during this event
  // and convert the result to microseconds.
  microseconds = (double) (endcount - startcount) * (1000000.0 / COUNTS_PER_SEC);

  // Convert the microseconds constant to an integer and save it to interval.
  *interval = (int) microseconds;

#ifdef DEBUG
  printf("stoptimer reached, returning inaccurate time until fixed\n");
#endif
  timer_running = FALSE;
  return T_OK;
}

/* about 10 us on a SAPC (400Mhz Pentium) */
void smalldelay(void)
{
  int i;
  
  for (i=0;i<1000;i++)
    ;
}

/* Set up timer to count down from given count, then send a tick interrupt, */
/* over and over. A count of 0 sets max count, 65536 = 2**16 */
void set_timer_count(int count)
{
  outpt(TIMER_CNTRL_PORT, TIMER0|TIMER_SET_ALL|TIMER_MODE_RATEGEN);
  outpt(TIMER0_COUNT_PORT,count&0xff); /* set LSB here */
  outpt(TIMER0_COUNT_PORT,count>>8); /* and MSB here */
  smalldelay();			/* give the timer a moment to init. */
}

/* timer interrupt handler */
void irq0inthandc(void)
{
  pic_end_int();		/* notify PIC that its part is done */
  tickcount++;			/* count the tick in global var */
}
