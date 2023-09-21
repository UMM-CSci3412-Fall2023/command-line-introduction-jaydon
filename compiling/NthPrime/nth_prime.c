#include <stdio.h>
#include <stdlib.h>

#include "nth_prime.h"

int prime_count;
int* primes;
int candidate;

bool isPrime(int candidate) {
  int i;
  for (i = 0; i < prime_count; ++i) {
    if (candidate % primes[i] == 0) {
      return FALSE;
    }
  }
  return TRUE;
}

int nth_prime(int n) {
  // Allocate the array to store primes in as they're found
  primes = calloc(n, sizeof(int));

  // Put the first two primes in the array
  primes[0] = 2;
  primes[1] = 3;
  prime_count = 2;
  candidate = 5;

  while (prime_count < n) {
    if (isPrime(candidate)) {
      primes[prime_count] = candidate;
      ++prime_count;
    }
    candidate += 2;
  }

  return primes[n-1];
}

