/*googlec.c: C driver for the stock analysis function
*/

#include <stdio.h>
extern int google(int number);

int main()
{
  int n, number;
  printf("Enter the stock price to compare:\n");
  scanf("%d", &number);
  
  n = google(number);
  printf("Number of months that goog is equal or above the price of %d in 2020 is:  %d \n", number, n);
  return 0;  
}

